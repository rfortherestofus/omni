
// This is an example typst template (based on the default template that ships
// with Quarto). It defines a typst function named 'article' which provides
// various customization options. This function is called from the
// 'typst-show.typ' file (which maps Pandoc metadata function arguments)
//
// If you are creating or packaging a custom typst template you will likely
// want to replace this file and 'typst-show.typ' entirely. You can find
// documentation on creating typst templates and some examples here:
//   - https://typst.app/docs/tutorial/making-a-template/
//   - https://github.com/typst/templates

#let article(
  title: none,
  subtitle: none,
  authors: none,
  date: none,
  abstract: none,
  abstract-title: none,
  cols: 1,
  margin: (x: 1in, y: 1in),
  paper: "us-letter",
  lang: "en",
  region: "US",
  font: "libertinus serif",
  fontsize: 11pt,
  title-size: 1.5em,
  subtitle-size: 1.25em,
  heading-family: "libertinus serif",
  heading-weight: "bold",
  heading-style: "normal",
  heading-color: black,
  heading-line-height: 0.65em,
  sectionnumbering: none,
  pagenumbering: "1",
  toc: false,
  toc_title: none,
  toc_depth: none,
  toc_indent: 1.5em,
  cover-page: true,
  title-page: true,
  organization_name: "Omni Institute",
  cover_pattern: "_extensions/omni_report/pattern-cover-01-yellow.png",
  client_name: none,
  client_city: none,
  client_state: none,
  contact_email: "projects@omni.org",
  acknowledgements: none,
  report_year: none,
  doc,
) = {
  set page(
    paper: paper,
    margin: margin,
    footer: create-document-footer(
      title: title,
      organization_name: organization_name,
      pagenumbering: pagenumbering,
    ),
  )
  appendix-margin-state.update(margin)
  set par(justify: true)
  set text(lang: lang, region: region, font: font, size: fontsize)
  set heading(numbering: sectionnumbering)

  if cover-page {
    create-cover-page(
      title: title,
      subtitle: subtitle,
      date: date,
      organization_name: organization_name,
      cover_pattern: cover_pattern,
    )
  }

  if title-page {
    create-title-page(
      title: title,
      subtitle: subtitle,
      organization_name: organization_name,
      client_name: client_name,
      client_city: client_city,
      client_state: client_state,
      contact_email: contact_email,
      acknowledgements: acknowledgements,
      report_year: report_year,
    )
  }

  if toc {
    create-toc-page(
      title: title,
      organization_name: organization_name,
      toc_title: toc_title,
      toc_depth: toc_depth,
      toc_indent: toc_indent,
    )
  }

  if cols == 1 {
    doc
  } else {
    columns(cols, doc)
  }
}

#set table(
  inset: 6pt,
  stroke: none,
)
