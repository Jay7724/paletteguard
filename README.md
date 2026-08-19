# PaletteGuard

PaletteGuard is a MoonBit library for auditing design-system color palettes
against WCAG contrast thresholds. It parses common color tokens, models palette
roles, checks foreground/background pairs, suggests repair candidates, audits
token documents, and exports reproducible Markdown reports that can be used in
CI, documentation, or release reviews.

The package targets projects that keep color tokens in code, static assets, or
documentation and need a small MoonBit-native guard before shipping UI themes.
It is not a general image-processing library and does not depend on browser,
Canvas, JavaScript, or external color packages.

## Why

Color regressions are easy to miss when teams change brand colors, terminal
themes, dashboards, charts, or documentation styles. PaletteGuard gives MoonBit
projects a reusable contrast engine rather than a one-off script: the same
core functions can power tests, command examples, token importers, design-token
release gates, and future file-format adapters.

## Installation

The module name in this repository is:

```text
Jay7724/paletteguard
```

After publishing under your Mooncakes owner, install it with:

```bash
moon add Jay7724/paletteguard
```

Use the package from another MoonBit package:

```moonbit
import {
  "Jay7724/paletteguard" @paletteguard,
}
```

## Minimal Example

```moonbit
let palette = [
  @paletteguard.swatch("text", @paletteguard.rgb(18, 24, 38).unwrap(), @paletteguard.RoleText),
  @paletteguard.swatch("paper", @paletteguard.rgb(255, 255, 255).unwrap(), @paletteguard.RoleBackground),
]

let report = @paletteguard.audit_palette(palette, @paletteguard.policy_aa())
println(report.to_markdown())
println(@paletteguard.contrast_matrix(palette, @paletteguard.policy_aa()))
```

Run the included example:

```bash
moon run cmd/main
```

## Local Commands

```bash
moon check
moon build
moon test
moon run cmd/main
moon publish --dry-run
```

For a real release:

```bash
moon login
moon publish --dry-run
moon publish
```

If you change code after a release, increment `version` in `moon.mod` before
publishing again.

## Core API

- `Color`: RGB color with 8-bit channels.
- `Role`: palette role: text, accent, background, surface, or border.
- `Policy`: AA/AAA and normal/large-text threshold selection.
- `parse_color`: parses `#RGB`, `#RRGGBB`, `rgb(r, g, b)`, and a small named
  color set.
- `parse_swatch`: converts a named token into a role-aware swatch.
- `contrast_ratio`: computes WCAG relative-luminance contrast.
- `audit_pair`: checks one foreground/background pair.
- `audit_palette`: checks all text/accent swatches against background/surface
  swatches.
- `PaletteReport::to_markdown`: exports a stable Markdown report.
- `Color::to_hsl`, `Hsl::to_color`, `Color::mix`, `Color::lighten`,
  `Color::darken`, `Color::rotate_hue`: MoonBit-native color transforms.
- `repair_foreground` and `repair_background`: search for the nearest contrast
  repair candidate against a selected policy.
- `parse_token_document` and `audit_token_document`: parse simple token
  assignments such as `text.body = #111827` or `surface.panel: white`.
- `palette_stats`, `audit_ramp`, and `contrast_matrix`: summarize palettes,
  validate luminance ramps, and export foreground/background matrices.
- `built_in_catalog`, `catalog_by_family`, `catalog_find`,
  `catalog_audit_family`: 26 original semantic color families with 338 swatches
  for examples, tests, and starter palettes.

## Supported Scope

- Hex colors: `#RGB` and `#RRGGBB`.
- Decimal RGB functions: `rgb(12, 34, 56)`.
- Named colors: black, white, red, green, blue.
- WCAG AA and AAA thresholds for normal and large text.
- HSL conversion, hue rotation, grayscale, channel distance, perceived
  brightness, and temperature classification.
- Foreground/background repair search using deterministic black/white and
  lightness paths.
- Simple design-token document parsing with per-line diagnostics.
- Built-in original palette catalog: 26 families, 338 semantic swatches.
- Markdown report export.
- Pure MoonBit implementation with no runtime dependencies.

## Not Supported

- Alpha blending, gradients, ICC profiles, images, or screenshots.
- CSS Color Level 4 syntax such as `lab()`, `oklch()`, or percentage RGB.
- Reading files from disk directly. The library parses strings; CLI/file
  adapters are planned as separate boundary packages or future minor versions.

## CI

GitHub Actions is configured in `.github/workflows/ci.yml` and runs:

- MoonBit toolchain installation
- `moon check`
- `moon build`
- `moon test`
- `moon run cmd/main`

## Mooncakes

- Package name: `Jay7724/paletteguard`
- Documentation URL after release:
  `https://mooncakes.io/docs/Jay7724/paletteguard`
- Manifest URL after release:
  `https://mooncakes.io/api/v0/manifest/Jay7724/paletteguard`

The current repository metadata uses owner `Jay7724`. If the Mooncakes account
shows a different owner during release, update the owner segment in `moon.mod`,
this README, and `docs/RELEASE.md` before publishing.

## License And Third-Party Notes

PaletteGuard is licensed under MIT. The implementation is original MoonBit
code. It uses the public WCAG contrast formula as a standard, but it does not
copy third-party source code, images, fonts, audio, or datasets. The built-in
catalog is original synthetic palette data maintained inside this repository.
