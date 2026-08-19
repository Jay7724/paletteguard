///|
fn main {
  println(@paletteguard.demo_report())
  let summary = @paletteguard.catalog_summary("aurora")
  println(
    "Catalog families: " + @paletteguard.catalog_families().length().to_string(),
  )
  println("Aurora swatches: " + summary.total.to_string())
  println(
    @paletteguard.contrast_matrix(
      @paletteguard.catalog_palette_for_family("aurora"),
      @paletteguard.policy_large_aa(),
    ),
  )
}
