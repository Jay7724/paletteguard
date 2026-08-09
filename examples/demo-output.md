# Example Output

Run:

```bash
moon run cmd/main
```

The command prints a Markdown report like:

```text
# PaletteGuard report

Checked pairs: 6
Failures: 2

| foreground | background | ratio | required | grade | result | suggestion |
| --- | --- | ---: | ---: | --- | --- | --- |
| ink #121826 | paper #FFFFFF | 17.73 | 4.50 | AAA | pass | keep |
| muted #78808C | paper #FFFFFF | 3.99 | 4.50 | large-text | fail | use #000000 for this background |
```
