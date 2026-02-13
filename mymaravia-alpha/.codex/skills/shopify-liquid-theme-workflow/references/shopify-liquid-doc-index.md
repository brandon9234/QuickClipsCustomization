# Shopify + Liquid Official Doc Index

Use this file as the primary source map for theme work in this repository.

## Core Liquid

- Liquid overview: https://shopify.dev/docs/api/liquid
- Liquid objects: https://shopify.dev/docs/api/liquid/objects
- Liquid tags: https://shopify.dev/docs/api/liquid/tags
- Liquid filters: https://shopify.dev/docs/api/liquid/filters
- `render` tag: https://shopify.dev/docs/api/liquid/tags/render

## Theme Architecture (Online Store 2.0)

- Architecture overview: https://shopify.dev/docs/storefronts/themes/architecture
- Layouts: https://shopify.dev/docs/storefronts/themes/architecture/layouts
- Templates: https://shopify.dev/docs/storefronts/themes/architecture/templates
- JSON templates: https://shopify.dev/docs/storefronts/themes/architecture/templates/json-templates
- Sections: https://shopify.dev/docs/storefronts/themes/architecture/sections
- Section schema: https://shopify.dev/docs/storefronts/themes/architecture/sections/section-schema
- Theme block schema: https://shopify.dev/docs/storefronts/themes/architecture/blocks/theme-blocks/schema

## Theme Config + Localization

- Settings architecture: https://shopify.dev/docs/storefronts/themes/architecture/settings
- `config/settings_schema.json`: https://shopify.dev/docs/storefronts/themes/architecture/config/settings-schema-json
- `config/settings_data.json`: https://shopify.dev/docs/storefronts/themes/architecture/config/settings-data-json
- Locale files: https://shopify.dev/docs/storefronts/themes/architecture/locales/storefront-locale-files

## Shopify CLI + Validation

- Shopify CLI for themes: https://shopify.dev/docs/storefronts/themes/tools/cli
- `shopify theme dev`: https://shopify.dev/docs/api/shopify-cli/theme/theme-dev
- `shopify theme pull`: https://shopify.dev/docs/api/shopify-cli/theme/theme-pull
- `shopify theme push`: https://shopify.dev/docs/api/shopify-cli/theme/theme-push
- Theme Check: https://shopify.dev/docs/storefronts/themes/tools/theme-check

## High-Value Filters + Objects

- `image_url` filter: https://shopify.dev/docs/api/liquid/filters/image_url
- `image_tag` filter: https://shopify.dev/docs/api/liquid/filters/image_tag
- `asset_url` filter: https://shopify.dev/docs/api/liquid/filters/asset_url
- Metafield output filters (`metafield_tag`): https://shopify.dev/docs/api/liquid/filters/metafield-filters#metafield_tag
- `section` object: https://shopify.dev/docs/api/liquid/objects/section
- `theme` object: https://shopify.dev/docs/api/liquid/objects/theme

## Theme Editor Integration

- Integrate with section/block selection events: https://shopify.dev/docs/storefronts/themes/best-practices/editor/integrate-sections-and-blocks

## Performance

- Performance best practices: https://shopify.dev/docs/storefronts/themes/best-practices/performance

## Repo Rules Derived From Docs

1. Use `image_tag` only with image objects or values produced by `image_url`.
2. Use `asset_url` for files from `/assets` and render with a normal `img` element.
3. Keep JSON template `sections` count within Shopify limits.
4. Keep section schema and template JSON in sync when adding/removing sections.
5. Prefer section settings/locales over hardcoded strings for merchant-editable text.
6. Run validation before and after edits using:
```powershell
powershell -ExecutionPolicy Bypass -File .codex/skills/shopify-liquid-theme-workflow/scripts/shopify-preflight.ps1
```

## Practical Commands

```powershell
# Preview with hot reload
shopify theme dev --store <your-store.myshopify.com> --theme-editor-sync

# Pull remote theme into local files
shopify theme pull --store <your-store.myshopify.com> --theme <theme-id>

# Push local updates to a non-live theme
shopify theme push --store <your-store.myshopify.com> --theme <theme-id>

# Run lints/checks
shopify theme check --path .
```
