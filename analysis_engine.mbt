///|
pub(all) enum Temperature {
  TemperatureCool
  TemperatureNeutral
  TemperatureWarm
} derive(Eq, Debug)

///|
pub(all) enum Severity {
  SeverityInfo
  SeverityWarning
  SeverityError
} derive(Eq, Debug)

///|
pub(all) enum TokenDiagnosticKind {
  DiagnosticEmptyName
  DiagnosticMissingAssignment
  DiagnosticUnknownRole
  DiagnosticBadColor(ParseError)
} derive(Eq, Debug)

///|
pub(all) enum RepairStrategy {
  RepairKeep
  RepairUseIdealText
  RepairDarkenForeground
  RepairLightenForeground
  RepairDarkenBackground
  RepairLightenBackground
} derive(Eq, Debug)

///|
pub(all) enum HarmonyKind {
  HarmonyComplementary
  HarmonyAnalogous
  HarmonyTriadic
  HarmonySplitComplementary
  HarmonyMonochrome
  HarmonyCustom
} derive(Eq, Debug)

///|
pub(all) struct Hsl {
  h : Double
  s : Double
  l : Double
} derive(Eq, Debug)

///|
pub(all) struct ChannelStats {
  min : Int
  max : Int
  average : Double
} derive(Eq, Debug)

///|
pub(all) struct ColorProfile {
  color : Color
  hex : String
  luminance : Double
  brightness : Double
  saturation : Double
  hue : Double
  temperature : Temperature
  ideal_text : Color
} derive(Eq, Debug)

///|
pub(all) struct RepairCandidate {
  color : Color
  ratio : Double
  delta : Double
  strategy : RepairStrategy
  steps : Int
} derive(Eq, Debug)

///|
pub(all) struct TokenDiagnostic {
  line : Int
  column : Int
  token : String
  severity : Severity
  kind : TokenDiagnosticKind
  message : String
} derive(Eq, Debug)

///|
pub(all) struct TokenParseReport {
  swatches : Array[Swatch]
  diagnostics : Array[TokenDiagnostic]
  ignored : Int
} derive(Eq, Debug)

///|
pub(all) struct PaletteStats {
  swatches : Int
  foregrounds : Int
  backgrounds : Int
  borders : Int
  average_luminance : Double
  darkest : Swatch?
  lightest : Swatch?
} derive(Eq, Debug)

///|
pub(all) struct RampAudit {
  family : String
  swatches : Array[Swatch]
  monotonic_luminance : Bool
  duplicate_hexes : Array[String]
  smallest_luminance_gap : Double
} derive(Eq, Debug)

///|
pub(all) struct DocumentAudit {
  tokens : TokenParseReport
  palette : PaletteReport
  stats : PaletteStats
} derive(Eq, Debug)

///|
pub fn Temperature::label(self : Temperature) -> String {
  match self {
    TemperatureCool => "cool"
    TemperatureNeutral => "neutral"
    TemperatureWarm => "warm"
  }
}

///|
pub fn Severity::label(self : Severity) -> String {
  match self {
    SeverityInfo => "info"
    SeverityWarning => "warning"
    SeverityError => "error"
  }
}

///|
pub fn RepairStrategy::label(self : RepairStrategy) -> String {
  match self {
    RepairKeep => "keep"
    RepairUseIdealText => "use-ideal-text"
    RepairDarkenForeground => "darken-foreground"
    RepairLightenForeground => "lighten-foreground"
    RepairDarkenBackground => "darken-background"
    RepairLightenBackground => "lighten-background"
  }
}

///|
pub fn HarmonyKind::label(self : HarmonyKind) -> String {
  match self {
    HarmonyComplementary => "complementary"
    HarmonyAnalogous => "analogous"
    HarmonyTriadic => "triadic"
    HarmonySplitComplementary => "split-complementary"
    HarmonyMonochrome => "monochrome"
    HarmonyCustom => "custom"
  }
}

///|
pub fn Color::red(self : Color) -> Int {
  self.r
}

///|
pub fn Color::green(self : Color) -> Int {
  self.g
}

///|
pub fn Color::blue(self : Color) -> Int {
  self.b
}

///|
pub fn Color::profile(self : Color) -> ColorProfile {
  let hsl = self.to_hsl()
  let ideal = self.ideal_text_color()
  {
    color: self,
    hex: self.to_hex(),
    luminance: self.relative_luminance(),
    brightness: self.perceived_brightness(),
    saturation: hsl.s,
    hue: hsl.h,
    temperature: self.temperature(),
    ideal_text: ideal,
  }
}

