# API Notes

PaletteGuard exposes a MoonBit API centered on deterministic palette audits,
token parsing, color repair suggestions, and reusable catalog fixtures.

## Data Model

- `Color` stores `r`, `g`, and `b` channel values in the inclusive range
  `0..255`.
- `Role` classifies swatches as `RoleText`, `RoleAccent`, `RoleBackground`,
  `RoleSurface`, or `RoleBorder`.
- `Swatch` combines a stable token name, a color, and a role.
- `Policy` describes the target requirement: AA or AAA, normal or large text.
- `Hsl` represents normalized HSL coordinates for color transforms.
- `ColorProfile` records hex, luminance, brightness, hue, saturation,
  temperature, and recommended black/white text.
- `TokenParseReport` contains parsed swatches, diagnostics, and ignored-line
  counts for token documents.
- `PaletteStats` summarizes role counts and luminance distribution.
- `CatalogSwatch` stores one built-in semantic catalog entry.

## Parsing

`parse_color(input)` returns `ColorParsed(Color)` or
`ColorParseFailed(ParseError)`.

Supported color input:

- `#RGB`
- `#RRGGBB`
- `rgb(r, g, b)`
- `black`, `white`, `red`, `green`, `blue`

`parse_swatch(name, token, role)` wraps color parsing and preserves the swatch
name in failures.

`parse_token_document(input)` parses simple line-oriented token documents:

```text
text.body = #111827
background.canvas: white
accent.link = rgb(0, 105, 190)
```

It ignores blank lines, `//` comments, `# ` comments, and `--` comments.
Token roles are inferred from stable keywords such as `text`, `accent`,
`background`, `surface`, and `border`. Unknown roles and malformed colors are
reported as diagnostics instead of stopping the parse.

## Auditing

`contrast_ratio(foreground, background)` implements the WCAG relative
luminance contrast calculation.

`audit_pair(foreground, background, policy)` returns:

- measured ratio
- required ratio
- AA/AAA grade
- pass/fail status
- a simple remediation suggestion

`audit_palette(swatches, policy)` checks every text/accent swatch against every
background/surface swatch. Border swatches are retained in the model but are
not checked as text foregrounds.

`audit_token_document(input, policy)` combines token parsing, palette stats,
and contrast auditing in one call.

`audit_ramp(family, swatches)` checks whether a sequence has monotonic
luminance, reports duplicate hex values, and records the smallest luminance
gap.

`repair_foreground(foreground, background, policy)` and
`repair_background(foreground, background, policy)` search deterministic
lighten/darken paths and return a `RepairCandidate`.

`readable_foreground(background, policy)` chooses a black or white foreground
candidate for a background.

## Color Operations

`Color::to_hsl()` and `Hsl::to_color()` support RGB/HSL round trips.

`Color::mix`, `Color::lighten`, `Color::darken`, `Color::invert`,
`Color::grayscale`, `Color::rotate_hue`, `Color::set_lightness`, and
`Color::set_saturation` provide deterministic transforms that stay inside
8-bit RGB.

`Color::profile()` returns derived data for reports and diagnostics.

`Color::harmonies(kind)` can produce complementary, analogous, triadic,
split-complementary, monochrome, or custom color groups.

## Catalog

The built-in catalog contains 26 original semantic color families and 338
swatches. It is useful for tests, examples, starter palettes, and local
experiments without copying third-party color data.

- `built_in_catalog()` returns all entries.
- `catalog_families()` returns family names.
- `catalog_by_family(family)` filters entries by family.
- `catalog_by_role(role)` filters entries by role.
- `catalog_find(id)` looks up one semantic id such as `aurora-500`.
- `catalog_palette_for_family(family)` converts catalog entries to `Swatch`.
- `catalog_audit_family(family, policy)` audits one catalog family.
- `catalog_summary(family)` returns role counts and recommended contrast
  statistics.

## Export

`PaletteReport::to_markdown()`, `TokenParseReport::to_markdown()`,
`PaletteStats::to_markdown()`, `RampAudit::to_markdown()`,
`DocumentAudit::to_markdown()`, `contrast_matrix()`, and `catalog_markdown()`
emit stable Markdown that is easy to snapshot, commit, paste into pull
requests, or archive as release evidence.
