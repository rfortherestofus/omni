
// Typst custom formats typically consist of a 'typst-template.typ' (which is
// the source code for a typst template) and a 'typst-show.typ' which calls the
// template's function (forwarding Pandoc metadata values as required)
//
// This is an example 'typst-show.typ' file (based on the default template  
// that ships with Quarto). It calls the typst function named 'article' which 
// is defined in the 'typst-template.typ' file. 
//
// If you are creating or packaging a custom typst template you will likely
// want to replace this file and 'typst-template.typ' entirely. You can find
// documentation on creating typst templates here and some examples here:
//   - https://typst.app/docs/tutorial/making-a-template/
//   - https://github.com/typst/templates
#show: doc => article(
$if(title)$
  title: [$title$],
$endif$
$if(subtitle)$
  subtitle: [$subtitle$],
$endif$
$if(by-author)$
  authors: (
$for(by-author)$
$if(it.name.literal)$
    ( name: [$it.name.literal$],
      affiliation: [$for(it.affiliations)$$it.name$$sep$, $endfor$],
      email: [$it.email$] ),
$endif$
$endfor$
    ),
$endif$
$if(date)$
  date: [$date$],
$endif$
$if(lang)$
  lang: "$lang$",
$endif$
$if(region)$
  region: "$region$",
$endif$
$if(abstract)$
  abstract: [$abstract$],
  abstract-title: "$labels.abstract$",
$endif$
$if(margin)$
  margin: ($for(margin/pairs)$$margin.key$: $margin.value$,$endfor$),
$endif$
$if(papersize)$
  paper: "$papersize$",
$endif$
$if(mainfont)$
  font: ("$mainfont$",),
$elseif(brand.typography.base.family)$
  font: $brand.typography.base.family$,
$endif$
$if(fontsize)$
  fontsize: $fontsize$,
$elseif(brand.typography.base.size)$
  fontsize: $brand.typography.base.size$,
$endif$
$if(title)$
$if(brand.typography.headings.family)$
  heading-family: $brand.typography.headings.family$,
$endif$
$if(brand.typography.headings.weight)$
  heading-weight: $brand.typography.headings.weight$,
$endif$
$if(brand.typography.headings.style)$
  heading-style: "$brand.typography.headings.style$",
$endif$
$if(brand.typography.headings.decoration)$
  heading-decoration: "$brand.typography.headings.decoration$",
$endif$
$if(brand.typography.headings.color)$
  heading-color: $brand.typography.headings.color$,
$endif$
$if(brand.typography.headings.line-height)$
  heading-line-height: $brand.typography.headings.line-height$,
$endif$
$endif$
$if(brand.typography.link.color)$
  link-color: $brand.typography.link.color$,
$endif$
$if(section-numbering)$
  section-numbering: "$section-numbering$",
$endif$
  page-numbering: $if(page-numbering)$"$page-numbering$"$else$none$endif$,
$if(toc)$
  toc: $toc$,
$endif$
$if(toc-title)$
  toc-title: [$toc-title$],
$endif$
$if(toc-indent)$
  toc-indent: $toc-indent$,
$endif$
  toc-depth: $toc-depth$,
  cols: $if(columns)$$columns$$else$1$endif$,
  cover-page: $if(cover-page)$$cover-page$$else$false$endif$,
  title-page: $if(title-page)$$title-page$$else$false$endif$,
$if(organization-name)$
  organization-name: $organization-name$,
$endif$
$if(cover-pattern)$
  cover-pattern: "_extensions/omni_report/" + $cover-pattern$ + ".png",
$endif$
$if(client-name)$
  client-name: [$client-name$],
$endif$
$if(client-city)$
  client-city: [$client-city$],
$endif$
$if(client-state)$
  client-state: [$client-state$],
$endif$
$if(contact-email)$
  contact-email: $contact-email$,
$endif$
$if(acknowledgements)$
  acknowledgements: [$acknowledgements$],
$endif$
$if(report-year)$
  report-year: [$report-year$],
$endif$
$if(start-page-number)$
  start-page-number: $start-page-number$,
$endif$
  doc,
)
