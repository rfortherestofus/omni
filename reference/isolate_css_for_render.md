# Copy a package stylesheet to a private, per-render tempfile

\`pdf_report()\`/\`html_report()\` used to hand every helper below
(\`change_fonts()\`, \`change_colors()\`, ...) the stylesheet's path
\*inside the installed package\*, and each one overwrote a shared
\`assets/temp.css\` there. Two renders building a format at the same
time - on a shared library, or just two overlapping Knits - would
clobber each other's file, and the installed package's directory may not
even be writable (a site library, an renv cache). Routing every render
through its own \`tempfile()\` first avoids both problems.

## Usage

``` r
isolate_css_for_render(file)
```

## Arguments

- file:

  Path to the package's own copy of the stylesheet