///|
pub fn Color::perceived_brightness(self : Color) -> Double {
  (
    self.r.to_double() * 299.0 +
    self.g.to_double() * 587.0 +
    self.b.to_double() * 114.0
  ) /
  1000.0
}

///|
pub fn Color::is_dark(self : Color) -> Bool {
  self.relative_luminance() < 0.35
}

///|
pub fn Color::is_light(self : Color) -> Bool {
  self.relative_luminance() > 0.65
}

///|
pub fn Color::ideal_text_color(self : Color) -> Color {
  let black = unchecked_color(0, 0, 0)
  let white = unchecked_color(255, 255, 255)
  if contrast_ratio(black, self) >= contrast_ratio(white, self) {
    black
  } else {
    white
  }
}

///|
pub fn Color::temperature(self : Color) -> Temperature {
  let h = self.to_hsl().h
  if self.to_hsl().s < 0.08 {
    TemperatureNeutral
  } else if h >= 35.0 && h <= 165.0 {
    TemperatureWarm
  } else if h >= 200.0 && h <= 310.0 {
    TemperatureCool
  } else if self.r > self.b {
    TemperatureWarm
  } else if self.b > self.r {
    TemperatureCool
  } else {
    TemperatureNeutral
  }
}

///|
pub fn Color::mix(self : Color, other : Color, amount : Double) -> Color {
  let t = clamp_double(amount, 0.0, 1.0)
  unchecked_color(
    round_channel(self.r.to_double() * (1.0 - t) + other.r.to_double() * t),
    round_channel(self.g.to_double() * (1.0 - t) + other.g.to_double() * t),
    round_channel(self.b.to_double() * (1.0 - t) + other.b.to_double() * t),
  )
}

///|
pub fn Color::lighten(self : Color, amount : Double) -> Color {
  self.mix(unchecked_color(255, 255, 255), amount)
}

///|
pub fn Color::darken(self : Color, amount : Double) -> Color {
  self.mix(unchecked_color(0, 0, 0), amount)
}

///|
pub fn Color::invert(self : Color) -> Color {
  unchecked_color(255 - self.r, 255 - self.g, 255 - self.b)
}

///|
pub fn Color::grayscale(self : Color) -> Color {
  let y = round_channel(self.perceived_brightness())
  unchecked_color(y, y, y)
}

///|
pub fn Color::distance_rgb(self : Color, other : Color) -> Double {
  let dr = self.r.to_double() - other.r.to_double()
  let dg = self.g.to_double() - other.g.to_double()
  let db = self.b.to_double() - other.b.to_double()
  @math.pow(dr * dr + dg * dg + db * db, 0.5)
}

///|
pub fn Color::weighted_distance(self : Color, other : Color) -> Double {
  let dr = (self.r - other.r).to_double()
  let dg = (self.g - other.g).to_double()
  let db = (self.b - other.b).to_double()
  @math.pow(dr * dr * 0.30 + dg * dg * 0.59 + db * db * 0.11, 0.5)
}

///|
pub fn Color::channel_spread(self : Color) -> Int {
  max_int(self.r, max_int(self.g, self.b)) -
  min_int(self.r, min_int(self.g, self.b))
}

///|
pub fn Color::to_hsl(self : Color) -> Hsl {
  let r = self.r.to_double() / 255.0
  let g = self.g.to_double() / 255.0
  let b = self.b.to_double() / 255.0
  let maxc = max_double(r, max_double(g, b))
  let minc = min_double(r, min_double(g, b))
  let l = (maxc + minc) / 2.0
  let delta = maxc - minc
  if delta == 0.0 {
    { h: 0.0, s: 0.0, l }
  } else {
    let s = if l > 0.5 {
      delta / (2.0 - maxc - minc)
    } else {
      delta / (maxc + minc)
    }
    let raw_h = if maxc == r {
      let offset = if g < b { 6.0 } else { 0.0 }
      (g - b) / delta + offset
    } else if maxc == g {
      (b - r) / delta + 2.0
    } else {
      (r - g) / delta + 4.0
    }
    { h: raw_h * 60.0, s, l }
  }
}

