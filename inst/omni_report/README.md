# Omni_pdf_report Format

## Installing

_TODO_: Replace the `<github-organization>` with your GitHub organization.

```bash
quarto use template <github-organization>/omni_pdf_report
```

This will install the format extension and create an example qmd file
that you can use as a starting place for your document.

## Using

_TODO_: Describe how to use your format.

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

### HTML header bar

The HTML output opens with a header bar that shows a logo on the left and an
organization name on the right. Three options of the `omni_report-html` format
control it; their shipped defaults live in the extension's `_extension.yml`:

| Option | Meaning |
| --- | --- |
| `logo-ref` | `logo.png`, `logo-csi.png`, or a path relative to the qmd |
| `organization-name` | Text on the right of the bar |
| `logo-height` | Any CSS length, or `default` |

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

| Logo | Height |
| --- | --- |
| `logo.png` | 30px |
| `logo-csi.png` | 62px |
| anything else | 50px |

Setting `logo-height` to a CSS length (`logo-height: 44px`) overrides this for
any logo.

