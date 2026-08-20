///|
test "color profiles and hsl transforms remain stable" {
  let blue = @paletteguard.rgb(51, 102, 153).unwrap()
  let roundtrip = blue.to_hsl().to_color()
  inspect(roundtrip.to_hex(), content="#336699")
  inspect(blue.profile().hex, content="#336699")
  inspect(blue.profile().temperature.label(), content="cool")
  inspect(blue.rotate_hue(180.0).to_hex().length(), content="7")
}

///|
test "foreground repair finds a passing contrast candidate" {
  let weak = @paletteguard.rgb(188, 188, 188).unwrap()
  let paper = @paletteguard.rgb(255, 255, 255).unwrap()
  let repaired = @paletteguard.repair_foreground(
    weak,
    paper,
    @paletteguard.policy_aa(),
  )
  inspect(repaired.ratio >= 4.5, content="true")
  inspect(repaired.strategy.label().contains("foreground"), content="true")
}

///|
test "unreachable AAA repair keeps the strongest available contrast" {
  let gray = @paletteguard.rgb(128, 128, 128).unwrap()
  let repaired = @paletteguard.repair_foreground(
    gray,
    gray,
    @paletteguard.policy_aaa(),
  )
  inspect(repaired.ratio >= 5.3, content="true")
}

///|
test "token document parser keeps swatches and diagnostics separate" {
  let source = "# tokens\ntext.body = #111827\nbackground.canvas: white\naccent.link = rgb(0, 105, 190)\nunknown.foo = #123456\ntext.bad = rgb(300, 0, 0)\n"
  let parsed = @paletteguard.parse_token_document(source)
  inspect(parsed.swatches.length(), content="3")
  inspect(parsed.diagnostics.length(), content="2")
  inspect(parsed.has_errors(), content="true")
  inspect(parsed.to_markdown().contains("Diagnostics"), content="true")
}

///|
test "document audit wires parser stats and palette audit" {
  let source = "text.body = #111827\nbackground.canvas = #ffffff\nsurface.panel = #f3f4f6\naccent.link = #005fbd\n"
  let audit = @paletteguard.audit_token_document(
    source,
    @paletteguard.policy_aa(),
  )
  inspect(audit.tokens.swatches.length(), content="4")
  inspect(audit.stats.foregrounds, content="2")
  inspect(audit.stats.backgrounds, content="2")
  inspect(audit.palette.checked, content="4")
  inspect(audit.to_markdown().contains("PaletteGuard report"), content="true")
}

///|
test "catalog exposes reusable semantic palettes" {
  inspect(@paletteguard.catalog_families().length(), content="26")
  inspect(@paletteguard.built_in_catalog().length(), content="338")
  match @paletteguard.catalog_find("aurora-500") {
    Some(item) => {
      inspect(item.family, content="aurora")
      inspect(item.tone.label(), content="accent")
      inspect(item.as_swatch().name, content="aurora-500")
    }
    None => fail("expected catalog item")
  }
}

///|
test "catalog summaries and family audits are runnable" {
  let summary = @paletteguard.catalog_summary("zenith")
  inspect(summary.total, content="13")
  inspect(summary.foregrounds, content="6")
  inspect(summary.backgrounds, content="5")
  inspect(summary.minimum_recommended_contrast >= 4.5, content="true")
  let report = @paletteguard.catalog_audit_family(
    "zenith",
    @paletteguard.policy_large_aa(),
  )
  inspect(report.checked, content="30")
}

///|
test "ramp audit reports monotonicity and duplicates" {
  let ramp = [
    @paletteguard.swatch(
      "a",
      @paletteguard.rgb(255, 255, 255).unwrap(),
      @paletteguard.RoleSurface,
    ),
    @paletteguard.swatch(
      "b",
      @paletteguard.rgb(230, 230, 230).unwrap(),
      @paletteguard.RoleSurface,
    ),
    @paletteguard.swatch(
      "c",
      @paletteguard.rgb(230, 230, 230).unwrap(),
      @paletteguard.RoleSurface,
    ),
    @paletteguard.swatch(
      "d",
      @paletteguard.rgb(240, 240, 240).unwrap(),
      @paletteguard.RoleSurface,
    ),
  ]
  let audit = @paletteguard.audit_ramp("neutral", ramp)
  inspect(audit.monotonic_luminance, content="false")
  inspect(audit.duplicate_hexes.length(), content="1")
  inspect(audit.to_markdown().contains("Duplicate colors"), content="true")

  let descending = [
    @paletteguard.swatch(
      "light",
      @paletteguard.rgb(255, 255, 255).unwrap(),
      @paletteguard.RoleSurface,
    ),
    @paletteguard.swatch(
      "dark",
      @paletteguard.rgb(40, 40, 40).unwrap(),
      @paletteguard.RoleSurface,
    ),
  ]
  inspect(
    @paletteguard.audit_ramp("descending", descending).monotonic_luminance,
    content="true",
  )
}

///|
test "contrast matrix renders compact markdown" {
  let palette = [
    @paletteguard.swatch(
      "text",
      @paletteguard.rgb(17, 24, 39).unwrap(),
      @paletteguard.RoleText,
    ),
    @paletteguard.swatch(
      "link",
      @paletteguard.rgb(0, 95, 189).unwrap(),
      @paletteguard.RoleAccent,
    ),
    @paletteguard.swatch(
      "paper",
      @paletteguard.rgb(255, 255, 255).unwrap(),
      @paletteguard.RoleBackground,
    ),
  ]
  let matrix = @paletteguard.contrast_matrix(palette, @paletteguard.policy_aa())
  inspect(matrix.contains("foreground/background"), content="true")
  inspect(matrix.contains("pass"), content="true")
}
