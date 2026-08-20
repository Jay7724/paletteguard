# Design Notes

PaletteGuard is intentionally narrow. It is a reusable MoonBit contrast
library, not a CSS parser, image analyzer, or browser automation tool.

## Boundaries

The package owns:

- color token parsing for a small stable syntax set
- WCAG luminance and contrast math
- role-aware palette pair selection
- RGB/HSL transforms used for deterministic palette repair
- black/white and lighten/darken repair candidate search
- line-oriented design-token document parsing with diagnostics
- palette statistics, contrast matrices, and ramp audits
- an original built-in semantic palette catalog for examples and regression
  fixtures
- report generation
- tests for normal, invalid, boundary, and export behavior

The package does not own:

- reading files from disk or network
- screenshot capture
- alpha compositing
- full CSS Color Level 4 support
- automatic theme rewriting

Those features can be added later without changing the core audit model.

## Error Strategy

Parsing returns explicit result enums instead of raising exceptions. This makes
the API predictable for CLI tools and CI checks where all invalid tokens should
be reported rather than crashing the first time a token fails.

Token document parsing follows the same rule. It returns successfully parsed
swatches together with warnings and errors, so a calling CLI can show all
problems in one report.

## Repair Strategy

PaletteGuard repair functions are deliberately deterministic. They do not
attempt subjective brand redesign. Instead they search bounded paths toward
black, white, lighter backgrounds, or darker backgrounds and return the first
candidate that satisfies the selected WCAG policy.

The search uses one-percent steps on bounded paths. When both directions can
pass, it prefers the smaller RGB distance; when only one direction passes, it
prefers that passing candidate; when neither can pass, it keeps the strongest
available contrast. This keeps automated CI output explainable:
reviewers can see which token was adjusted, how far it moved, and the final
contrast ratio.

## Catalog Strategy

The built-in catalog is original synthetic palette data created for this
project. It gives examples, tests, and downstream users a stable source of
semantic swatches without depending on third-party color systems.

Each catalog family has 13 steps from light canvas tones to strong text tones.
Roles are assigned by intended semantic use, not by visual color name alone:
light steps become background/surface roles, middle steps become divider/accent
roles, and dark steps become text roles.

Ramp audits accept either a nondecreasing or nonincreasing luminance sequence;
this matches both light-to-dark and dark-to-light token conventions.

## Maintenance Value

The core can be reused by:

- MoonBit documentation sites that need accessible color tables
- terminal theme packages
- charting libraries
- dashboard or component libraries compiled to Wasm
- release gates that snapshot Markdown evidence
- design-token importers that want MoonBit-native validation before publishing
