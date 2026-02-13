# QuickClipsCustomization

This workspace is prepared for Shopify theme development in VS Code.

## What is already done
- Installed Node.js LTS (`v24.13.1`)
- Installed npm (`11.8.0`)
- Installed Shopify CLI (`3.90.1`)
- Installed VS Code extensions:
  - `Shopify.theme-check-vscode`
  - `sissel.shopify-liquid`
  - `esbenp.prettier-vscode`
- Added workspace settings in `.vscode/settings.json`
- Scaffolded a starter theme in `quickclips-theme/` using `shopify theme init`
- Verified the theme with `shopify theme check` (no offenses)

## First run (you must do this once with your store account)
Run these in VS Code terminal from repo root:

```bash
shopify auth login
shopify theme pull --store your-store.myshopify.com --live --path quickclips-theme
```

If you want to start from the scaffolded starter instead of pulling live theme files, skip `theme pull`.

## Start local development
```bash
shopify theme dev --store your-store.myshopify.com --path quickclips-theme
```

## Useful commands
```bash
shopify theme check --path quickclips-theme
shopify theme push --store your-store.myshopify.com --path quickclips-theme
```

## PowerShell note
This machine blocks `.ps1` command shims by execution policy. If you use PowerShell and `shopify` fails, run:

```powershell
shopify.cmd theme dev --store your-store.myshopify.com --path quickclips-theme
```

The workspace terminal default is set to **Command Prompt** to avoid this issue.
