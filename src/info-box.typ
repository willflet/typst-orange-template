#import("info-box-base.typ"): infobox
#import("_states.typ") as states


#let theorem(name: none, body) = {
  context {
    let language = states.language.at(here())
    let main-color = states.main-color.at(here())
    let fn = infobox(
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
    let language = states.language.at(here())
    let main-color = states.main-color.at(here())
    let fn = infobox(
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
    let language = states.language.at(here())
    let main-color = states.main-color.at(here())
    let fn = infobox(
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
    let language = states.language.at(here())
    let main-color = states.main-color.at(here())
    let fn = infobox(
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
    let language = states.language.at(here())
    let main-color = states.main-color.at(here())
    let fn = infobox(
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
    let language = states.language.at(here())
    let main-color = states.main-color.at(here())
    let fn = infobox(
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
    let language = states.language.at(here())
    let main-color = states.main-color.at(here())
    let fn = infobox(
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
    let language = states.language.at(here())
    let main-color = states.main-color.at(here())
    let fn = infobox(
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
    let language = states.language.at(here())
    let main-color = states.main-color.at(here())
    let fn = infobox(
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
    let main-color = states.main-color.at(here())
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
