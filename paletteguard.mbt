///|
/// RGB color with 8-bit channels.
pub(all) struct Color {
  r : Int
  g : Int
  b : Int
} derive(Eq, Debug)

///|
/// A color role inside a design palette or token set.
pub(all) enum Role {
  RoleText
  RoleAccent
  RoleBackground
  RoleSurface
  RoleBorder
} derive(Eq, Debug)

///|
/// WCAG conformance target.
pub(all) enum Requirement {
  LevelAA
  LevelAAA
} derive(Eq, Debug)

///|
/// Text size class used by WCAG contrast thresholds.
pub(all) enum TextKind {
  NormalText
  LargeText
} derive(Eq, Debug)

///|
pub(all) struct Policy {
  requirement : Requirement
  text_kind : TextKind
} derive(Eq, Debug)

///|
pub(all) struct Swatch {
  name : String
  color : Color
  role : Role
} derive(Eq, Debug)

///|
pub(all) enum Grade {
  GradeFail
  GradeLarge
  GradeAA
  GradeAAA
} derive(Eq, Debug)

///|
pub(all) enum Suggestion {
  SuggestKeep
  SuggestUseBlack
  SuggestUseWhite
  SuggestIncreaseSeparation
} derive(Eq, Debug)

///|
pub(all) struct PairAudit {
  foreground : Swatch
  background : Swatch
  ratio : Double
  required : Double
  grade : Grade
  passed : Bool
  suggestion : Suggestion
} derive(Eq, Debug)

///|
pub(all) struct PaletteReport {
  pairs : Array[PairAudit]
  checked : Int
  failures : Int
} derive(Eq, Debug)

///|
pub(all) enum ParseError {
  EmptyInput
  InvalidHexLength(Int)
  InvalidHexDigit(Char)
  InvalidRgbFunction(String)
  ComponentOutOfRange(String, Int)
  UnknownColorName(String)
} derive(Eq, Debug)

///|
pub(all) enum ColorParse {
  ColorParsed(Color)
  ColorParseFailed(ParseError)
} derive(Eq, Debug)

///|
pub(all) enum SwatchParse {
  SwatchParsed(Swatch)
  SwatchParseFailed(String, ParseError)
} derive(Eq, Debug)

///|
priv enum ComponentRead {
  ComponentValue(Int)
  ComponentProblem(ParseError)
}

///|
pub fn rgb(r : Int, g : Int, b : Int) -> Color? {
  if in_channel(r) && in_channel(g) && in_channel(b) {
    Some({ r, g, b })
  } else {
    None
  }
}

///|
pub fn swatch(name : String, color : Color, role : Role) -> Swatch {
  { name, color, role }
}

///|
pub fn policy_aa() -> Policy {
  { requirement: LevelAA, text_kind: NormalText }
}

///|
pub fn policy_aaa() -> Policy {
  { requirement: LevelAAA, text_kind: NormalText }
}

///|
pub fn policy_large_aa() -> Policy {
  { requirement: LevelAA, text_kind: LargeText }
}

///|
pub fn policy_large_aaa() -> Policy {
  { requirement: LevelAAA, text_kind: LargeText }
}

///|
pub fn Role::is_foreground(self : Role) -> Bool {
  match self {
    RoleText | RoleAccent => true
    _ => false
  }
}

///|
pub fn Role::is_background(self : Role) -> Bool {
  match self {
    RoleBackground | RoleSurface => true
    _ => false
  }
}

///|
pub fn Role::label(self : Role) -> String {
  match self {
    RoleText => "text"
    RoleAccent => "accent"
    RoleBackground => "background"
    RoleSurface => "surface"
    RoleBorder => "border"
  }
}

///|
pub fn Grade::label(self : Grade) -> String {
  match self {
    GradeFail => "fail"
    GradeLarge => "large-text"
    GradeAA => "AA"
    GradeAAA => "AAA"
  }
}