///|
pub fn Hsl::to_color(self : Hsl) -> Color {
  let h = normalize_hue(self.h) / 360.0
  let s = clamp_double(self.s, 0.0, 1.0)
  let l = clamp_double(self.l, 0.0, 1.0)
  if s == 0.0 {
    let c = round_channel(l * 255.0)
    unchecked_color(c, c, c)
  } else {
    let q = if l < 0.5 { l * (1.0 + s) } else { l + s - l * s }
    let p = 2.0 * l - q
    unchecked_color(
      round_channel(hue_to_rgb(p, q, h + 1.0 / 3.0) * 255.0),
      round_channel(hue_to_rgb(p, q, h) * 255.0),
      round_channel(hue_to_rgb(p, q, h - 1.0 / 3.0) * 255.0),
    )
  }
}

///|
pub fn Hsl::rotate(self : Hsl, degrees : Double) -> Hsl {
  { h: normalize_hue(self.h + degrees), s: self.s, l: self.l }
}

///|
pub fn Hsl::with_lightness(self : Hsl, lightness : Double) -> Hsl {
  { h: self.h, s: self.s, l: clamp_double(lightness, 0.0, 1.0) }
}

///|
pub fn Hsl::with_saturation(self : Hsl, saturation : Double) -> Hsl {
  { h: self.h, s: clamp_double(saturation, 0.0, 1.0), l: self.l }
}

///|
pub fn Color::rotate_hue(self : Color, degrees : Double) -> Color {
  self.to_hsl().rotate(degrees).to_color()
}

///|
pub fn Color::set_lightness(self : Color, lightness : Double) -> Color {
  self.to_hsl().with_lightness(lightness).to_color()
}

///|
pub fn Color::set_saturation(self : Color, saturation : Double) -> Color {
  self.to_hsl().with_saturation(saturation).to_color()
}

///|
pub fn Color::saturate(self : Color, amount : Double) -> Color {
  let hsl = self.to_hsl()
  hsl.with_saturation(hsl.s + amount).to_color()
}

///|
pub fn Color::desaturate(self : Color, amount : Double) -> Color {
  let hsl = self.to_hsl()
  hsl.with_saturation(hsl.s - amount).to_color()
}

///|
pub fn Color::harmonies(self : Color, kind : HarmonyKind) -> Array[Color] {
  match kind {
    HarmonyComplementary => [self, self.rotate_hue(180.0)]
    HarmonyAnalogous => [self.rotate_hue(-30.0), self, self.rotate_hue(30.0)]
    HarmonyTriadic => [self, self.rotate_hue(120.0), self.rotate_hue(240.0)]
    HarmonySplitComplementary =>
      [self, self.rotate_hue(150.0), self.rotate_hue(210.0)]
    HarmonyMonochrome =>
      [
        self.set_lightness(0.18),
        self.set_lightness(0.38),
        self.set_lightness(0.58),
        self.set_lightness(0.78),
      ]
    HarmonyCustom => [self]
  }
}

///|
pub fn readable_foreground(
  background : Color,
  policy : Policy,
) -> RepairCandidate {
  let black = unchecked_color(0, 0, 0)
  let white = unchecked_color(255, 255, 255)
  let required = minimum_ratio(policy)
  let black_ratio = contrast_ratio(black, background)
  let white_ratio = contrast_ratio(white, background)
  if black_ratio >= required && black_ratio >= white_ratio {
    {
      color: black,
      ratio: black_ratio,
      delta: 0.0,
      strategy: RepairUseIdealText,
      steps: 0,
    }
  } else if white_ratio >= required {
    {
      color: white,
      ratio: white_ratio,
      delta: 0.0,
      strategy: RepairUseIdealText,
      steps: 0,
    }
  } else if black_ratio >= white_ratio {
    {
      color: black,
      ratio: black_ratio,
      delta: 0.0,
      strategy: RepairUseIdealText,
      steps: 0,
    }
  } else {
    {
      color: white,
      ratio: white_ratio,
      delta: 0.0,
      strategy: RepairUseIdealText,
      steps: 0,
    }
  }
}

///|
pub fn repair_foreground(
  foreground : Color,
  background : Color,
  policy : Policy,
) -> RepairCandidate {
  let required = minimum_ratio(policy)
  let current = contrast_ratio(foreground, background)
  if current >= required {
    return {
      color: foreground,
      ratio: current,
      delta: 0.0,
      strategy: RepairKeep,
      steps: 0,
    }
  }
  let darker = search_foreground_path(
    foreground,
    background,
    required,
    unchecked_color(0, 0, 0),
    RepairDarkenForeground,
  )
  let lighter = search_foreground_path(
    foreground,
    background,
    required,
    unchecked_color(255, 255, 255),
    RepairLightenForeground,
  )
  choose_better_candidate(darker, lighter, required)
}

