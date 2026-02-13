param(
  [string]$ThemeRoot = "."
)

$ErrorActionPreference = "Stop"
$rootPath = (Resolve-Path $ThemeRoot).Path
$errors = New-Object System.Collections.Generic.List[string]
$warnings = New-Object System.Collections.Generic.List[string]

function Add-Error([string]$message) {
  $script:errors.Add($message)
  Write-Host "[ERROR] $message" -ForegroundColor Red
}

function Add-Warn([string]$message) {
  $script:warnings.Add($message)
  Write-Host "[WARN]  $message" -ForegroundColor Yellow
}

function Get-PropertyNames([object]$obj) {
  if ($null -eq $obj) { return @() }
  if ($obj -is [System.Collections.IDictionary]) { return @($obj.Keys) }
  return @($obj.PSObject.Properties.Name)
}

function Get-PropertyValue([object]$obj, [string]$name) {
  if ($null -eq $obj) { return $null }
  if ($obj -is [System.Collections.IDictionary]) { return $obj[$name] }
  $property = $obj.PSObject.Properties[$name]
  if ($null -eq $property) { return $null }
  return $property.Value
}

Write-Host "Shopify preflight: $rootPath" -ForegroundColor Cyan

# 1) Validate expected theme structure.
$requiredDirs = @("assets", "layout", "sections", "snippets", "templates", "config")
foreach ($dir in $requiredDirs) {
  $full = Join-Path $rootPath $dir
  if (-not (Test-Path -Path $full -PathType Container)) {
    Add-Error "Missing required theme directory: $dir"
  }
}

# 2) Validate JSON templates and section-group limits (best-effort).
$jsonFiles = Get-ChildItem -Path $rootPath -Recurse -File -Filter *.json | Where-Object {
  $_.FullName -match "\\templates\\|\\sections\\"
}

foreach ($file in $jsonFiles) {
  try {
    $raw = Get-Content -Raw -Path $file.FullName
    $normalized = $raw -replace "^\uFEFF", ""
    $normalized = [regex]::Replace($normalized, "^\s*/\*[\s\S]*?\*/\s*", "")
    $json = $normalized | ConvertFrom-Json
  } catch {
    Add-Warn "Skipping non-standard JSON parse: $($file.FullName)"
    continue
  }

  $sections = Get-PropertyValue -obj $json -name "sections"
  if ($null -ne $sections) {
    $sectionIds = Get-PropertyNames -obj $sections
    $sectionCount = $sectionIds.Count
    if ($sectionCount -gt 25) {
      Add-Error "$($file.FullName): sections count is $sectionCount (Shopify limit is 25)."
    }

    foreach ($sectionId in $sectionIds) {
      $sectionConfig = Get-PropertyValue -obj $sections -name $sectionId
      $blocks = Get-PropertyValue -obj $sectionConfig -name "blocks"
      if ($null -ne $blocks) {
        $blockCount = (Get-PropertyNames -obj $blocks).Count
        if ($blockCount -gt 50) {
          Add-Error "$($file.FullName): section '$sectionId' has $blockCount blocks (Shopify limit is 50)."
        }
      }
    }
  }
}

# 3) Detect common Liquid image mistakes that break rendering.
$liquidFiles = Get-ChildItem -Path $rootPath -Recurse -File -Filter *.liquid
$imagePatterns = @(
  "asset_url\s*\|\s*image_tag",
  "'[^']+\.(png|jpe?g|webp|gif|svg)'\s*\|\s*image_tag",
  """[^""]+\.(png|jpe?g|webp|gif|svg)""\s*\|\s*image_tag"
)

foreach ($pattern in $imagePatterns) {
  $matches = $liquidFiles | Select-String -Pattern $pattern
  foreach ($match in $matches) {
    Add-Error "$($match.Path):$($match.LineNumber) suspicious image filter chain: $($match.Line.Trim())"
  }
}

# 4) Run Shopify Theme Check if CLI is installed.
$shopifyCmd = Get-Command shopify -ErrorAction SilentlyContinue
if ($null -eq $shopifyCmd) {
  Add-Warn "Shopify CLI not found. Skipping 'shopify theme check --path .'."
} else {
  Write-Host "Running: shopify theme check --path ." -ForegroundColor Cyan
  Push-Location $rootPath
  try {
    & shopify theme check --path .
    if ($LASTEXITCODE -ne 0) {
      Add-Warn "Shopify Theme Check reported issues (exit code $LASTEXITCODE)."
    }
  } finally {
    Pop-Location
  }
}

Write-Host ""
Write-Host "Preflight summary: $($errors.Count) error(s), $($warnings.Count) warning(s)." -ForegroundColor Cyan

if ($errors.Count -gt 0) {
  exit 1
}

exit 0
