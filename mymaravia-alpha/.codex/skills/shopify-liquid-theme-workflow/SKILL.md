---
name: shopify-liquid-theme-workflow
description: Use official Shopify and Liquid documentation to implement, debug, and validate Online Store 2.0 theme work in this repository. Trigger when editing `.liquid` files, section schema, JSON templates, assets, theme settings, localization files, or when running Shopify CLI preview/push/pull/check commands.
---

# Shopify Liquid Theme Workflow

## Overview

Use this workflow to make safe, documentation-aligned Shopify theme changes. Follow the preflight script before and after edits, and reference the official doc map in `references/shopify-liquid-doc-index.md`.

## Workflow

1. Run preflight checks:
```powershell
powershell -ExecutionPolicy Bypass -File .codex/skills/shopify-liquid-theme-workflow/scripts/shopify-preflight.ps1
```
2. Choose the closest official docs from `references/shopify-liquid-doc-index.md` before coding.
3. Implement the minimum file changes needed.
4. Re-run preflight checks.
5. If Shopify CLI is available, preview with:
```powershell
shopify theme dev --store <your-store.myshopify.com> --theme-editor-sync
```

## Decision Rules

- For images from Shopify objects (`product.featured_image`, `collection.image`, `block.settings.image`, `images[...]`), use `image_url` then `image_tag`.
- For files in `assets/`, use `asset_url` in an `img` element; do not pipe `asset_url` into `image_tag`.
- Keep JSON template section counts within Shopify limits (preflight checks this).
- Preserve section/schema compatibility when adding settings or blocks.
- Prefer `render` over legacy `include`.

## Files In This Skill

- `references/shopify-liquid-doc-index.md`: curated official Shopify/Liquid documentation map and repo rules.
- `scripts/shopify-preflight.ps1`: local automated checks for theme structure, JSON limits, and common Liquid image filter mistakes.

## Expected Output Style

Report:
1. What changed.
2. Which official docs informed the change.
3. Preflight results and unresolved warnings.
