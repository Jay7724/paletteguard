# API Notes

PaletteGuard exposes a compact API centered on deterministic palette audits.

## Data Model

- `Color` stores `r`, `g`, and `b` channel values in the inclusive range
  `0..255`.
- `Role` classifies swatches as `RoleText`, `RoleAccent`, `RoleBackground`,
  `RoleSurface`, or `RoleBorder`.
- `Swatch` combines a stable token name, a color, and a role.
- `Policy` describes the target requirement: AA or AAA, normal or large text.

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

## Export

`PaletteReport::to_markdown()` emits a stable Markdown table that is easy to
snapshot, commit, paste into pull requests, or archive as release evidence.