///|
pub fn repair_background(
  foreground : Color,
  background : Color,
  policy : Policy,
) -> RepairCandidate {
  let required = minimum_ratio(policy)
  let current = contrast_ratio(foreground, background)
  if current >= required {
    return {
      color: background,
      ratio: current,
      delta: 0.0,
      strategy: RepairKeep,
      steps: 0,
    }
  }
  let darker = search_background_path(
    foreground,
    background,
    required,
    unchecked_color(0, 0, 0),
    RepairDarkenBackground,
  )
  let lighter = search_background_path(
    foreground,
    background,
    required,
    unchecked_color(255, 255, 255),
    RepairLightenBackground,
  )
  choose_better_candidate(darker, lighter, required)
}

///|
pub fn swatch_profile(s : Swatch) -> ColorProfile {
  s.color.profile()
}

///|
pub fn palette_stats(swatches : Array[Swatch]) -> PaletteStats {
  let mut foregrounds = 0
  let mut backgrounds = 0
  let mut borders = 0
  let mut luminance = 0.0
  let mut darkest : Swatch? = None
  let mut lightest : Swatch? = None
  for s in swatches {
    if s.role.is_foreground() {
      foregrounds += 1
    }
    if s.role.is_background() {
      backgrounds += 1
    }
    if s.role == RoleBorder {
      borders += 1
    }
    let lum = s.color.relative_luminance()
    luminance += lum
    match darkest {
      None => darkest = Some(s)
      Some(current) =>
        if lum < current.color.relative_luminance() {
          darkest = Some(s)
        }
    }
    match lightest {
      None => lightest = Some(s)
      Some(current) =>
        if lum > current.color.relative_luminance() {
          lightest = Some(s)
        }
    }
  }
  let avg = if swatches.length() == 0 {
    0.0
  } else {
    luminance / swatches.length().to_double()
  }
  {
    swatches: swatches.length(),
    foregrounds,
    backgrounds,
    borders,
    average_luminance: avg,
    darkest,
    lightest,
  }
}

///|
pub fn channel_stats(
  swatches : Array[Swatch],
) -> (ChannelStats, ChannelStats, ChannelStats) {
  if swatches.length() == 0 {
    let empty = { min: 0, max: 0, average: 0.0 }
    return (empty, empty, empty)
  }
  let mut min_r = 255
  let mut min_g = 255
  let mut min_b = 255
  let mut max_r = 0
  let mut max_g = 0
  let mut max_b = 0
  let mut sum_r = 0
  let mut sum_g = 0
  let mut sum_b = 0
  for s in swatches {
    min_r = min_int(min_r, s.color.r)
    min_g = min_int(min_g, s.color.g)
    min_b = min_int(min_b, s.color.b)
    max_r = max_int(max_r, s.color.r)
    max_g = max_int(max_g, s.color.g)
    max_b = max_int(max_b, s.color.b)
    sum_r += s.color.r
    sum_g += s.color.g
    sum_b += s.color.b
  }
  let n = swatches.length().to_double()
  (
    { min: min_r, max: max_r, average: sum_r.to_double() / n },
    { min: min_g, max: max_g, average: sum_g.to_double() / n },
    { min: min_b, max: max_b, average: sum_b.to_double() / n },
  )
}

///|
pub fn audit_token_document(input : String, policy : Policy) -> DocumentAudit {
  let tokens = parse_token_document(input)
  let palette = audit_palette(tokens.swatches, policy)
  let stats = palette_stats(tokens.swatches)
  { tokens, palette, stats }
}

///|
pub fn parse_token_document(input : String) -> TokenParseReport {
  let swatches : Array[Swatch] = []
  let diagnostics : Array[TokenDiagnostic] = []
  let mut ignored = 0
  let lines = [ for line in input.split("\n") => line.to_owned() ]
  for index, raw in lines {
    let line_no = index + 1
    let line = raw.trim().to_owned()
    if should_ignore_token_line(line) {
      ignored += 1
    } else {
      parse_token_line(line, line_no, swatches, diagnostics)
    }
  }
  { swatches, diagnostics, ignored }
}

