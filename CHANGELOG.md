# Changelog

## 0.1.0

- Added RGB color and palette role model.
- Added parsing for `#RGB`, `#RRGGBB`, `rgb(r, g, b)`, and selected named
  colors.
- Added WCAG AA/AAA contrast policy checks.
- Added role-aware palette audit and Markdown report export.
- Added HSL conversion, hue rotation, grayscale, color mixing, and brightness
  profiling.
- Added deterministic foreground/background repair search for failing contrast
  pairs, with nearest passing selection and strongest-available fallback.
- Added line-oriented token document parsing with structured diagnostics.
- Added palette statistics, ramp audits, contrast matrix export, and combined
  document audit reports.
- Improved ramp audits to accept both light-to-dark and dark-to-light monotonic
  sequences while still reporting duplicate colors.
- Added 26 original built-in semantic palette families with 338 swatches for
  examples, tests, and starter palettes.
- Added runnable MoonBit example in `cmd/main`.
- Added tests, CI workflow, design notes, AI-assisted development note, and
  release checklist.
