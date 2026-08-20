
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
  margin: (x: 0.6in, top: 1.1in, bottom: 1.4in),
  paper: "us-letter",
  lang: "en",
  region: "US",
  font: "libertinus serif",
  fontsize: 11pt,
  title-size: 1.5em,
  subtitle-size: 1.25em,
  heading-family: "libertinus serif",
  heading-weight: "plain",
  heading-style: "normal",
  heading-color: black,
  heading-line-height: 0.65em,
  section-numbering: none,
  page-numbering: "1",
  toc: false,
  toc-title: none,
  toc-depth: none,
  toc-indent: 1.5em,
  cover-page: true,
  title-page: true,
  organization-name: "Omni Institute",
  cover-pattern: "_extensions/omni_report/pattern-cover-01-yellow.png",
  client-name: none,
  client-city: none,
  client-state: none,
  contact-email: "projects@omni.org",
  acknowledgements: none,
  report-year: none,
  start-page-number: 1,
  doc,
) = {
  set page(
    paper: paper,
    margin: margin,
    footer-descent: 10% + 0pt,
    footer: create-document-footer(
      title: title,
      organization-name: organization-name,
      page-numbering: page-numbering,
    ),
  )

  // update page counter, has no effects when start-page-number is 1
  counter(page).update(n => n + start-page-number - 1)
  appendix-margin-state.update(margin)
  footer-info-state.update((
    title: title,
    organization-name: organization-name,
    page-numbering: page-numbering,
  ))
  set par(justify: true)
  set text(lang: lang, region: region, font: font, size: fontsize)
  set heading(numbering: section-numbering)
  set footnote.entry(gap: 0.8em, indent: 0em)

  if cover-page {
    create-cover-page(
      title: title,
      subtitle: subtitle,
      date: date,
      organization-name: organization-name,
      cover-pattern: cover-pattern,
    )
  }

  if title-page {
    create-title-page(
      title: title,
      subtitle: subtitle,
      organization-name: organization-name,
      client-name: client-name,
      client-city: client-city,
      client-state: client-state,
      contact-email: contact-email,
      acknowledgements: acknowledgements,
      report-year: report-year,
    )
  }

  if toc {
    create-toc-page(
      title: title,
      organization-name: organization-name,
      toc-title: toc-title,
      toc-depth: toc-depth,
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