///|
pub fn TokenParseReport::has_errors(self : TokenParseReport) -> Bool {
  for diagnostic in self.diagnostics {
    if diagnostic.severity == SeverityError {
      return true
    }
  }
  false
}

///|
pub fn TokenParseReport::to_markdown(self : TokenParseReport) -> String {
  let out = StringBuilder()
  out.write_string("# PaletteGuard token parse\n\n")
  out.write_string("Swatches: " + self.swatches.length().to_string() + "\n")
  out.write_string(
    "Diagnostics: " + self.diagnostics.length().to_string() + "\n",
  )
  out.write_string("Ignored lines: " + self.ignored.to_string() + "\n\n")
  if self.diagnostics.length() > 0 {
    out.write_string("| line | column | severity | token | message |\n")
    out.write_string("| ---: | ---: | --- | --- | --- |\n")
    for diagnostic in self.diagnostics {
      out.write_string("| ")
      out.write_string(diagnostic.line.to_string())
      out.write_string(" | ")
      out.write_string(diagnostic.column.to_string())
      out.write_string(" | ")
      out.write_string(diagnostic.severity.label())
      out.write_string(" | ")
      out.write_string(diagnostic.token)
      out.write_string(" | ")
      out.write_string(diagnostic.message)
      out.write_string(" |\n")
    }
  }
  out.to_string()
}

///|
pub fn PaletteStats::to_markdown(self : PaletteStats) -> String {
  let out = StringBuilder()
  out.write_string("# PaletteGuard palette stats\n\n")
  out.write_string("- swatches: " + self.swatches.to_string() + "\n")
  out.write_string("- foregrounds: " + self.foregrounds.to_string() + "\n")
  out.write_string("- backgrounds: " + self.backgrounds.to_string() + "\n")
  out.write_string("- borders: " + self.borders.to_string() + "\n")
  out.write_string(
    "- average luminance: " + format_ratio(self.average_luminance) + "\n",
  )
  match self.darkest {
    None => out.write_string("- darkest: n/a\n")
    Some(s) =>
      out.write_string("- darkest: " + s.name + " " + s.color.to_hex() + "\n")
  }
  match self.lightest {
    None => out.write_string("- lightest: n/a\n")
    Some(s) =>
      out.write_string("- lightest: " + s.name + " " + s.color.to_hex() + "\n")
  }
  out.to_string()
}

///|
pub fn DocumentAudit::to_markdown(self : DocumentAudit) -> String {
  self.tokens.to_markdown() +
  "\n" +
  self.stats.to_markdown() +
  "\n" +
  self.palette.to_markdown()
}

///|
pub fn audit_ramp(family : String, swatches : Array[Swatch]) -> RampAudit {
  let duplicates : Array[String] = []
  let mut monotonic = true
  let mut direction = 0
  let mut previous : Swatch? = None
  let mut smallest_gap = 1.0
  for index, s in swatches {
    for j in 0..<index {
      if swatches[j].color == s.color && !duplicates.contains(s.color.to_hex()) {
        duplicates.push(s.color.to_hex())
      }
    }
    match previous {
      None => previous = Some(s)
      Some(last) => {
        let gap = s.color.relative_luminance() - last.color.relative_luminance()
        if gap > 0.0 {
          if direction < 0 {
            monotonic = false
          } else {
            direction = 1
          }
        } else if gap < 0.0 {
          if direction > 0 {
            monotonic = false
          } else {
            direction = -1
          }
        }
        smallest_gap = min_double(smallest_gap, abs_double(gap))
        previous = Some(s)
      }
    }
  }
  if swatches.length() <= 1 {
    smallest_gap = 0.0
  }
  {
    family,
    swatches,
    monotonic_luminance: monotonic,
    duplicate_hexes: duplicates,
    smallest_luminance_gap: smallest_gap,
  }
}

///|
pub fn RampAudit::to_markdown(self : RampAudit) -> String {
  let out = StringBuilder()
  out.write_string("# PaletteGuard ramp audit\n\n")
  out.write_string("Family: " + self.family + "\n")
  out.write_string("Swatches: " + self.swatches.length().to_string() + "\n")
  out.write_string("Monotonic luminance: ")
  out.write_string(if self.monotonic_luminance { "yes" } else { "no" })
  out.write_string("\n")
  out.write_string(
    "Smallest luminance gap: " +
    format_ratio(self.smallest_luminance_gap) +
    "\n",
  )
  if self.duplicate_hexes.length() > 0 {
    out.write_string(
      "Duplicate colors: " + self.duplicate_hexes.join(", ") + "\n",
    )
  } else {
    out.write_string("Duplicate colors: none\n")
  }
  out.to_string()
}

