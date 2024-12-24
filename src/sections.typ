#import("_states.typ") as states
#import("styles.typ"): *
#import("my-outline.typ"): my-outline, my-outline-small

#let cover(title: [], subtitle: [], author: [], cover-image: none, logo: none) = {
  context {
    let main-color = states.main-color.at(here())
    page(margin: 0cm, header: none)[
      #set text(fill: black)
      #if cover-image != none {
        set image(width: 100%, height: 100%)
        place(bottom)[#cover-image]
      }
      #if logo != none {
        set image(width: 3cm)
        place(top + center)[
          #pad(top:1cm)[#logo]
        ]
      }
      #align(center + horizon)[
        #block(width: 100%, fill: main-color.lighten(70%), height: 7.5cm)[
          #pad(x:2cm, y:1cm)[
            #par(leading: 0.4em)[
              #text(size: title-main-1, weight: "black")[#title]
            ]
            #v(1cm, weak: true)
            #text(size: title-main-2)[#subtitle]
            #v(1cm, weak: true)
            #text(size: title-main-3, weight: "bold")[#author]
          ]
        ]
      ]
    ]
  }
}

#let copyright-page(body) = {
  set text(size: 10pt)
  context {
    let main-color = states.main-color.at(here())
    show link: it => {
      set text(fill: main-color)
      it
    }
    set par(spacing: 2em)
    align(bottom)[
      #body
    ]
  }
}

#let quote-page(body) = {
  pagebreak()
  context {
    let main-color = states.main-color.at(here())
    let quote-page-style = states.quote-page-style.at(here())
    place(center, dy: 20%)[
      #par(leading: 0.8em)[
        #text(..quote-page-style)[
          #body
        ]
      ]
    ]
  }
}

#let toc-pages(
    toc-image: none,
    figure-toc: true,
    table-toc: true,
    figure-toc-title: "List of Figures",
    table-toc-title: "List of Tables") = {
  
  states.heading-image.update(toc-image)

  context {
    let main-color = states.main-color.at(here())
    my-outline(
      states.main-color,
      states.appendix,
      states.appendix-hide-parent,
      states.part,
      states.part-location,
      states.part-change,
      states.part-counter,
      text-size-1: outline-part,
      text-size-2: outline-heading1,
      text-size-3: outline-heading2,
      text-size-4: outline-heading3
    )
  }

  if figure-toc {
    my-outline-sec(
      figure-toc-title,
      figure.where(kind: image),
      text-size: outline-heading3
    )
  }

  if table-toc {
    my-outline-sec(
      table-toc-title,
      figure.where(kind: table),
      text-size: outline-heading3
    )
  }
}

#let main-pages(body) = {
  context {
    let main-color = states.main-color.at(here())
    set par(
      first-line-indent: 1em,
      justify: true,
      spacing: 0.5em
    )
    set block(spacing: 1.2em)
    show link: set text(fill: main-color)

    body
  }
}

#let part(title) = {
  pagebreak(to: "odd")
  states.part-change.update(x => true)
  states.part.update(x => title)
  states.part-counter.step()

  context {
    let loc = here()
    states.part-location.update(x => loc)
  }

  context {
    let main-color = states.main-color.at(here())
    let part-style = states.part-style.at(here())
    let part-prefix = states.part-prefix.at(here())
    if part-style == 0 [
      #set par(justify: false)
      #place()[
        #block(width:100%, height:100%, outset: (x: 3cm, bottom: 2.5cm, top: 3cm), fill: main-color.lighten(70%))
      ]
      #place(top+right)[
        #text(fill: black, size: large-text, weight: "bold")[
          #box(width: 60%)[
            #states.part.get()
          ]
        ]
      ]
      #place(top+left)[
        #text(fill: main-color, size: huge-text, weight: "bold")[
          #states.part-counter.display("I")
        ]
      ]
    ] else if part-style == 1 [
      #set par(justify: false)
      #place()[
        #block(width:100%, height:100%, outset: (x: 3cm, bottom: 2.5cm, top: 3cm), fill: main-color.lighten(70%))
      ]
      #place(top+left)[
        #block()[
          #text(fill: black, size: 2.5em, weight: "bold")[
            #(part-prefix + " " + states.part-counter.display("I"))
          ]
        ]
        #v(1cm, weak: true)
        #move(dx: -4pt)[
          #block()[
            #text(fill: main-color, size: 6em, weight: "bold")[
              #states.part.get()
            ]
          ]
        ]
      ]
    ]
    align(bottom+right)[
      #my-outline-small(
        title,
        states.main-color,
        states.appendix,
        states.part,
        text-size-1: outline-part,
        text-size-2: outline-heading1,
        text-size-3: outline-heading2,
        text-size-4: outline-heading3
      )
    ]
  }
}

#let chapter(title, numbered: true, image: none, l: none) = {
  states.heading-image.update(image)

  if l != none {
    if numbered [
      #heading(level: 1)[#title] #label(l)
    ] else [
      #heading(level: 1, numbering: none)[#title] #label(l)
    ]
  } else {
    if numbered [
      #heading(level: 1)[#title]
    ] else [
      #heading(level: 1, numbering: none)[#title]
    ]
  }
}

#let my-bibliography(bib, image: none) = {
  counter(heading).update(0)
  states.heading-image.update(image)
  bib
}

#let appendices(title, doc, hide-parent: false) = {
  counter(heading).update(0)
  states.appendix.update(x => title)
  states.appendix-hide-parent.update(x => hide-parent)
  let appendix-numbering(..nums) = {
    let vals = nums.pos()
    if vals.len() == 1 {
      return str(numbering("A.1", ..vals)) + "."
    } else {
      context {
        let main-color = states.main-color.at(here())
        let color = main-color
        if vals.len() == 4 {
          color = black
        }
        return place(dx:-4.5cm)[
          #box(width: 4cm)[
            #align(right)[
              #text(fill: color)[
                #numbering("A.1", ..vals)
              ]
            ]
          ]
        ]
      }
    }
  }
  set heading(numbering: appendix-numbering)
  doc
}
