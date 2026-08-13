// Margins are updated by article() function
// This state is created beforehand as this is inserted earlier via template.typ
#let appendix-margin-state = state("appendix-margin", (x: 1in, y: 1in))

// Mirrors Typst's own margin-dict precedence (left/top > x/y > rest) so the
// left/top offset can be recovered regardless of which shorthand the
// document's margin was specified with.
#let resolve-margin(m) = {
  let rest = m.at("rest", default: 0pt)
  let x = m.at("x", default: rest)
  let y = m.at("y", default: rest)
  (
    left: m.at("left", default: x),
    top: m.at("top", default: y),
  )
}

#let create-cover-page() = {
  page()[#align(center + horizon)[This will be the cover page]]
}


#let create-title-page() = {
  page()[#align(center + horizon)[This will be the title page]]
}

#let create-page-break(
  title: none,
  pattern: "_extensions/omni_report/pattern-01-yellow.png",
) = {
  page(
    background: image(pattern, width: 100%, height: 100%, fit: "cover"),
  )[
    #set text(fill: white)
    #v(2fr)
    #heading(level: 1, outlined: false, title)
    #v(1fr)
  ]
}


#let create-appendix-header(
  pattern: "_extensions/omni_report/pattern-appendix.png",
) = {
  pagebreak(weak: true)
  context {
    let height = page.height * 33%

    let m = resolve-margin(appendix-margin-state.get())
    place(
      top + left,
      dx: -m.left,
      dy: -m.top,
      image(pattern, width: page.width, height: height, fit: "cover"),
    )
    v(height * 90%)
  }
}

