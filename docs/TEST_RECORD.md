# Test Record

Toolchain used locally:

```text
moon 0.1.20260803
```

Verified commands:

```bash
moon fmt --check
moon check
moon check --deny-warn
moon build
moon test
moon test --deny-warn
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
- repair search: deterministic foreground repair for failing contrast pairs
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
Total tests: 17, passed: 17, failed: 0.
```

Current effective MoonBit source scale:

```text
analysis_engine.mbt        988 effective lines
catalog_generated.mbt     4060 effective lines
paletteguard.mbt           456 effective lines
cmd/main/main.mbt           14 effective lines
tests                       219 effective lines
total                      5737 effective lines
production source          5518 effective lines
```

`moon package` completed and generated a local publish archive under
`_build/publish`.

`moon publish --dry-run` was attempted locally. The MoonBit toolchain stopped
before contacting the registry because no Mooncakes credentials were present in
`MOON_HOME`. Run `moon login` with the release account, then rerun the dry-run
command before final submission.
