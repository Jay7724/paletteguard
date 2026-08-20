# Contributing

Thanks for helping improve PaletteGuard. The project is a pure MoonBit library
with a deliberately small input boundary: it parses color and token strings,
audits contrast, and returns deterministic data or Markdown reports.

## Before opening a change

Install MoonBit 0.10.7 or newer, then run the same checks used by CI:

```bash
moon fmt --check
moon check --target all --deny-warn
moon build
moon test --deny-warn
moon test --target wasm --deny-warn
moon test --target wasm-gc --deny-warn
moon test --target js --deny-warn
moon run cmd/main
moon package
```

Add or update tests when behavior changes. Keep parsing errors explicit, keep
repair results deterministic, and preserve the documented distinction between
supported syntax and intentionally unsupported formats.

## Documentation and provenance

Update the README or API notes when public behavior changes. Do not add code,
fixtures, fonts, images, or datasets whose source and redistribution rights are
unclear. New third-party material must be recorded in `THIRD_PARTY.md` with its
license and scope.

## Releases

Use a meaningful commit message, update `CHANGELOG.md`, increment the version
in `moon.mod`, run the release checks, publish the package under the matching
Mooncakes owner, and create a matching Git tag. Do not commit `_build/`, target
outputs, or generated `.mbti` interface files.