///|
pub fn Suggestion::label(self : Suggestion) -> String {
  match self {
    SuggestKeep => "keep"
    SuggestUseBlack => "use #000000 for this background"
    SuggestUseWhite => "use #FFFFFF for this background"
    SuggestIncreaseSeparation => "increase foreground/background separation"
  }
}

///|
pub fn Color::to_hex(self : Color) -> String {
  "#" +
  component_to_hex(self.r) +
  component_to_hex(self.g) +
  component_to_hex(self.b)
}

///|
pub fn Color::relative_luminance(self : Color) -> Double {
  0.2126 * channel_luminance(self.r) +
  0.7152 * channel_luminance(self.g) +
  0.0722 * channel_luminance(self.b)
}

///|
pub fn contrast_ratio(a : Color, b : Color) -> Double {
  let la = a.relative_luminance()
  let lb = b.relative_luminance()
  let lighter = if la >= lb { la } else { lb }
  let darker = if la >= lb { lb } else { la }
  (lighter + 0.05) / (darker + 0.05)
}

///|
pub fn minimum_ratio(policy : Policy) -> Double {
  match policy {
    { requirement: LevelAA, text_kind: NormalText } => 4.5
    { requirement: LevelAA, text_kind: LargeText } => 3.0
    { requirement: LevelAAA, text_kind: NormalText } => 7.0
    { requirement: LevelAAA, text_kind: LargeText } => 4.5
  }
}

///|
pub fn grade_ratio(ratio : Double) -> Grade {
  if ratio >= 7.0 {
    GradeAAA
  } else if ratio >= 4.5 {
    GradeAA
  } else if ratio >= 3.0 {
    GradeLarge
  } else {
    GradeFail
  }
}

///|
pub fn audit_pair(
  foreground : Swatch,
  background : Swatch,
  policy : Policy,
) -> PairAudit {
  let ratio = contrast_ratio(foreground.color, background.color)
  let required = minimum_ratio(policy)
  let passed = ratio >= required
  let suggestion = if passed {
    SuggestKeep
  } else {
    choose_suggestion(background.color, required)
  }
  {
    foreground,
    background,
    ratio,
    required,
    grade: grade_ratio(ratio),
    passed,
    suggestion,
  }
}

///|
pub fn audit_palette(
  swatches : Array[Swatch],
  policy : Policy,
) -> PaletteReport {
  let pairs : Array[PairAudit] = []
  for foreground in swatches {
    if foreground.role.is_foreground() {
      for background in swatches {
        if background.role.is_background() {
          pairs.push(audit_pair(foreground, background, policy))
        }
      }
    }
  }
  let mut failures = 0
  for pair in pairs {
    if !pair.passed {
      failures += 1
    }
  }
  { pairs, checked: pairs.length(), failures }
}

///|
pub fn PaletteReport::passes(self : PaletteReport) -> Bool {
  self.failures == 0
}

///|
pub fn PaletteReport::to_markdown(self : PaletteReport) -> String {
  let out = StringBuilder()
  out.write_string("# PaletteGuard report\n\n")
  out.write_string("Checked pairs: " + self.checked.to_string() + "\n")
  out.write_string("Failures: " + self.failures.to_string() + "\n\n")
  out.write_string(
    "| foreground | background | ratio | required | grade | result | suggestion |\n",
  )
  out.write_string("| --- | --- | ---: | ---: | --- | --- | --- |\n")
  for pair in self.pairs {
    out.write_string("| ")
    out.write_string(pair.foreground.name)
    out.write_string(" ")
    out.write_string(pair.foreground.color.to_hex())
    out.write_string(" | ")
    out.write_string(pair.background.name)
    out.write_string(" ")
    out.write_string(pair.background.color.to_hex())
    out.write_string(" | ")
    out.write_string(format_ratio(pair.ratio))
    out.write_string(" | ")
    out.write_string(format_ratio(pair.required))
    out.write_string(" | ")
    out.write_string(pair.grade.label())
    out.write_string(" | ")
    out.write_string(if pair.passed { "pass" } else { "fail" })
    out.write_string(" | ")
    out.write_string(pair.suggestion.label())
    out.write_string(" |\n")
  }
  out.to_string()
}

