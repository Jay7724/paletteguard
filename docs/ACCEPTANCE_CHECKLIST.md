# Acceptance Checklist

This checklist is for the August Hackathon submission of PaletteGuard. It
keeps local evidence separate from actions that require the contestant's
authenticated accounts.

## Local evidence ready

- [x] MoonBit is the primary implementation language.
- [x] `moon.mod` uses the project namespace `Jay7724/paletteguard`.
- [x] The root `README.md` explains purpose, scope, installation, API and a
  runnable example.
- [x] `moon run cmd/main` produces a Markdown audit report and catalog matrix.
- [x] `moon check --target all --deny-warn` passes.
- [x] `moon build` passes.
- [x] `moon test --deny-warn` passes: 21 tests passed.
- [x] `moon fmt --check` passes.
- [x] `moon package` produces a local publish archive.
- [x] GitHub Actions checks format, check, build, test, package and the example.
- [x] The effective MoonBit source scale is 5,836 lines, including 5,550
  production lines and 286 test lines.
- [x] The root `LICENSE` is MIT and third-party/source notes are documented.
- [x] Design boundaries, test records, changelog and release procedure are
  included.
- [x] AI-assisted development, provenance, testability and license notes are
  included.
- [x] Local history contains more than five meaningful development commits.

## Account-authorized actions still required

- [ ] Push the local `main` branch to the public GitHub repository while the
  intended `Jay7724` account is active.
- [ ] Confirm the remote default branch shows the latest local release commit.
- [ ] Wait for and record a successful GitHub Actions run on that commit.
- [ ] Log in to Mooncakes as the owner `Jay7724`.
- [ ] Run `moon publish --dry-run`, then `moon publish`.
- [ ] Open the Mooncakes documentation and manifest URLs and record the
  published version.
- [ ] Submit the public GitHub URL and the one-page Markdown application
  document through the official August Hackathon form.

Until the push and `moon publish` steps succeed, the project is locally ready
but should not be described as fully accepted or already published.
