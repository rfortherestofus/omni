// Typst counterparts of the HTML design elements in R/design_elements.R.
// Called via raw `#function-name(...)` calls inserted by the *_typst()
// R functions (see as_typst()/`*_typst_raw()` in R/design_elements.R).
//
// Parameters are named `body` rather than `text` to avoid shadowing Typst's
// builtin `text` element function within these function bodies.

// Shrinks a fixed-pt width down to the available space (e.g. a narrow
// column) without ever growing past it, since box(width: <fixed pt>) alone
// would just overflow the container.
#let fit-width(width, body) = layout(size => {
  box(width: calc.min(width, size.width))[#body]
})

#let quote-box(body: none, author: none, color: rgb("#000000"), width: 300pt) = {
  fit-width(width)[
    #rect(fill: color, inset: (x: 20pt, y: 25pt), width: 100%, stroke: none)[
      #set text(fill: white, size: 11pt)
      #body
      #if author != none [
        #v(15pt)
        #text(size: 0.85em)[– #author]
      ]
    ]
    #v(-0.5cm)
    #align(right)[
      #polygon(fill: color, (0pt, 0pt), (20pt, 0pt), (20pt, 20pt))
    ]
  ]
}

#let callout-box(body: none, color: rgb("#000000"), width: 300pt) = {
  layout(size => {
    box(width: calc.min(width, size.width), inset: (left: 10pt, bottom: 3pt))[
      #rect(stroke: (left: 5pt + color), inset: (left: 10pt), width: 100%)[
        #set text(size: 11pt, fill: brand-color.at("primary"))
        #body
      ]
    ]
  })
}

#let number-emphasis(
  number: none,
  body: none,
  color: rgb("#000000"),
  font-size: 16pt,
  body-font-size: 12pt,
  width: 300pt,
) = {
  let circle-diameter = 75pt
  let overlap = 0.8cm
  fit-width(width)[
    // place() (not stack()) so the circle paints on top of the rect: stack()
    // ties paint order to layout order, so reordering its children would also
    // move the circle to the wrong (right) side.
    #box(width: 100%, height: circle-diameter)[
      #place(top + left, dx: circle-diameter - overlap)[
        #box(
          fill: color,
          inset: (left: 25pt, right: 10pt, y: 2pt),
          width: 100% - (circle-diameter - overlap),
          height: circle-diameter,
        )[
          #set text(fill: white, size: body-font-size, weight: 600)
          #set align(horizon)
          #body
        ]
      ]
      #place(top + left)[
        #circle(radius: circle-diameter / 2, fill: white, stroke: 5pt + color)[
          #align(center + horizon)[#text(size: font-size, weight: 600)[#number]]
        ]
      ]
    ]
  ]
}

#let icon-badge(svg: none, size: 50pt, bg: rgb("#000000")) = {
  set align(horizon)
  circle(radius: size / 2, fill: bg)[
    #align(center + horizon)[#image(bytes(svg), width: size * 0.7, format: "svg")]
  ]
}

#let icon-text(body: none, width: 400pt) = {
  set align(horizon)
  fit-width(width)[#body]
}

#let icon-grid(cells: (), width: 50pt, column-gap: 10pt, row-gap: 20pt) = {
  grid(
    columns: (width, 1fr),
    column-gutter: column-gap,
    row-gutter: row-gap,
    ..cells
  )
}