///|
pub fn parse_color(input : String) -> ColorParse {
  let token = input.trim().to_lower().to_owned()
  if token.length() == 0 {
    return ColorParseFailed(EmptyInput)
  }
  if char_at(token, 0) == '#' {
    parse_hex_color(token)
  } else if is_rgb_function(token) {
    parse_rgb_function(token)
  } else {
    parse_named_color(token)
  }
}

///|
pub fn parse_swatch(
  name : String,
  color_token : String,
  role : Role,
) -> SwatchParse {
  match parse_color(color_token) {
    ColorParsed(color) => SwatchParsed({ name, color, role })
    ColorParseFailed(error) => SwatchParseFailed(name, error)
  }
}

///|
pub fn demo_palette() -> Array[Swatch] {
  [
    swatch("ink", unchecked_color(18, 24, 38), RoleText),
    swatch("muted", unchecked_color(120, 128, 140), RoleText),
    swatch("brand", unchecked_color(0, 105, 190), RoleAccent),
    swatch("paper", unchecked_color(255, 255, 255), RoleBackground),
    swatch("mist", unchecked_color(236, 240, 245), RoleSurface),
    swatch("line", unchecked_color(180, 188, 198), RoleBorder),
  ]
}

///|
pub fn demo_report() -> String {
  audit_palette(demo_palette(), policy_aa()).to_markdown()
}

///|
fn in_channel(value : Int) -> Bool {
  value >= 0 && value <= 255
}

///|
fn unchecked_color(r : Int, g : Int, b : Int) -> Color {
  { r, g, b }
}

///|
fn channel_luminance(value : Int) -> Double {
  let normalized = value.to_double() / 255.0
  if normalized <= 0.03928 {
    normalized / 12.92
  } else {
    @math.pow((normalized + 0.055) / 1.055, 2.4)
  }
}

///|
fn choose_suggestion(background : Color, required : Double) -> Suggestion {
  let black = unchecked_color(0, 0, 0)
  let white = unchecked_color(255, 255, 255)
  if contrast_ratio(black, background) >= required {
    SuggestUseBlack
  } else if contrast_ratio(white, background) >= required {
    SuggestUseWhite
  } else {
    SuggestIncreaseSeparation
  }
}

///|
fn component_to_hex(value : Int) -> String {
  let hex = value.to_string(radix=16).to_upper()
  if hex.length() == 1 {
    "0" + hex
  } else {
    hex
  }
}

///|
fn format_ratio(value : Double) -> String {
  let scaled = @math.round(value * 100.0).to_int()
  let whole = scaled / 100
  let fraction = scaled % 100
  if fraction < 10 {
    whole.to_string() + ".0" + fraction.to_string()
  } else {
    whole.to_string() + "." + fraction.to_string()
  }
}

///|
fn char_at(text : String, index : Int) -> Char {
  match text.get_char(index) {
    Some(ch) => ch
    None => abort("PaletteGuard internal string index out of bounds")
  }
}

///|
fn is_rgb_function(token : String) -> Bool {
  token.length() >= 5 &&
  token[:4].to_owned() == "rgb(" &&
  token[token.length() - 1:].to_owned() == ")"
}

///|
fn parse_hex_color(token : String) -> ColorParse {
  let body = token[1:].to_owned()
  match body.length() {
    3 => parse_short_hex(body)
    6 => parse_long_hex(body)
    n => ColorParseFailed(InvalidHexLength(n))
  }
}

///|
fn parse_short_hex(body : String) -> ColorParse {
  match read_hex_digit(char_at(body, 0)) {
    ComponentProblem(error) => ColorParseFailed(error)
    ComponentValue(r) =>
      match read_hex_digit(char_at(body, 1)) {
        ComponentProblem(error) => ColorParseFailed(error)
        ComponentValue(g) =>
          match read_hex_digit(char_at(body, 2)) {
            ComponentProblem(error) => ColorParseFailed(error)
            ComponentValue(b) =>
              ColorParsed(unchecked_color(r * 17, g * 17, b * 17))
          }
      }
  }
}

