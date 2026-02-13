## Repo Workflow

- Always use the `shopify-liquid-theme-workflow` skill for Shopify theme tasks in this repository.
- Before editing any `.liquid`, `.json`, `config/*`, `sections/*`, `snippets/*`, `templates/*`, or `assets/*` files, run:
```powershell
powershell -ExecutionPolicy Bypass -File .codex/skills/shopify-liquid-theme-workflow/scripts/shopify-preflight.ps1
```
- After edits, run the same preflight command again and report results.
- Use official docs listed in `.codex/skills/shopify-liquid-theme-workflow/references/shopify-liquid-doc-index.md` as the primary implementation source.
- For theme assets, do not pipe `asset_url` into `image_tag`. Use `asset_url` with a normal `img` element.
