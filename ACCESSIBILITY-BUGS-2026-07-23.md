# Accessibility bugs found via `accessibility-scan` (axe-core), 2026-07-23

Found while rebuilding a real deliverable (`nonprofit-ma-funder-pitch-2026-v2`) through `omni::html_report()` exactly as documented. None of these are content-authoring mistakes — every one reproduces with the functions used per their own documented signatures. Filed here rather than just described in chat since you maintain the package directly and asked to fix them.

**Status (2026-07-24): all 5 fixed and verified.** Confirmed via a fresh test render (`devtools::load_all()` + `rmarkdown::render()`) scanned with `accessibility-scan` — clean, 0 violations. See the fix notes under each item below; #3–5 needed a different approach than originally guessed (not `formats.R`/the header template alone — see #3–5's updated notes).

---

## 1. `number_emphasis()` — text label has no explicit color, fails contrast on every 600-level background

**File:** `R/design_elements.R`, the label `htmltools::div()` around lines 364–379.

```r
htmltools::div(
  style = htmltools::css(
    background = color_hex,
    height = '80%',
    font_size = '12pt',
    margin_top = 'auto',
    margin_bottom = 'auto',
    margin_left = '-30px',
    padding_left = '55px',
    padding_right = '10px',
    padding_top = '2px',
    padding_bottom = '2px',
    z_index = 0
  ),
  text
)
```

This div sets `background = color_hex` (whichever 600-level color the caller passed) but never sets a text `color` — it silently inherits the browser/bootstrap default (renders as `#333333`), which fails AA contrast (2.6–2.8 measured, need 4.5) against every 600-level color tested (periwinkle-600, orange-red-600, teal-600). The first div in the same function (the number-in-circle) does set an explicit color (`color = 'black'` on a white background, lines 344–346) — this second div is missing the equivalent.

**Fix:** add `color = 'white'` to this `htmltools::css(...)` call, matching how the circle div and `quote_box()`/`callout_box()` already put white text on 600-level backgrounds.

**Fixed 2026-07-24:** `color = 'white'` added to the label div (`R/design_elements.R`, the div right after the circle div).

**Repro:** `number_emphasis(number = "34,000+", text = "Nonprofits operating in Colorado.", color = "periwinkle-600")`, scan the rendered output with axe-core.

---

## 2. `quote_box()` `<highlight>` tag — 200-on-600 same-family pairing doesn't reliably clear AA contrast

**File:** `R/design_elements.R`, lines ~68–78.

```r
color_hex_highlight <- allowed_colors[
  color |> stringr::str_replace('600', '200')
]
...
glue::glue(
  '<span style="color:{color_hex_highlight}; background: {color_hex} !important;">'
)
```

The `<highlight>` mechanism puts the "200" tint of a color family as text on top of the "600" shade of the *same* family as background. For periwinkle this measures 3.3:1 (need 4.5:1) — confirmed via axe-core, not assumed. The assumption that "200 is light enough against 600" doesn't hold for every family; it needs checking per-family (periwinkle, teal, plum, olive-green, orange-red) rather than treated as a single universal rule.

**Fix:** either use a fixed lighter value that's verified to clear 4.5:1 against every 600 background (not necessarily each family's own "200"), or verify each family's actual 200-on-600 contrast individually and drop `<highlight>` support for any family that fails.

**Fixed 2026-07-24, differently than proposed above:** rather than chase per-family tint contrast, `<highlight>` now applies `font-weight: 700; text-decoration: underline;` with no color change at all, so it inherits the quote's own already-established white-on-600 contrast instead of introducing a new color pairing to verify.

**Repro:** `quote_box(text = "... <highlight>text</highlight> ...", color = "periwinkle-600")`, scan with axe-core.

---

## 3–5. `omni::html_report()` output format — three structural issues baked into every report

Reproduces on every Report-mode document, including a fresh, minimal one, not just this deliverable:

3. **No `lang` attribute on `<html>`.** Every rendered report fails `html-has-lang`.
4. **No `<main>` landmark.** All body content trips `landmark-one-main` / `region` — nothing in the rendered page is wrapped in a semantic landmark.
5. **Heading order skips a level.** The auto-generated title/subtitle renders H1 then H3, skipping H2 (`heading-order` violation).

**Fixed 2026-07-24 — actual source located and fixed, each needed a different mechanism than originally guessed:**

3. `R/formats.R`, the `bookdown::html_document2(...)` call in `html_report()`: added `pandoc_args = c("--metadata", "lang=en")`. `formats.R` itself was the right file, just needed a pandoc metadata flag, not a template edit.
4. `inst/assets/header-htmlreport.html` (and the CSI variant): added `<header>...</header><main>` after the logo/title block. `inst/assets/footer-htmlreport.html` (and CSI variant): added `</main>` before the `<footer>` block. These two files are the `before_body`/`after_body` includes `formats.R` already wires up, so `<main>` now wraps everything Pandoc renders in between.
5. **Not fixable in `formats.R` or the header/footer files at all** — the subtitle's `<h3 class="subtitle">` comes from rmarkdown's own bundled Pandoc HTML template (`rmarkdown/rmd/h/default.html`, a template variable substitution, not part of the document's heading AST), so a Lua filter can't reach it and there's no omni-owned file to edit. Fixed instead with a small DOM-fixup `<script>` added to both footer includes: finds `h3.subtitle` and replaces it with an equivalent `h2` after the page loads. Confirmed this is what axe-core actually scans (the live DOM), so the fix holds even though "view source" would still show the h3.

**Verified:** test render via `devtools::load_all()` + `rmarkdown::render()`, scanned with `accessibility-scan` — 0 violations.

---

**Verification note:** all five were caught by the new `accessibility-scan` skill (`.claude/skills/accessibility-scan/` at the Claude-tools workspace root) run against real rendered output, not by manual inspection. Re-running that skill against a fixed build is the fast way to confirm each fix actually resolves its violation.
