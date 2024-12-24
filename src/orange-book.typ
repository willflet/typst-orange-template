#import("_states.typ") as states
#import("styles.typ"): *

#let orange-book(
    body,
    title: "",
    author: "",
    paper-size: "a4",
    main-color: blue,
    lang: "en",
    chapter-prefix: "Chapter",
    part-prefix: "Part",
    main-font: "New Computer Modern",
    math-font: "New Computer Modern Math",
    raw-font: "DejaVu Sans Mono",
    font-size: 10pt,
    part-style: 0,
    quote-page-style: (size: 16pt),
    lowercase-references: false) = {
  set document(author: author, title: title)

  set text(font: main-font, size: font-size, lang: lang)
  set par(leading: 0.5em)
  set enum(numbering: "1.a.i.")
  set list(marker: ([•], [--], [◦]))
  
  show math.equation: set text(font: math-font)
  show raw: set text(font: raw-font)

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
      let part_change = states.part-change.at(here())
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
      let appendix = states.appendix.at(here())      
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
        let img = states.heading-image.at(here())
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
      states.part-change.update(x =>
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

  states.language.update(x => lang)
  states.main-color.update(x => main-color)
  states.part-style.update(x => part-style)
  states.quote-page-style.update(x => quote-page-style)
  states.part-prefix.update(x => part-prefix)
  //place(top, image("images/background2.jpg", width: 100%, height: 50%))

  body

}
