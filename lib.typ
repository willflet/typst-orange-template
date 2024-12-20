#import("/src/_states.typ") as states: *

#states.language.update(none)
#states.main-color.update(none)
#states.appendix.update(none)
#states.appendix-hide-parent.update(none)
#states.heading-image.update(none)
#states.part-prefix.update(none)
#states.part-style.update(none)
#states.part.update(none)
#states.part-location.update(none)
#states.part-counter.update(0)
#states.part-change.update(none)
#states.quote-page-style.update(none)

#import("/src/my-outline.typ"): my-outline, my-outline-small, my-outline-sec
#import("/src/my-index.typ"): index, make-index
#import("/src/book.typ"): book
#import("/src/sections.typ"): part, chapter, cover, quote-page, copyright-page, toc-pages, main-pages, my-bibliography, appendices 
#import("/src/info-box.typ"): theorem, definition, corollary, proposition, notation, exercise, example, problem, vocabulary, remark
#import("/src/styles.typ"): mathcal, scr, nocite
