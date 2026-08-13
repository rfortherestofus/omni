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

