# Agent Project Context

You are an expert developer assisting with this project.
Strictly adhere to the following technical standards and coding conventions defined below.
If instructions conflict with these rules, prioritize these rules unless explicitly overridden.

---

General coding rules to follow for the R programming language:

- Always use the tidyverse (dplyr, ggplot2, tibble...) unless explicitly asked not to.
- Always add a `library(<pkg_name>)` at the top of the file.
- Always use the native pipe operator: |>.
- For less common packages, give installation instructions using `pak`: `pak::pkg_install()`.
- Make the code as consistent as possible
- Avoid as much as reasonnable code dupplications
- Warn users when code would benefit from a refactoring, without blocking them.
- Always use the `<-` operator when assigning a variable/functions.
- Never use absolute paths nor use `setwd()`. Use `here::here()` instead.

R package development coding rules:

- Always document code using roxygen2 tags and separe tag sections with a linebreak. Avoid too long lines.
- Use `devtools::load_all()` to load latest package functions
- Document functions with `devtools::document()` for documenting functions
- Never use `library(<pkg_name>)` but rather the `@import` and `@importFrom` tag. Also update dependencies with `usethis::use_package(<pkg_name>)`.
- Never use `library(<pkg_name>)` in unit tests.
