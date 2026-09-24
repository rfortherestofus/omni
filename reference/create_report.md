# Create a new Omni report

\`create_report()\` creates a new directory with a pre-defined Quarto
report document based on Omni branding. The \`template.qmd\` front
matter lists both output formats (\`omni_report-html\` and
\`omni_report-typst\` for PDF). Remove the one you do not need.

## Usage

``` r
create_report(output_dir)
```

## Arguments

- output_dir:

  New directory that will contain the Quarto report files.

## Value

The path to the created \`template.qmd\`, invisibly. In an interactive
session the file is also opened for editing.
