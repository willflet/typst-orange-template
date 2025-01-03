#let language = state("language", none)
#let main-color = state("main-color", none)
#let appendix = state("appendix", none)
#let appendix-hide-parent = state("appendix-hide-parent", none)
#let heading-image = state("heading-image", none)
#let part-prefix = state("part-prefix", none)
#let part-style = state("part-style", 0)
#let part = state("part", none)
#let part-location = state("part-location", none)
#let part-counter = counter("part-counter")
#let part-change = state("part-change", false)
#let quote-page-style = state("quote-page-style", none)

#let update-heading-image(image: none) = {
  heading-image.update(image)
}
