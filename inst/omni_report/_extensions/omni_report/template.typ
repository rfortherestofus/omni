$pages.typ()$

$design_elements.typ()$

$if(highlighting-definitions)$
// syntax highlighting functions from skylighting:
$highlighting-definitions$

$endif$

$typst-template.typ()$

$for(header-includes)$
$header-includes$
$endfor$


$typst-show.typ()$

$for(include-before)$
$include-before$
$endfor$

$body$

$for(include-after)$
$include-after$
$endfor$
