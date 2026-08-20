# Release Procedure

This document separates local preparation from account-authorized release
actions. Do not run the login or push commands while a different GitHub or
Mooncakes account is active.

1. Update `moon.mod`:
   - `name`
   - `repository`
   - `version`
2. Confirm the public GitHub repository URL opens.
3. Run local verification:

```bash
moon version --all
moon fmt --check
moon check --deny-warn
moon build
moon test --deny-warn
moon run cmd/main
moon package
moon publish --dry-run
```

4. Publish:

```bash
moon login
moon publish
```

5. Verify Mooncakes:

```text
https://mooncakes.io/docs/Jay7724/paletteguard
https://mooncakes.io/api/v0/manifest/Jay7724/paletteguard
```

6. Tag the release:

```bash
git tag v0.1.0
git push origin v0.1.0
git ls-remote --tags origin refs/tags/v0.1.0
```

GitHub Desktop users can create the tag from the latest `main` commit and
select `Push origin`. Before pushing, confirm that the repository is
`Jay7724/paletteguard` and that the active account is `Jay7724`.

## Evidence after release

Record the following links or command output in the release issue or test
record:

- the public GitHub repository on its default branch;
- the successful GitHub Actions run for the pushed commit;
- the Mooncakes documentation page and manifest page;
- the exact version and tag submitted to the hackathon form.

Version `0.1.0` was published under owner `Jay7724` and verified through the
Mooncakes documentation and manifest endpoints. The public default branch,
successful GitHub Actions run, remote `v0.1.0` tag, and GitHub Release are all
recorded. The remaining action is the official form submission; the run
history is linked from the repository README and Actions tab.
