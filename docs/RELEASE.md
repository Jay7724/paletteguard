# Release Procedure

1. Update `moon.mod`:
   - `name`
   - `repository`
   - `version`
2. Confirm the public GitHub repository URL opens.
3. Run local verification:

```bash
moon check
moon build
moon test
moon run cmd/main
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
git push origin main --tags
```
