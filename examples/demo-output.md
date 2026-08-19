# Example Output

Run:

```bash
moon run cmd/main
```

The command prints a Markdown report and a compact catalog matrix:

```text
# PaletteGuard report

Checked pairs: 6
Failures: 2

| foreground | background | ratio | required | grade | result | suggestion |
| --- | --- | ---: | ---: | --- | --- | --- |
| ink #121826 | paper #FFFFFF | 17.73 | 4.50 | AAA | pass | keep |
| ink #121826 | mist #ECF0F5 | 15.49 | 4.50 | AAA | pass | keep |
| muted #78808C | paper #FFFFFF | 3.99 | 4.50 | large-text | fail | use #000000 for this background |
| muted #78808C | mist #ECF0F5 | 3.49 | 4.50 | large-text | fail | use #000000 for this background |
| brand #0069BE | paper #FFFFFF | 5.58 | 4.50 | AA | pass | keep |
| brand #0069BE | mist #ECF0F5 | 4.87 | 4.50 | AA | pass | keep |

Catalog families: 26
Aurora swatches: 13
| foreground/background | aurora-050 | aurora-100 | aurora-150 | aurora-200 | aurora-250 |
| --- | ---: | ---: | ---: | ---: | ---: |
| aurora-500 | 4.79 pass | 4.05 pass | 3.42 pass | 2.85 fail | 2.36 fail |
| aurora-600 | 6.07 pass | 5.13 pass | 4.34 pass | 3.61 pass | 2.99 fail |
| aurora-700 | 7.87 pass | 6.65 pass | 5.62 pass | 4.67 pass | 3.87 pass |
| aurora-800 | 10.10 pass | 8.53 pass | 7.21 pass | 6.00 pass | 4.97 pass |
| aurora-900 | 12.84 pass | 10.85 pass | 9.17 pass | 7.63 pass | 6.32 pass |
| aurora-950 | 15.79 pass | 13.34 pass | 11.28 pass | 9.39 pass | 7.77 pass |
```
