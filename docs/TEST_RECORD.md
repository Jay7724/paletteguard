# Test Record

Toolchain used locally:

```text
moon 0.1.20260803
moonc v0.10.6+62c2592d1 (local verification environment)
```

Verified commands:

```bash
moon fmt --check
moon check
moon check --deny-warn
moon build
moon test
moon test --deny-warn
moon check --target all --deny-warn
moon run cmd/main
moon package
```

Coverage intent:

- normal input: `#RGB`, `#RRGGBB`, `rgb(...)`, named colors
- invalid input: empty strings, invalid hex length, invalid hex digit
- boundary input: RGB channel range and black/white contrast endpoints
- data conversion: parsed color to normalized hex, swatch parse result
- core logic: WCAG contrast ratio, grade thresholds, remediation suggestions
- color analysis: HSL round trip, hue transforms, brightness profile, color
  temperature
- repair search: deterministic foreground and background repair for failing
  contrast pairs, including bounded-candidate selection and unreachable-policy
  fallback
- token documents: parsed swatches, ignored lines, warning diagnostics, error
  diagnostics
- catalog: 26 original families, 338 swatches, lookup, role conversion,
  summary, family audit
- ramp audit: monotonic luminance and duplicate hex detection
- matrix export: foreground/background Markdown contrast matrix
- export: Markdown report table
- smoke test: runnable example in `cmd/main`

Latest local result:

```text
Total tests: 21, passed: 21, failed: 0.
```

Current effective MoonBit source scale:

```text
analysis_engine.mbt        1012 effective lines
catalog_generated.mbt     4060 effective lines
paletteguard.mbt           464 effective lines
cmd/main/main.mbt           14 effective lines
tests                       286 effective lines
total                      5836 effective lines
production source          5550 effective lines
```

`moon package` completed and generated a local publish archive under
`_build/publish`.

`moon publish --dry-run` completed successfully for
`Jay7724/paletteguard` version `0.1.0`, and `moon publish` returned server
status `200 OK`. The published documentation and manifest endpoints both
returned HTTP 200.

The GitHub Actions workflow repeats the reproducible checks with the hosted
MoonBit toolchain and additionally runs `moon fmt --check`, `moon check
--target all --deny-warn`, `moon test --deny-warn`, and `moon package`.

The public CI run for commit `6b4b9ca` completed successfully:
`https://github.com/Jay7724/paletteguard/actions/runs/32352218973`.
