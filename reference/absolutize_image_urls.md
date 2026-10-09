# Make a stylesheet's relative image references resolve from anywhere

The package's CSS references its images with a path relative to its own
location (e.g. \`url("images/logo.png")\`). Once the stylesheet has been
copied out to a \`tempfile()\` (see \[isolate_css_for_render()\]), that
relative path no longer resolves, since the images don't live next to
it. Rewrite it to an absolute path to the package's real \`images/\`
directory instead.

## Usage

``` r
absolutize_image_urls(file)
```

## Arguments

- file:

  CSS file path (already a private, per-render file)