///|
pub fn contrast_matrix(swatches : Array[Swatch], policy : Policy) -> String {
  let out = StringBuilder()
  out.write_string("| foreground/background |")
  for bg in swatches {
    if bg.role.is_background() {
      out.write_string(" " + bg.name + " |")
    }
  }
  out.write_string("\n| --- |")
  for bg in swatches {
    if bg.role.is_background() {
      ignore(bg)
      out.write_string(" ---: |")
    }
  }
  out.write_string("\n")
  for fg in swatches {
    if fg.role.is_foreground() {
      out.write_string("| " + fg.name + " |")
      for bg in swatches {
        if bg.role.is_background() {
          let pair = audit_pair(fg, bg, policy)
          out.write_string(" " + format_ratio(pair.ratio))
          out.write_string(if pair.passed { " pass |" } else { " fail |" })
        }
      }
      out.write_string("\n")
    }
  }
  out.to_string()
}

///|
pub fn parse_role_token(token : String) -> Role? {
  let lower = token.trim().to_lower().to_owned()
  if lower.contains("text") || lower.contains("fg") || lower.contains("ink") {
    Some(RoleText)
  } else if lower.contains("accent") ||
    lower.contains("brand") ||
    lower.contains("link") {
    Some(RoleAccent)
  } else if lower.contains("background") ||
    lower.contains("bg") ||
    lower.contains("canvas") {
    Some(RoleBackground)
  } else if lower.contains("surface") ||
    lower.contains("panel") ||
    lower.contains("card") {
    Some(RoleSurface)
  } else if lower.contains("border") ||
    lower.contains("line") ||
    lower.contains("stroke") {
    Some(RoleBorder)
  } else {
    None
  }
}

///|
fn parse_token_line(
  line : String,
  line_no : Int,
  swatches : Array[Swatch],
  diagnostics : Array[TokenDiagnostic],
) -> Unit {
  let parts = split_assignment(line)
  if parts.length() != 2 {
    diagnostics.push(
      token_diagnostic(
        line_no,
        1,
        line,
        SeverityError,
        DiagnosticMissingAssignment,
        "expected token assignment with ':' or '='",
      ),
    )
    return
  }
  let name = parts[0].trim().to_owned()
  let value = parts[1].trim().to_owned()
  if name.length() == 0 {
    diagnostics.push(
      token_diagnostic(
        line_no,
        1,
        line,
        SeverityError,
        DiagnosticEmptyName,
        "token name cannot be empty",
      ),
    )
    return
  }
  match parse_role_token(name) {
    None =>
      diagnostics.push(
        token_diagnostic(
          line_no,
          1,
          name,
          SeverityWarning,
          DiagnosticUnknownRole,
          "role could not be inferred; token ignored",
        ),
      )
    Some(role) =>
      match parse_color(value) {
        ColorParsed(color) => swatches.push(swatch(name, color, role))
        ColorParseFailed(error) =>
          diagnostics.push(
            token_diagnostic(
              line_no,
              max_int(1, find_assignment_column(line) + 1),
              value,
              SeverityError,
              DiagnosticBadColor(error),
              "color value could not be parsed",
            ),
          )
      }
  }
}

///|
fn token_diagnostic(
  line : Int,
  column : Int,
  token : String,
  severity : Severity,
  kind : TokenDiagnosticKind,
  message : String,
) -> TokenDiagnostic {
  { line, column, token, severity, kind, message }
}

///|
fn split_assignment(line : String) -> Array[String] {
  if line.contains("=") {
    [
      for part in line.split("=") => part.to_owned()
    ]
  } else if line.contains(":") {
    [
      for part in line.split(":") => part.to_owned()
    ]
  } else {
    [line]
  }
}

///|
fn find_assignment_column(line : String) -> Int {
  let mut index = 0
  for ch in line.iter() {
    if ch == '=' || ch == ':' {
      return index
    }
    index += 1
  }
  0
}

///|
fn should_ignore_token_line(line : String) -> Bool {
  line.length() == 0 ||
  starts_with_string(line, "//") ||
  starts_with_string(line, "# ") ||
  starts_with_string(line, "--")
}

