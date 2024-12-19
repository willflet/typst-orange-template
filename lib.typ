#import("my-outline.typ"): my-outline, my-outline-small, my-outline-sec
#import("my-index.typ"): index, make-index-int
#import("theorems.typ"): thmbox

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


#let nocite(citation) = {
  place()[#hide(cite(citation))]
}

#let z-language = state("language", none)
#let z-main-color = state("main-color", none)
#let z-appendix = state("appendix", none)
#let z-appendix-hide-parent = state("appendix-hide-parent", none)
#let z-heading-image = state("heading-image", none)
#let z-part-prefix = state("part-prefix", none)
#let z-part-style = state("part-style", 0)
#let z-part = state("part", none)
#let z-part-location = state("part-location", none)
#let z-part-counter = counter("part-counter")
#let z-part-change = state("part-change", false)

#let part(title) = {
  pagebreak(to: "odd")
  z-part-change.update(x => true)
  z-part.update(x => title)
  z-part-counter.step()

  context {
    let loc = here()
    z-part-location.update(x => loc)
  }

  context {
    let main-color = z-main-color.at(here())
    let part-style = z-part-style.at(here())
    let part-prefix = z-part-prefix.at(here())
    if part-style == 0 [
      #set par(justify: false)
      #place()[
        #block(width:100%, height:100%, outset: (x: 3cm, bottom: 2.5cm, top: 3cm), fill: main-color.lighten(70%))
      ]
      #place(top+right)[
        #text(fill: black, size: large-text, weight: "bold")[
          #box(width: 60%)[
            #z-part.get()
          ]
        ]
      ]
      #place(top+left)[
        #text(fill: main-color, size: huge-text, weight: "bold")[
          #z-part-counter.display("I")
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
            #(part-prefix + " " + z-part-counter.display("I"))
          ]
        ]
        #v(1cm, weak: true)
        #move(dx: -4pt)[
          #block()[
            #text(fill: main-color, size: 6em, weight: "bold")[
              #z-part.get()
            ]
          ]
        ]
      ]
    ]
    align(bottom+right)[
      #my-outline-small(
        title,
        z-appendix,
        z-part,
        z-part-location,
        z-part-change,
        z-part-counter,
        main-color,
        text-size-1: outline-part,
        text-size-2: outline-heading1,
        text-size-3: outline-heading2,
        text-size-4: outline-heading3
      )
    ]
  }
}

#let update-heading-image(image) = {
  z-heading-image.update(x => image)
}

#let chapter(title, numbered: true, image: none, l: none) = {
  update-heading-image(image)

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

#let make-index(title: none) = {
  make-index-int(title: title, z-main-color: z-main-color)
}