///|
fn parse_long_hex(body : String) -> ColorParse {
  match read_hex_byte(char_at(body, 0), char_at(body, 1)) {
    ComponentProblem(error) => ColorParseFailed(error)
    ComponentValue(r) =>
      match read_hex_byte(char_at(body, 2), char_at(body, 3)) {
        ComponentProblem(error) => ColorParseFailed(error)
        ComponentValue(g) =>
          match read_hex_byte(char_at(body, 4), char_at(body, 5)) {
            ComponentProblem(error) => ColorParseFailed(error)
            ComponentValue(b) => ColorParsed(unchecked_color(r, g, b))
          }
      }
  }
}

///|
fn read_hex_byte(high : Char, low : Char) -> ComponentRead {
  match read_hex_digit(high) {
    ComponentProblem(error) => ComponentProblem(error)
    ComponentValue(h) =>
      match read_hex_digit(low) {
        ComponentProblem(error) => ComponentProblem(error)
        ComponentValue(l) => ComponentValue(h * 16 + l)
      }
  }
}

///|
fn read_hex_digit(ch : Char) -> ComponentRead {
  let code = ch.to_uint().reinterpret_as_int()
  if code >= 48 && code <= 57 {
    ComponentValue(code - 48)
  } else if code >= 97 && code <= 102 {
    ComponentValue(code - 87)
  } else if code >= 65 && code <= 70 {
    ComponentValue(code - 55)
  } else {
    ComponentProblem(InvalidHexDigit(ch))
  }
}

///|
fn parse_rgb_function(token : String) -> ColorParse {
  let inner = token[4:token.length() - 1].to_owned()
  let parts = [ for part in inner.split(",") => part.trim().to_owned() ]
  if parts.length() != 3 {
    return ColorParseFailed(InvalidRgbFunction(token))
  }
  match read_component("red", parts[0]) {
    ComponentProblem(error) => ColorParseFailed(error)
    ComponentValue(r) =>
      match read_component("green", parts[1]) {
        ComponentProblem(error) => ColorParseFailed(error)
        ComponentValue(g) =>
          match read_component("blue", parts[2]) {
            ComponentProblem(error) => ColorParseFailed(error)
            ComponentValue(b) => ColorParsed(unchecked_color(r, g, b))
          }
      }
  }
}

///|
fn read_component(label : String, text : String) -> ComponentRead {
  match parse_decimal(text) {
    None => ComponentProblem(InvalidRgbFunction(text))
    Some(value) =>
      if in_channel(value) {
        ComponentValue(value)
      } else {
        ComponentProblem(ComponentOutOfRange(label, value))
      }
  }
}

///|
fn parse_decimal(text : String) -> Int? {
  let token = text.trim().to_owned()
  if token.length() == 0 {
    return None
  }
  let max_safe = 1000000
  let mut value = 0
  for ch in token.iter() {
    let code = ch.to_uint().reinterpret_as_int()
    if code < 48 || code > 57 {
      return None
    }
    if value > max_safe {
      return Some(max_safe + 1)
    }
    let next = value * 10 + code - 48
    if next > max_safe {
      // Preserve normal out-of-range values while bounding untrusted input.
      return Some(max_safe + 1)
    }
    value = next
  }
  Some(value)
}

///|
fn parse_named_color(token : String) -> ColorParse {
  match token {
    "black" => ColorParsed(unchecked_color(0, 0, 0))
    "white" => ColorParsed(unchecked_color(255, 255, 255))
    "red" => ColorParsed(unchecked_color(255, 0, 0))
    "green" => ColorParsed(unchecked_color(0, 128, 0))
    "blue" => ColorParsed(unchecked_color(0, 0, 255))
    "transparent" => ColorParseFailed(UnknownColorName(token))
    _ => ColorParseFailed(UnknownColorName(token))
  }
}
