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
- [x] CI also runs the Wasm, Wasm-GC and JavaScript target tests.
- [x] The effective MoonBit source scale is 5,836 lines, including 5,550
  production lines and 286 test lines.
- [x] The root `LICENSE` is MIT and third-party/source notes are documented.
- [x] Design boundaries, test records, changelog and release procedure are
  included.
- [x] AI-assisted development, provenance, testability and license notes are
  included.
- [x] Local history contains more than five meaningful development commits.

## Account-authorized actions still required

- [x] Push the local `main` branch to the public GitHub repository while the
  intended `Jay7724` account is active.
- [x] Confirm the remote default branch contains the latest local release
  commit.
- [x] Record a successful GitHub Actions run for the public default branch.
- [x] Log in to Mooncakes as the owner `Jay7724`.
- [x] Run `moon publish --dry-run`, then `moon publish`; version `0.1.0`
  returned server status 200.
- [x] Open the Mooncakes documentation and manifest URLs; both returned HTTP
  200 for the published version.
- [ ] Push the local annotated tag `v0.1.0` to the public GitHub repository
  while the intended `Jay7724` account is active.
- [ ] Verify the remote tag with `git ls-remote --tags origin` or the GitHub
  Tags page.
- [ ] Submit the public GitHub URL and the one-page Markdown application
  document through the official August Hackathon form.

The repository, default branch, CI run, and Mooncakes publication are ready.
The GitHub release tag and official form submission remain account-authorized
actions; this checklist does not claim official acceptance before the organizer
completes its review.
