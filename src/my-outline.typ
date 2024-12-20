#import("_states.typ") as states: *

#let my-outline-row(
    text-size: none,
    text-weight: "regular",
    inset-size: 0pt,
    text-color: blue,
    number: "0",
    number-offset: 0cm,
    title: none,
    heading-page: "0",
    location: none) = {
  set text(size: text-size, fill: text-color, weight: text-weight)
  box(width: 1.4cm, inset: (y: inset-size))[
    #align(left)[#h(number-offset) #number]
  ]
  h(0.1cm)
  box(inset: (y: inset-size), width: 1fr)[
    #link(location, title)
    #box(width: 1fr)[
      #repeat()[
        #text(weight: "regular")[. #h(4pt)]
      ]
    ]
    #link(location, heading-page)
  ]
}

#let my-outline(
    z-main-color,
    z-appendix,
    z-appendix-hide-parent,
    z-part,
    z-part-location,
    z-part-change,
    z-part-counter,
    text-size-1: none,
    text-size-2: none,
    text-size-3: none,
    text-size-4: none) = {

  show outline.entry: it => {
    context {
      let main-color = z-main-color.at(here())
      let appendix-state = z-appendix.at(it.element.location())
      let appendix-state-hide-parent = z-appendix-hide-parent.at(it.element.location())
      let numbering-format = if appendix-state != none {"A.1"} else {"1.1"}
      let counter-int = counter(heading).at(it.element.location())
      let number = none
      if counter-int.first() > 0 {
        number = numbering(numbering-format, ..counter-int)
      }
      let title = it.element.body
      let heading-page = it.page

      if it.level == 1 {
        let part-state = z-part.at(it.element.location())
        let part-location = z-part-location.at(it.element.location())
        let part-change = z-part-change.at(it.element.location())
        let part-counter = z-part-counter.at(it.element.location())
        if (part-change){
          v(0.7cm, weak: true)
          box(width: 1.4cm, fill: main-color.lighten(80%), inset: 5pt)[
            #align(center)[
              #text(size: text-size-1, weight: "bold", fill: main-color.lighten(30%))[
                #numbering("I", part-counter.first())
              ]
            ]
          ]
          h(0.1cm)
          box(width: 1fr, fill: main-color.lighten(60%), inset: 5pt)[
            #align(center)[
              #link(part-location, text(size: text-size-1, weight: "bold")[#part-state])
            ]
          ]
          v(0.45cm, weak: true)
        }
        else{
          v(0.5cm, weak: true)
        }
        if (counter-int.first() == 1 and appendix-state != none and not appendix-state-hide-parent){
          my-outline-row(
            inset-size: 2pt,
            text-weight: "bold",
            text-size: text-size-2,
            text-color: main-color,
            number: none,
            title: appendix-state,
            heading-page: heading-page,
            location: it.element.location()
          )
          v(0.5cm, weak: true)
        }
        my-outline-row(
          inset-size: 2pt,
          text-weight: "bold",
          text-size: text-size-2,
          text-color: main-color,
          number: number,
          title: title,
          heading-page: heading-page,
          location: it.element.location()
        )
      }
      else if it.level ==2 {
        my-outline-row(
          inset-size: 2pt,
          text-weight: "bold",
          text-size: text-size-3,
          text-color: black,
          number: number.trim(number.split(".").at(0), at: start, repeat: false),
          number-offset: 0.25cm,
          title: title,
          heading-page: heading-page,
          location: it.element.location()
        )
      } else {
        my-outline-row(
          text-weight: "regular",
          text-size: text-size-4,
          text-color: black,
          number: number.trim(number.split(".").at(0), at: start, repeat: false),
          number-offset: 0.25cm,
          title: title,
          heading-page: heading-page,
          location: it.element.location()
        )
      }
    }
  }
  outline(depth: 3, indent: false)
}

#let my-outline-small(
    part-title,
    z-main-color,
    z-appendix,
    z-part,
    text-size-1: none,
    text-size-2: none,
    text-size-3: none,
    text-size-4: none) = {
  
  show outline.entry: it => {
    context {
      let main-color = z-main-color.at(here())
      let appendix-state = z-appendix.at(it.element.location())
      let numbering-format = if appendix-state != none {"A.1"} else {"1.1"}
      let counter-int = counter(heading).at(it.element.location())
      let number = none
      if counter-int.first() > 0 {
        number = numbering(numbering-format, ..counter-int)
      }
      let title = it.element.body
      let heading-page = it.page
      let part-state = z-part.at(it.element.location())
      if (part-state == part-title and counter-int.first() > 0 and appendix-state == none){
        if it.level == 1 {
          v(0.5cm, weak: true)
          my-outline-row(
            inset-size: 1pt,
            text-weight: "bold",
            text-size: text-size-2,
            text-color: main-color,
            number: number,
            title: title,
            heading-page: heading-page,
            location: it.element.location()
          )
        }
        else if it.level == 2 {
          my-outline-row(
            text-weight: "regular",
            text-size: text-size-4,
            text-color: black,
            number: number,
            title: text(fill: black)[#title],
            heading-page: text(fill: black)[#heading-page],
            location: it.element.location()
          )
        }
      }
      else{
        v(-0.65em, weak: true)
      }
    }
  }
  box(width: 9.5cm)[
    #outline(depth: 2, indent: false, title: none)
  ]
}

#let my-outline-sec(title, target, text-size: 1em) = {
  show outline.entry.where(level: 1): it => {
    let heading-page = it.page
    [
      #set text(size: text-size)
      #box(width: 0.75cm)[
        #align(right)[
          #it.body.at("children").at(2) #h(0.2cm)
        ]
      ]
      #link(it.element.location(), it.element.at("caption").body)
      #box(width: 1fr)[
        #repeat()[
          #text(weight: "regular")[. #h(4pt)]
        ]
      ]
      #link(it.element.location(), heading-page)
    ]
  }
  outline(
    title: title,
    target: target,
  )
}
