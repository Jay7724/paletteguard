# Test Record

Toolchain used locally:

```text
moon 0.1.20260803
```

Verified commands:

```bash
moon check
moon build
moon test
moon run cmd/main
moon package
```

Coverage intent:

- normal input: `#RGB`, `#RRGGBB`, `rgb(...)`, named colors
- invalid input: empty strings, invalid hex length, invalid hex digit
- boundary input: RGB channel range and black/white contrast endpoints
- data conversion: parsed color to normalized hex, swatch parse result
- core logic: WCAG contrast ratio, grade thresholds, remediation suggestions
- export: Markdown report table
- smoke test: runnable example in `cmd/main`

Latest local result:

```text
Total tests: 9, passed: 9, failed: 0.
```

`moon package` completed and generated a local publish archive under
`_build/publish`.

`moon publish --dry-run` was attempted locally. The MoonBit toolchain stopped
before contacting the registry because no Mooncakes credentials were present in
`MOON_HOME`. Run `moon login` with the release account, then rerun the dry-run
command before final submission.
