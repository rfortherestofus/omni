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

#let create-document-footer(
  title: none,
  organization_name: "Omni Institute",
  pagenumbering: "1",
  logo: "_extensions/omni_report/logo-no-text.png",
) = context {
  set text(size: 9pt, fill: rgb("#081c39"))
  line(length: 100%, stroke: 0.5pt + rgb("#bfcbd3"))
  v(6pt)
  grid(
    columns: (auto, 1fr, auto),
    column-gutter: 6pt,
    align: horizon,
    image(logo, height: 12pt),
    align(center)[#organization_name Report | #title],
    align(right)[#numbering(pagenumbering, ..counter(page).get())],
  )
}

#let create-cover-page(
  title: none,
  subtitle: none,
  date: none,
  organization_name: "Omni Institute",
  cover_pattern: "_extensions/omni_report/pattern-cover-01-yellow.png",
  logo: "_extensions/omni_report/logo.png",
) = {
  page(
    footer: none,
    background: align(bottom)[
      #image(cover_pattern, width: 100%, height: 45%, fit: "cover")
    ],
  )[
    #grid(
      columns: (1fr, 1fr),
      align(left + top)[#image(logo, width: 130pt)],
      align(right + top)[
        #text(size: 10pt, tracking: 1pt)[#upper[#date]]
      ],
    )
    #v(1.6in)
    #text(size: 10pt, fill: rgb("#677384"), tracking: 1pt)[#upper[#organization_name Report]]
    #v(0.6em)
    #text(size: 26pt, weight: "bold", fill: rgb("#081c39"))[#title]
    #v(0.7em)
    #line(length: 30%, stroke: 1pt + rgb("#d4ddeb"))
    #v(0.7em)
    #text(size: 15pt, weight: "bold", fill: rgb("#081c39"))[#subtitle]
  ]
}


#let create-title-page(
  title: none,
  subtitle: none,
  organization_name: "Omni Institute",
  client_name: none,
  client_city: none,
  client_state: none,
  contact_email: "projects@omni.org",
  acknowledgements: none,
  report_year: none,
) = {
  page()[
    #text(size: 10pt, fill: rgb("#677384"), tracking: 1pt)[#upper[#organization_name Report]]
    #v(0.6em)
    #text(size: 22pt, weight: "bold", fill: rgb("#081c39"))[#title]
    #v(0.3em)
    #text(size: 13pt, weight: "bold", fill: rgb("#081c39"))[#subtitle]
    #v(1.5em)
    #if client_name != none {
      text(weight: "bold")[Submitted to:]
      v(2pt)
      client_name
      v(1fr)
    } else {
      v(1fr)
    }
    #text(weight: "bold")[For More Information:]
    #v(2pt)
    #link("mailto:" + contact_email)[#underline[#contact_email]]
    #v(0.8em)
    #if acknowledgements != none {
      text(weight: "bold")[Acknowledgements:]
      v(2pt)
      par[#organization_name wants to thank #acknowledgements for their contributions to the creation of this report.]
      v(0.8em)
    }
    #text(weight: "bold")[Suggested Citation:]
    #v(2pt)
    #let location = (client_city, client_state).filter(p => p != none).join(", ")
    #par[#organization_name #report_year. #title. Submitted to #client_name, #location.]
  ]
}


#let create-toc-page(
  title: none,
  organization_name: "Omni Institute",
  toc_title: none,
  toc_depth: none,
  toc_indent: 1.5em,
) = {
  page()[
    #show outline.entry: it => {
      if it.level == 2 {
        v(6pt, weak: true)
        line(length: 100%, stroke: 0.5pt + rgb("#bfcbd3"))
        v(4pt, weak: true)
        // Overwrite _brand.yml link color
        show link: set text(fill: rgb("#081c39"))
        text(fill: rgb("#081c39"), weight: "bold")[
          #link(it.element.location(), it.body()) #h(1fr) #it.page()
        ]
      } else {
        pad(left: toc_indent)[
          #show link: set text(fill: rgb("#677384"))
          #text(fill: rgb("#677384"), size: 0.9em)[
            #link(it.element.location(), it.body()) #h(1fr) #it.page()
          ]
        ]
      }
    }
    #heading(level: 2, outlined: false)[
      #if toc_title == none { [Table of Contents] } else { toc_title }
    ]
    #v(1em)
    #outline(title: none, depth: toc_depth, indent: toc_indent)
  ]
}

#let create-page-break(
  title: none,
  pattern: "_extensions/omni_report/pattern-01-yellow.png",
) = {
  page(
    background: image(pattern, width: 100%, height: 100%, fit: "cover"),
    footer: none
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

