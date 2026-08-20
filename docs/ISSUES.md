# Issue Record

This file records the initial implementation tasks so the project has a
traceable maintenance trail even before a hosted issue tracker is opened.

## PG-1: Pick a differentiated MoonBit package direction

Status: done

Outcome: selected a palette accessibility guard after checking Mooncakes for
direct matches on contrast, palette, and WCAG keywords.

## PG-2: Implement core contrast model

Status: done

Outcome: added RGB color, swatch roles, AA/AAA policy, contrast math, grades,
and remediation suggestions.

## PG-3: Add parsing and report export

Status: done

Outcome: added color token parsing and Markdown report output.

## PG-4: Add CI and release documentation

Status: done

Outcome: added GitHub Actions workflow and Mooncakes release checklist.

## PG-5: Future file adapters

Status: planned

Candidate adapters: JSON token files, TOML token files, and static Markdown
tables.

## PG-6: Cross-target CI coverage

Status: done

Outcome: CI now installs Node.js and runs the test suite for Wasm, Wasm-GC and
JavaScript targets in addition to the default verification path.

## PG-7: Version tag for the published package

Status: local done, remote pending

Outcome: the annotated local tag `v0.1.0` exists and matches the published
Mooncakes package version. The tag still needs to be pushed to the public
GitHub repository from the authenticated `Jay7724` account and verified with
`git ls-remote --tags origin`.
