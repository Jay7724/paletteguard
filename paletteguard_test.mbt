///|
test "parse hex colors and export normalized hex" {
  match @paletteguard.parse_color("#0fC") {
    @paletteguard.ColorParsed(color) =>
      inspect(color.to_hex(), content="#00FFCC")
    @paletteguard.ColorParseFailed(_) => fail("expected short hex to parse")
  }
  match @paletteguard.parse_color(" #112233 ") {
    @paletteguard.ColorParsed(color) =>
      inspect(color.to_hex(), content="#112233")
    @paletteguard.ColorParseFailed(_) => fail("expected long hex to parse")
  }
}

///|
test "parse rgb function and named colors" {
  match @paletteguard.parse_color("rgb(12, 34, 56)") {
    @paletteguard.ColorParsed(color) =>
      inspect(color.to_hex(), content="#0C2238")
    @paletteguard.ColorParseFailed(_) => fail("expected rgb function to parse")
  }
  match @paletteguard.parse_color("WHITE") {
    @paletteguard.ColorParsed(color) =>
      inspect(color.to_hex(), content="#FFFFFF")
    @paletteguard.ColorParseFailed(_) => fail("expected named color to parse")
  }
}

///|
test "reject malformed color input" {
  match @paletteguard.parse_color("") {
    @paletteguard.ColorParseFailed(@paletteguard.EmptyInput) =>
      inspect(true, content="true")
    _ => fail("expected empty input error")
  }
  match @paletteguard.parse_color("#12") {
    @paletteguard.ColorParseFailed(@paletteguard.InvalidHexLength(2)) =>
      inspect(true, content="true")
    _ => fail("expected invalid hex length")
  }
  match @paletteguard.parse_color("#12X456") {
    @paletteguard.ColorParseFailed(@paletteguard.InvalidHexDigit('x')) =>
      inspect(true, content="true")
    _ => fail("expected invalid hex digit")
  }
  match @paletteguard.parse_color("rgb(1, 2, 300)") {
    @paletteguard.ColorParseFailed(
      @paletteguard.ComponentOutOfRange("blue", 300)
    ) => inspect(true, content="true")
    _ => fail("expected out of range component")
  }
  match @paletteguard.parse_color("rgb(999999999999999999999999, 0, 0)") {
    @paletteguard.ColorParseFailed(
      @paletteguard.ComponentOutOfRange("red", 1000001)
    ) => inspect(true, content="true")
    _ => fail("expected large component to be rejected safely")
  }
}

///|
test "policies expose the four WCAG thresholds" {
  inspect(@paletteguard.minimum_ratio(@paletteguard.policy_aa()), content="4.5")
  inspect(
    @paletteguard.minimum_ratio(@paletteguard.policy_large_aa()),
    content="3",
  )
  inspect(@paletteguard.minimum_ratio(@paletteguard.policy_aaa()), content="7")
  inspect(
    @paletteguard.minimum_ratio(@paletteguard.policy_large_aaa()),
    content="4.5",
  )
}

///|
test "contrast ratio follows WCAG endpoints" {
  let black = @paletteguard.rgb(0, 0, 0).unwrap()
  let white = @paletteguard.rgb(255, 255, 255).unwrap()
  let ratio = @paletteguard.contrast_ratio(black, white)
  inspect(ratio >= 20.99 && ratio <= 21.01, content="true")
  inspect(@paletteguard.grade_ratio(ratio).label(), content="AAA")
}

///|
test "audit palette produces failures and markdown" {
  let palette = [
    @paletteguard.swatch(
      "text",
      @paletteguard.rgb(150, 150, 150).unwrap(),
      @paletteguard.RoleText,
    ),
    @paletteguard.swatch(
      "paper",
      @paletteguard.rgb(255, 255, 255).unwrap(),
      @paletteguard.RoleBackground,
    ),
    @paletteguard.swatch(
      "brand",
      @paletteguard.rgb(0, 74, 173).unwrap(),
      @paletteguard.RoleAccent,
    ),
  ]
  let report = @paletteguard.audit_palette(palette, @paletteguard.policy_aa())
  inspect(report.checked, content="2")
  inspect(report.failures, content="1")
  inspect(
    report.to_markdown().contains("| foreground | background |"),
    content="true",
  )
}

///|
test "empty palette remains safe to summarize" {
  let stats = @paletteguard.palette_stats([])
  inspect(stats.swatches, content="0")
  inspect(stats.foregrounds, content="0")
  inspect(stats.backgrounds, content="0")
  inspect(stats.average_luminance, content="0")
  inspect(stats.to_markdown().contains("darkest: n/a"), content="true")
}

///|
test "background repair returns a passing candidate" {
  let ink = @paletteguard.rgb(118, 118, 118).unwrap()
  let gray = @paletteguard.rgb(150, 150, 150).unwrap()
  let repaired = @paletteguard.repair_background(
    ink,
    gray,
    @paletteguard.policy_aa(),
  )
  inspect(repaired.ratio >= 4.5, content="true")
  inspect(repaired.strategy.label().contains("background"), content="true")
}
