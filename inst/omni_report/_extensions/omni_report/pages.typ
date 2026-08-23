// Margins are updated by article() function
// This state is created beforehand as this is inserted earlier via template.typ
#let appendix-margin-state = state("appendix-margin", (x: 1in, y: 1in))

// Track footer state so that page break functions can access that
#let footer-info-state = state(
  "footer-info",
  (title: none, organization-name: "Omni Institute", page-numbering: "1"),
)

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
  organization-name: "Omni Institute",
  page-numbering: "1",
  logo: "_extensions/omni_report/logo-no-text.png",
  inverted: false,
  with-line: true,
) = context {
  let text-color = if inverted { white } else { brand-color.at("primary") }
  let line-color = if inverted { white } else { brand-color.at("steel-blue-200") }
  let muted-color = if inverted { white } else { brand-color.at("secondary") }
  set text(size: 10pt, fill: text-color)
  if with-line {
    line(length: 100%, stroke: 0.5pt + line-color)
    v(0.3cm, weak: true)
  }
  grid(
    inset: 0cm,
    columns: (auto, 1fr, auto),
    column-gutter: 6pt,
    align: horizon,
    image(logo, height: 0.75cm),
    align(right)[#organization-name Report | #text(fill: muted-color, title) #h(0.5cm)],
    align(right)[#numbering(page-numbering, ..counter(page).get())],
  )
}

#let create-cover-page(
  title: none,
  subtitle: none,
  date: none,
  organization-name: "Omni Institute",
  cover-pattern: "_extensions/omni_report/pattern-cover-01-yellow.png",
  logo: "_extensions/omni_report/logo.png",
) = {
  page(
    footer: none,
    background: align(bottom)[
      #image(cover-pattern, width: 100%, height: 48%, fit: "stretch")
    ],
  )[
    #let date-str = "2026-08-01"
    #let parts = date-str.split("-").map(int)
    #let d = datetime(year: parts.at(0), month: parts.at(1), day: parts.at(2))
    #let display-date = d.display("[month repr:long] [year]")
    #grid(
      columns: (1fr, 1fr),
      align(left + top)[#image(logo, width: 110pt)],
      align(right + top)[
        #text(size: 10pt, tracking: 1pt, font: "Sometype Mono")[#upper[#display-date]]
      ],
    )
    #v(1.4in)
    #text(
      size: 10pt,
      fill: brand-color.at("primary"),
      tracking: 1pt,
    )[#organization-name Report]
    #v(0.8cm, weak: true)
    #heading(level: 1, outlined: false, text(size: 30pt, weight: "bold")[#par(
      leading: 0.5cm,
      title,
    )])
    #v(3.5em)
    #line(length: 40%, stroke: 1pt + brand-color.at("periwinkle-200"))
    #v(7mm, weak: true)
    #text(size: 14pt, weight: "bold", fill: brand-color.at("primary"))[#subtitle]
  ]
}


#let create-title-page(
  title: none,
  title-display: none,
  subtitle: none,
  organization-name: "Omni Institute",
  client-name: none,
  client-city: none,
  client-state: none,
  contact-email: "projects@omni.org",
  acknowledgements: none,
  report-year: none,
) = {
  let title-display = if title-display == none { title } else { title-display }
  page()[
    #show heading.where(level: 1): set text(size: 25.5pt)
    #show heading.where(level: 2): set text(size: 13pt, weight: "regular")
    #text(
      size: 10pt,
      fill: brand-color.at("secondary"),
      tracking: 1pt,
    )[#organization-name Report]
    #v(7mm, weak: true)
    #heading(level: 1, outlined: false, text(size: 25.5pt)[#par(leading: 0.5cm, title-display)])
    #v(0.3em)
    #heading(level: 2, outlined: false)[#subtitle]
    #v(1.5em)
    #if client-name != none {
      [Submitted to:]
      v(2pt)
      client-name
      v(1fr)
    } else {
      v(1fr)
    }
    #let title_size = 14pt
    #let spacing_after_section_title = 3mm
    #let spacing_after_section = 0.5em
    #text(size: title_size)[For More Information:]
    #v(spacing_after_section_title, weak: true)
    #link("mailto:" + contact-email)[#underline[#contact-email]]
    #v(spacing_after_section)

    #if acknowledgements != none {
      text(size: title_size)[Acknowledgements:]
      v(spacing_after_section_title, weak: true)
      text(
        size: 0.85em,
      )[#par[#organization-name wants to thank #acknowledgements for their contributions to the creation of this report.]]
      v(spacing_after_section)
    }

    #text(size: title_size)[Suggested Citation:]
    #v(spacing_after_section_title, weak: true)
    #let location = (client-city, client-state).filter(p => p != none).join(", ")
    #text(
      size: 0.85em,
    )[#par[#organization-name #report-year. #title. Submitted to #client-name, #location.]]
  ]
}


#let create-toc-page(
  title: none,
  organization-name: "Omni Institute",
  toc-title: none,
  toc-depth: none,
) = {
  show heading.where(level: 2): set text(size: 16pt, weight: "bold")

  page()[
    #show outline.entry: it => {
      if it.level == 2 {
        let padding_sections = 0.3cm
        v(padding_sections, weak: true)
        line(length: 100%, stroke: 0.5pt + brand-color.at("steel-blue-200"))
        v(padding_sections, weak: true)
        // Overwrite _brand.yml link color
        show link: set text(fill: brand-color.at("primary"))
        text(fill: brand-color.at("primary"), size: 13pt)[
          #link(it.element.location(), it.body()) #h(1fr) #it.page()
        ]
      } else {
        pad(left: 1cm)[
          #show link: set text(fill: brand-color.at("secondary"))
          #text(fill: brand-color.at("secondary"), size: 12pt)[
            #link(it.element.location(), it.body()) #h(1fr) #it.page()
          ]
        ]
      }
    }
    #heading(level: 2, outlined: false)[
      #if toc-title == none { [Table of Contents] } else { toc-title }
    ]
    #v(1em)
    #outline(title: none, depth: toc-depth)
  ]
}

#let create-page-break(
  title: none,
  pattern: "_extensions/omni_report/pattern-01-yellow.png",
) = {
  page(
    background: image(pattern, width: 100%, height: 100%, fit: "cover"),
    footer: context {
      let info = footer-info-state.get()
      create-document-footer(
        title: info.title,
        organization-name: info.organization-name,
        page-numbering: info.page-numbering,
        logo: "_extensions/omni_report/logo-no-text-transparent.png",
        inverted: true,
        with-line: false,
      )
    },
  )[
    #set text(fill: white, size: 22pt)
    #show heading: set text(fill: white)
    #v(5fr)
    #heading(level: 1, outlined: false, title)
    #v(0.75fr)
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