///|
fn starts_with_string(text : String, prefix : String) -> Bool {
  if prefix.length() > text.length() {
    return false
  }
  text[:prefix.length()].to_owned() == prefix
}

///|
fn search_foreground_path(
  foreground : Color,
  background : Color,
  required : Double,
  target : Color,
  strategy : RepairStrategy,
) -> RepairCandidate {
  let mut best = {
    color: target,
    ratio: contrast_ratio(target, background),
    delta: foreground.distance_rgb(target),
    strategy,
    steps: 100,
  }
  for step in 1..<=100 {
    let amount = step.to_double() / 100.0
    let candidate = foreground.mix(target, amount)
    let ratio = contrast_ratio(candidate, background)
    if ratio >= required {
      return {
        color: candidate,
        ratio,
        delta: foreground.distance_rgb(candidate),
        strategy,
        steps: step,
      }
    }
    if ratio > best.ratio {
      best = {
        color: candidate,
        ratio,
        delta: foreground.distance_rgb(candidate),
        strategy,
        steps: step,
      }
    }
  }
  best
}

///|
fn search_background_path(
  foreground : Color,
  background : Color,
  required : Double,
  target : Color,
  strategy : RepairStrategy,
) -> RepairCandidate {
  let mut best = {
    color: target,
    ratio: contrast_ratio(foreground, target),
    delta: background.distance_rgb(target),
    strategy,
    steps: 100,
  }
  for step in 1..<=100 {
    let amount = step.to_double() / 100.0
    let candidate = background.mix(target, amount)
    let ratio = contrast_ratio(foreground, candidate)
    if ratio >= required {
      return {
        color: candidate,
        ratio,
        delta: background.distance_rgb(candidate),
        strategy,
        steps: step,
      }
    }
    if ratio > best.ratio {
      best = {
        color: candidate,
        ratio,
        delta: background.distance_rgb(candidate),
        strategy,
        steps: step,
      }
    }
  }
  best
}

///|
fn choose_better_candidate(
  a : RepairCandidate,
  b : RepairCandidate,
  required : Double,
) -> RepairCandidate {
  let a_passes = a.ratio >= required
  let b_passes = b.ratio >= required
  if a_passes && !b_passes {
    a
  } else if b_passes && !a_passes {
    b
  } else if a_passes {
    if a.delta <= b.delta {
      a
    } else {
      b
    }
  } else if a.ratio > b.ratio {
    a
  } else if b.ratio > a.ratio {
    b
  } else if a.delta <= b.delta {
    a
  } else {
    b
  }
}

///|
fn hue_to_rgb(p : Double, q : Double, t : Double) -> Double {
  let mut x = t
  while x < 0.0 {
    x += 1.0
  }
  while x > 1.0 {
    x -= 1.0
  }
  if x < 1.0 / 6.0 {
    p + (q - p) * 6.0 * x
  } else if x < 1.0 / 2.0 {
    q
  } else if x < 2.0 / 3.0 {
    p + (q - p) * (2.0 / 3.0 - x) * 6.0
  } else {
    p
  }
}

///|
fn normalize_hue(value : Double) -> Double {
  let mut h = value
  while h < 0.0 {
    h += 360.0
  }
  while h >= 360.0 {
    h -= 360.0
  }
  h
}

///|
fn round_channel(value : Double) -> Int {
  clamp_int(@math.round(value).to_int(), 0, 255)
}

///|
fn clamp_int(value : Int, low : Int, high : Int) -> Int {
  if value < low {
    low
  } else if value > high {
    high
  } else {
    value
  }
}

///|
fn clamp_double(value : Double, low : Double, high : Double) -> Double {
  if value < low {
    low
  } else if value > high {
    high
  } else {
    value
  }
}

///|
fn max_int(a : Int, b : Int) -> Int {
  if a >= b {
    a
  } else {
    b
  }
}

///|
fn min_int(a : Int, b : Int) -> Int {
  if a <= b {
    a
  } else {
    b
  }
}

///|
fn max_double(a : Double, b : Double) -> Double {
  if a >= b {
    a
  } else {
    b
  }
}

///|
fn min_double(a : Double, b : Double) -> Double {
  if a <= b {
    a
  } else {
    b
  }
}

///|
fn abs_double(value : Double) -> Double {
  if value < 0.0 {
    -value
  } else {
    value
  }
}
