#let normal-text = 1em
#let large-text = 3em
#let huge-text = 16em
#let title-main-1 = 2.5em
#let title-main-2 = 1.8em
#let title-main-3 = 2.2em
#let title1 = 2.2em
#let title2 = 1.5em
#let title3 = 1.3em
#let title4 = 1.2em
#let title5 = 11pt

#let outline-part = 1.5em;
#let outline-heading1 = 1.3em;
#let outline-heading2 = 1.1em;
#let outline-heading3 = 1.1em;

#let scr(it) = {
  text(features: ("ss01",))[
    #box()[$cal(it)$]
  ]
}

#let mathcal(it) = {
  text(size: 1.3em, font: "OPTIOriginal", fallback: false)[
    #it
  ]
  h(0.1em)
}

#let nocite(citation) = {
  place()[#hide(cite(citation))]
}
