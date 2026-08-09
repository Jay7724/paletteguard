# Design Notes

PaletteGuard is intentionally narrow. It is a reusable MoonBit contrast
library, not a CSS parser, image analyzer, or browser automation tool.

## Boundaries

The package owns:

- color token parsing for a small stable syntax set
- WCAG luminance and contrast math
- role-aware palette pair selection
- report generation
- tests for normal, invalid, boundary, and export behavior

The package does not own:

- reading files from a design-token format
- screenshot capture
- alpha compositing
- full CSS Color Level 4 support
- automatic theme rewriting

Those features can be added later without changing the core audit model.

## Error Strategy

Parsing returns explicit result enums instead of raising exceptions. This makes
the API predictable for CLI tools and CI checks where all invalid tokens should
be reported rather than crashing the first time a token fails.

## Maintenance Value

The core can be reused by:

- MoonBit documentation sites that need accessible color tables
- terminal theme packages
- charting libraries
- dashboard or component libraries compiled to Wasm
- release gates that snapshot Markdown evidence
