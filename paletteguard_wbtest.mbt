///|
test "format ratio keeps two decimal places" {
  inspect(format_ratio(4.5), content="4.50")
  inspect(format_ratio(3.0), content="3.00")
  inspect(format_ratio(21.0), content="21.00")
}

///|
test "role routing selects only text and accent against surfaces" {
  let report = audit_palette(demo_palette(), policy_aa())
  inspect(report.checked, content="6")
  inspect(report.failures >= 0, content="true")
}

///|
test "parse swatch converts structure or returns scoped error" {
  match parse_swatch("primary", "#123456", RoleAccent) {
    SwatchParsed(s) => {
      inspect(s.name, content="primary")
      inspect(s.color.to_hex(), content="#123456")
    }
    SwatchParseFailed(_, _) => fail("expected swatch")
  }
  match parse_swatch("bad", "#xx", RoleText) {
    SwatchParseFailed("bad", InvalidHexLength(2)) =>
      inspect(true, content="true")
    _ => fail("expected swatch parse failure")
  }
}

///|
test "suggestion picks readable text for failing pair" {
  let fg = swatch("weak", unchecked_color(230, 230, 230), RoleText)
  let bg = swatch("paper", unchecked_color(255, 255, 255), RoleBackground)
  let audit = audit_pair(fg, bg, policy_aa())
  inspect(audit.passed, content="false")
  inspect(audit.suggestion.label(), content="use #000000 for this background")
}
