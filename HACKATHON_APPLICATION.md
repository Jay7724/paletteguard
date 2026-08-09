# PaletteGuard Project Application

## Basic Information

- Project name: PaletteGuard, a MoonBit palette accessibility guard
- Participant: <fill by participant>
- Contact: <fill by participant>
- GitHub repository: https://github.com/<github-user>/paletteguard
- Project direction: MoonBit native library and CI-friendly development tool
- Ported project: No, this is an original MoonBit implementation
- Open source license: MIT

## Project Summary

PaletteGuard provides a reusable MoonBit library for checking design-system
colors against WCAG contrast thresholds. It parses common color tokens, models
foreground/background roles, computes contrast ratios, grades pairs against
AA/AAA policies, and exports Markdown evidence that can be kept in CI logs,
release notes, or project documentation.

The project helps MoonBit developers build accessible UI, charting, terminal
theme, documentation, and WebAssembly-facing tools without depending on a
browser or JavaScript color package.

## Scenarios

PaletteGuard is suitable for MoonBit package authors, documentation builders,
chart libraries, terminal theme tools, and release workflows that need stable
color contrast checks before shipping a palette.

## Planned And Implemented Core Features

- RGB color model and role-aware swatch model.
- Parsing for hex, RGB function, and selected named colors.
- WCAG relative luminance and contrast ratio implementation.
- AA/AAA policy checks for normal and large text.
- Markdown audit report export.
- Runnable example, unit tests, README, CI, release checklist, and Mooncakes
  publishing configuration.

## Current Foundation

The repository contains a MoonBit module, library code, runnable example,
blackbox and whitebox tests, GitHub Actions CI, MIT license, README, API notes,
design notes, test record, issue record, changelog, and release instructions.

## Originality And References

PaletteGuard is an original MoonBit implementation. It does not port or copy
third-party source code and does not include unknown assets, private code,
images, audio, fonts, or datasets. The contrast calculation follows the public
WCAG formula as a standard.
