# Omni_pdf_report Format

### Page breaks

In the PDF (Typst) output, every level 1 and level 2 heading starts on a new
page. A level 1 heading can additionally be turned into a full-page colored
divider by tagging it with one of the pattern classes:

```markdown
# Key Findings {.pattern-01-yellow}

## First section

# Recommendations {.pattern-08-plum}
```

The pattern image covers the whole sheet, margins included, and the heading
appears in white in the lower third of the page. Available patterns:

- `.pattern-01-yellow`
- `.pattern-02-teal`
- `.pattern-03-orangered`
- `.pattern-06-teal`
- `.pattern-07-periwinkle`
- `.pattern-07-olive`
- `.pattern-08-plum`

A level 1 heading without a pattern class simply starts a new page. The classes
have no effect on HTML output.

### Frontmatter pages (PDF)

The PDF (Typst) output can open with up to three frontmatter pages, each
toggled independently. Page numbering in the body always starts at "1"
regardless of which subset is shown:

```yaml
format:
  omni_report-typst:
    cover-page: true
    title-page: true
    toc: true
```

| Option              | Meaning                                                              | Default                   |
| ------------------- | -------------------------------------------------------------------- | ------------------------- |
| `cover-page`        | Show the cover (logo, date, title, colored pattern)                  | `false` unless set        |
| `title-page`        | Show the title page (submitted-to, acknowledgements, citation)       | `false` unless set        |
| `toc`               | Show the table of contents                                           | `false` unless set        |
| `cover-pattern`     | Which pattern covers the bottom of the cover page                    | `pattern-cover-01-yellow` |
| `organization-name` | Category label on the cover/title pages and the running footer       | `Omni Institute`          |
| `client-name`       | "Submitted to:" value on the title page                              | none                      |
| `client-state`      | State used in the suggested citation                                 | none                      |
| `contact-email`     | "For More Information:" mailto link                                  | `projects@omni.org`       |
| `acknowledgements`  | Names thanked on the title page (supports markdown, e.g. `**bold**`) | none                      |
| `report-year`       | Year used in the suggested citation                                  | none                      |

`cover-pattern` accepts the same seven colors as the page-break patterns
above, with a `pattern-cover-` prefix instead of `pattern-`:

- `pattern-cover-01-yellow`
- `pattern-cover-02-teal`
- `pattern-cover-03-orangered`
- `pattern-cover-06-teal`
- `pattern-cover-07-periwinkle`
- `pattern-cover-07-olive`
- `pattern-cover-08-plum`

`date` is shown verbatim on the cover page (no reformatting happens in
Typst), so format it the way it should appear, e.g.:

```yaml
date: "`r toupper(format(Sys.Date(), '%B %Y'))`"
```

A running footer (small logo, "{organization-name} Report | {title}", page
number) appears on every page except the cover, whose pattern already fills
that space.

### Logo (PDF)

`logo-ref` and `logo-height` size the logo on the cover page; `logo-footer-height` sizes the small logo in the running footer. All three are optional and, when set, take precedence over the CSI/Omni default computed from `use-csi-style`:

```yaml
format:
  omni_report-typst:
    logo-ref: images/client-logo.png
    logo-height: 40pt
    logo-footer-height: 1cm
```

A bare `logo.png`/`logo-csi.png` (the two logos that ship with the extension) resolves within the extension; any other value is a path relative to `template.qmd`. `logo-height` and `logo-footer-height` are Typst lengths (e.g. `40pt`, `1cm`).

### HTML header bar

The HTML output opens with a header bar that shows a logo on the left and an
organization name on the right. Three options of the `omni_report-html` format
control it; their shipped defaults live in the extension's `_extension.yml`:

| Option              | Meaning                                                   |
| ------------------- | --------------------------------------------------------- |
| `logo-ref`          | `logo.png`, `logo-csi.png`, or a path relative to the qmd |
| `organization-name` | Text on the right of the bar                              |
| `logo-height`       | Any CSS length, or `default`                              |

Overriding one of them leaves the others alone, so a report that only switches
the logo keeps the default name and height:

```yaml
format:
  omni_report-html:
    logo-ref: logo-csi.png
    organization-name: "Center for Social Investment"
```

`logo.png` and `logo-csi.png` are the two logos that ship with the extension —
name them on their own and they are found there, no directory needed. Any other
value is a path resolved from the qmd's own directory, e.g.
`logo-ref: images/client-logo.png`.

The logo is sized by height alone, and the two shipped logos need different
values: the Omni wordmark is one line, the CSI lockup two. With
`logo-height: default`, `filter.lua` picks the height from the logo file:

| Logo           | Height |
| -------------- | ------ |
| `logo.png`     | 30px   |
| `logo-csi.png` | 62px   |
| anything else  | 50px   |

Setting `logo-height` to a CSS length (`logo-height: 44px`) overrides this for
any logo.

The footer logo (shown at the bottom of every page) is sized separately via `logo-footer-height`, any CSS length. It's optional; when unset the footer logo keeps its default height (twice the header's when `use-csi-style` is `true`, unchanged otherwise):

```yaml
format:
  omni_report-html:
    logo-footer-height: 50px
```