#let appendices(title, doc, hide-parent: false) = {
  counter(heading).update(0)
  z-appendix.update(x => title)
  z-appendix-hide-parent.update(x => hide-parent)
  let appendix-numbering(..nums) = {
    let vals = nums.pos()
    if vals.len() == 1 {
      return str(numbering("A.1", ..vals)) + "."
    } else {
      context {
        let main-color = z-main-color.at(here())
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

#let my-bibliography(bib, image: none) = {
  counter(heading).update(0)
  update-heading-image(image)
  bib
}

#let theorem(name: none, body) = {
  context {
    let language = z-language.at(here())
    let main-color = z-main-color.at(here())
    let fn = thmbox(
      identifier: "theorem",
      head: if language == "en" {"Theorem"} else {"Teorema"},
      fill: black.lighten(95%),
      stroke: 0.5pt + main-color,
      inset: 0.65em,
      radius: 0em,
      namefmt: x => [*--- #x.*],
      titlefmt: x => text(weight: "bold", fill: main-color)[#x],
      separator: h(0.2em),
      base_level: 1,
    )
    fn(name: name)[
      #body
    ]
  }
}

#let definition(name: none, body) = {
  context {
    let language = z-language.at(here())
    let main-color = z-main-color.at(here())
    let fn = thmbox(
      identifier: "definition",
      head: if language == "en" {"Definition"} else {"Definizione"},
      stroke: (left: 4pt + main-color),
      inset: (x: 0.65em),
      radius: 0em,
      namefmt: x => [*--- #x.*],
      titlefmt: x => text(weight: "bold")[#x], 
      separator: h(0.2em),
      base_level: 1
    )
    fn(name: name)[
      #body
    ]
  }
}

#let corollary(name: none, body) = {
  context {
    let language = z-language.at(here())
    let main-color = z-main-color.at(here())
    let fn = thmbox(
      identifier: "corollary",
      head: if language == "en" {"Corollary"} else {"Corollario"},
      fill: black.lighten(95%), 
      stroke: (left: 4pt + gray),
      inset: 0.65em,
      radius: 0em,
      namefmt: x => [*--- #x.*],
      titlefmt: x => text(weight: "bold")[#x],
      separator: h(0.2em),
      base_level: 1
    )
    fn(name: name)[
      #body
    ]
  }
}

#let proposition(name: none, body) = {
  context {
    let language = z-language.at(here())
    let main-color = z-main-color.at(here())
    let fn = thmbox(
      identifier: "proposition",
      head: if language == "en" {"Proposition"} else {"Proposizione"},
      inset: 0em,
      radius: 0em,
      namefmt: x => [*--- #x.*],
      titlefmt: x => text(weight: "bold", fill: main-color)[#x],
      separator: h(0.2em),
      base_level: 1
    )
    fn(name: name)[
      #body
    ]
  }
}

#let notation(name: none, body) = {
  context {
    let language = z-language.at(here())
    let main-color = z-main-color.at(here())
    let fn = thmbox(
      identifier: "notation",
      head: if language == "en" {"Notation"} else {"Nota"},
      stroke: none,
      inset: 0em,
      radius: 0em,
      namefmt: x => [*--- #x.*],
      titlefmt: x => text(weight: "bold")[#x],
      separator: h(0.2em),
      base_level: 1
    )
    fn(name: name)[
      #body
    ]
  }
}

#let exercise(name: none, body) = {
  context {
    let language = z-language.at(here())
    let main-color = z-main-color.at(here())
    let fn = thmbox(
      identifier: "exercise",
      head: if language == "en" {"Exercise"} else {"Esercizio"},
      fill: main-color.lighten(90%), 
      stroke: (left: 4pt + main-color),
      inset: 0.65em,
      radius: 0em,
      namefmt: x => [*--- #x.*],
      titlefmt: x => text(fill: main-color, weight: "bold")[#x],
      separator: h(0.2em),
      base_level: 1
    )
    fn(name: name)[
      #body
    ]
  }
}

#let example(name: none, body) = {
  context {
    let language = z-language.at(here())
    let main-color = z-main-color.at(here())
    let fn = thmbox(
      identifier: "example",
      head: if language == "en" {"Example"} else {"Esempio"},
      stroke: none,
      inset: 0em,
      radius: 0em,
      namefmt: x => [*--- #x.*],
      titlefmt: x => text(weight: "bold")[#x],
      separator: h(0.2em),
      base_level: 1
    )
    fn(name: name)[
      #body
    ]
  }
}

#let problem(name: none, body) = {
  context {
    let language = z-language.at(here())
    let main-color = z-main-color.at(here())
    let fn = thmbox(
      identifier: "problem",
      head: if language == "en" {"Problem"} else {"Problema"},
      stroke: none,
      inset: 0em,
      radius: 0em,
      namefmt: x => [*--- #x.*],
      titlefmt: x => text(fill: main-color, weight: "bold")[#x],
      separator: h(0.2em),
      base_level: 1
    )
    fn(name: name)[
      #body
    ]
  }
}

#let vocabulary(name: none, body) = {
  context {
    let language = z-language.at(here())
    let main-color = z-main-color.at(here())
    let fn = thmbox(
      identifier: "vocabulary",
      head: if language == "en" {"Vocabulary"} else {"Vocabolario"},
      stroke: none,
      inset: 0em,
      radius: 0em,
      namefmt: x => [*--- #x.*],
      titlefmt: x => [■ #text(weight: "bold")[#x]],
      separator: h(0.2em),
      base_level: 1
    )
    fn(name: name)[
      #body
    ]
  }
}

#let remark(body) = {
   context {
    let main-color = z-main-color.at(here())
    set par(first-line-indent: 0em)
    grid(
      columns: (1.2cm, 1fr),
      align: (center, left),
      rows: (auto),
      ..(
        circle(radius: 0.3cm, fill: main-color.lighten(70%), stroke: main-color.lighten(30%))[
          #set align(center + horizon)
          #set text(fill: main-color, weight: "bold")
          R
        ],
        body
      )
    )
  }
}

#let cover-page(title: [], subtitle: [], author: [], cover: none, logo: none) = {
  context {
    let main-color = z-main-color.at(here())
    page(margin: 0cm, header: none)[
      #set text(fill: black)
      #if cover != none {
        set image(width: 100%, height: 100%)
        place(bottom)[#cover]
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
            #text(font: "Lato", style: "normal", size: title-main-3, weight: "bold")[#author]
          ]
        ]
      ]
    ]
  }
}


#let copyright-page(body) = {
  set text(size: 10pt)
  context {
    let main-color = z-main-color.at(here())
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

#let index-pages(
    index-image: none,
    figure-index: true,
    table-index: true,
    figure-index-title: "List of Figures",
    table-index-title: "List of Tables") = {
  
  update-heading-image(index-image)

  context {
    let main-color = z-main-color.at(here())
    my-outline(
      z-appendix,
      z-appendix-hide-parent,
      z-part,
      z-part-location,
      z-part-change,
      z-part-counter,
      main-color,
      text-size-1: outline-part,
      text-size-2: outline-heading1,
      text-size-3: outline-heading2,
      text-size-4: outline-heading3
    )
  }

  if figure-index {
    my-outline-sec(
      figure-index-title,
      figure.where(kind: image),
      text-size: outline-heading3
    )
  }

  if table-index {
    my-outline-sec(
      table-index-title,
      figure.where(kind: table),
      text-size: outline-heading3
    )
  }
}

#let main-pages(body) = {
  context {
    let main-color = z-main-color.at(here())
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

#let book(
    body,
    title: "",
    author: "",
    paper-size: "a4",
    main-color: blue,
    lang: "en",
    chapter-prefix: "Chapter",
    part-prefix: "Part",
    font-size: 10pt,
    part-style: 0,
    lowercase-references: false) = {
  set document(author: author, title: title)
  set text(size: font-size, lang: lang)
  set par(leading: 0.5em)
  set enum(numbering: "1.a.i.")
  set list(marker: ([•], [--], [◦]))

  if lowercase-references {
    set ref(supplement: it => {lower(it.supplement)})
  }

  set math.equation(
    numbering: num => numbering("(1.1)", counter(heading).get().first(), num)
  )

  set figure(
    numbering: num => numbering("1.1", counter(heading).get().first(), num),
    gap: 1.3em
  )

  show figure: it => {
    align(center)[
      #it
      #if (it.placement == none){
        v(2.6em, weak: true)
      }
    ]
  }

  show terms: set par(first-line-indent: 0em)

  set page(
    paper: paper-size,
    margin: (x: 3cm, bottom: 2.5cm, top: 3cm),
    header: context {
      set text(size: title5)
      let page_number = counter(page).at(here()).first()
      let odd_page = calc.odd(page_number)
      let part_change = z-part-change.at(here())
      // Are we on an odd page?
      // if odd_page {
      //   return text(0.95em, smallcaps(title))
      // }

      // Are we on a page that starts a chapter? (We also check
      // the previous page because some headings contain pagebreaks.)
      let all = query(heading.where(level: 1))
      if all.any(it => it.location().page() == page_number) or part_change {
        return
      }
      let appendix = z-appendix.at(here())      
      if odd_page {
        let before = query(selector(heading.where(level: 2)).before(here()))
        let counter-int = counter(heading).at(here())
        if before != () and counter-int.len()> 2 {
          box(width: 100%, inset: (bottom: 5pt), stroke: (bottom: 0.5pt))[
            #text()[
              #if appendix != none {
                numbering("A.1", ..counter-int.slice(1,3)) + " " + before.last().body
              } else {
                numbering("1.1", ..counter-int.slice(1,3)) + " " + before.last().body
              }
            ]
            #h(1fr)
            #page_number
          ]
        }
      } else {
        let before = query(selector(heading.where(level: 1)).before(here()))
        let counter-int = counter(heading).at(here()).first()
        if before != () and counter-int > 0 {
          box(width: 100%, inset: (bottom: 5pt), stroke: (bottom: 0.5pt))[
            #page_number
            #h(1fr)
            #text(weight: "bold")[
              #if appendix != none {
                numbering("A.1", counter-int) + ". " + before.last().body
              } else {
                before.last().supplement + " " + str(counter-int) + ". " + before.last().body
              }
            ]
          ]
        }
      }
    }
  )

  show cite: it => {
    show regex("\[(\d+)"): set text(main-color)
    it
  }

  set heading(
    hanging-indent: 0pt,
    numbering: (..nums) => {
      let vals = nums.pos()
      let pattern = if vals.len() == 1 { "1." } else if vals.len() <= 4 { "1.1" }
      if pattern != none {
        numbering(pattern, ..nums)
      }
    }
  )

  show heading.where(level: 1): set heading(supplement: chapter-prefix)

  show heading: it => {
    set text(size: font-size)
    if it.level == 1 {
      pagebreak(to: "odd")
      counter(figure.where(kind: image)).update(0)
      counter(figure.where(kind: table)).update(0)
      counter(math.equation).update(0)
      context {
        let img = z-heading-image.at(here())
        if img != none {
          set image(width: 21cm, height: 9.4cm)
          place(
            move(dx: -3cm, dy: -3cm)[#img]
          )
          place(
            move(dx: -3cm, dy: -3cm)[
              #block(width: 21cm, height: 9.4cm)[
                #align(right + bottom)[
                  #pad(bottom: 1.2cm)[
                    #block(
                      width: 86%,
                      stroke: (
                        right: none,
                        rest: 2pt + main-color,
                      ),
                      inset: (left:2em, rest: 1.6em),
                      fill: rgb("#FFFFFFAA"),
                      radius: (
                        right: 0pt,
                        left: 10pt,
                      )
                    )[
                      #align(left)[#text(size: title1)[#it]]
                    ]
                  ]
                ]
              ]
            ]
          )
          v(8.4cm)
        } else {
          move(dx: 3cm, dy: -0.5cm)[
            #align(right + top)[
              #block(
                width: 100% + 3cm,
                stroke: (
                  right: none,
                  rest: 2pt + main-color,
                ),
                inset: (left:2em, rest: 1.6em),
                fill: white,
                radius: (
                  right: 0pt,
                  left: 10pt,
                )
              )[
                #align(left)[#text(size: title1)[#it]]
              ]
            ]
          ]
          v(1.5cm, weak: true)
        }
      }
      z-part-change.update(x =>
        false
      )
    } else if it.level == 2 or it.level == 3 or it.level == 4 {
      let size
      let space
      let color = main-color
      if it.level == 2 {
        size = title2
        space = 1em
      } else if it.level == 3 {
        size = title3
        space = 0.9em
      } else {
        size = title4
        space = 0.7em
        color = black
      }
      set text(size: size)
      let number = if it.numbering != none {
        set text(fill: main-color) if it.level < 4
        let num = counter(heading).display(it.numbering)
        let width = measure(num).width
        let gap = 7mm
        place(dx: -width - gap)[#num]
      }
      block(number + it.body)
      v(space, weak: true)
    } else {
      it
    } 
  }

  set underline(offset: 3pt)

  z-language.update(x => lang)
  z-main-color.update(x => main-color)
  z-part-style.update(x => part-style)
  z-part-prefix.update(x => part-prefix)
  //place(top, image("images/background2.jpg", width: 100%, height: 50%))

  body

}
