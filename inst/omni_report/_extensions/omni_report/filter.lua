local brand = require('modules/brand/brand')

-- Renders inline content as Typst, preserving any nested formatting
-- (bold, italic, other spans, etc.)
local function inlines_to_typst(inlines)
  local typst = pandoc.write(
    pandoc.Pandoc({ pandoc.Plain(inlines) }),
    "typst"
  )
  -- Strip the trailing newline pandoc.write adds
  return typst:gsub("%s+$", "")
end


function Span(el)
  if not quarto.doc.is_format("typst") then
    return el
  end

  for _, class in ipairs(el.classes) do
    local color = brand.get_color("light", class)
    if color then
      return pandoc.RawInline(
        "typst",
        '#text(fill: ' .. color .. ')[' .. inlines_to_typst(el.content) .. ']'
      )
    end
  end

  return el
end

-- Patterns available for the colored divider pages. The class name doubles as
-- the image file name, e.g. `# Findings {.pattern-01-yellow}` renders
-- pattern-01-yellow.png.
local page_break_patterns = {
  ["pattern-01-yellow"]     = true,
  ["pattern-02-teal"]       = true,
  ["pattern-03-orangered"]  = true,
  ["pattern-06-teal"]       = true,
  ["pattern-07-periwinkle"] = true,
  ["pattern-07-olive"]      = true,
  ["pattern-08-plum"]       = true,
}

local extension_dir = "_extensions/omni_report/"

local function get_class_if_page_break(el)
  for _, class in ipairs(el.classes) do
    if page_break_patterns[class] then
      return class
    end
  end
  return nil
end

local appendix_header_inserted = false

function Header(el)
  if quarto.doc.is_format("html") and el.level == 1 then
    return {}
  end
  if not quarto.doc.is_format("typst") then
    return el
  end

  -- The appendix banner brings its own (weak) page break, so the first appendix
  -- heading must not also get the generic one below -- that would push the
  -- banner onto the page before its heading. Later appendix headings are
  -- ordinary sections and fall through to the page break rule.
  if el.classes:includes("appendix") and not appendix_header_inserted then
    appendix_header_inserted = true
    return {
      pandoc.RawBlock("typst", "#create-appendix-header()"),
      el,
    }
  end

  -- Page breaks on Level 1 headings
  local pattern = get_class_if_page_break(el)
  if el.level == 1 and pattern then
    return pandoc.RawBlock(
      "typst",
      '#create-page-break(title: [' .. inlines_to_typst(el.content) ..
      '], pattern: "' .. extension_dir .. pattern .. '.png")'
    )
  end

  -- Sections start on a fresh page.
  if el.level <= 2 then
    return {
      pandoc.RawBlock("typst", "#pagebreak(weak: true)"),
      el,
    }
  end

  return el
end

function Div(el)
  if not quarto.doc.is_format("typst") then
    return el
  end

  if not el.classes:includes("columns") then
    return el
  end

  local widths = {}
  local bodies = {}
  local gutter = el.attributes["column-gap"] or "4%"

  for _, block in ipairs(el.content) do
    if block.t == "Div" and block.classes:includes("column") then
      local width = block.attributes["width"] or "1fr"
      -- Pandoc column widths ("55%") are meant as proportions of the row,
      -- not literal percentages of the page: passed through as Typst `%`
      -- they're sized against the full container *before* `gutter` is
      -- subtracted, so percentages (which already sum to ~100% across
      -- columns) plus the gutter on top overflow past 100% and push later
      -- columns off the page. Typst `fr` tracks are sized *after* gutter is
      -- subtracted and distributed by ratio, which is what "55%, 5%, 40%"
      -- actually intends -- so convert the percentage to an equivalent fr.
      local pct = width:match("^([%d.]+)%%$")
      if pct then
        width = pct .. "fr"
      end
      table.insert(widths, width)
      -- render inner content as Typst, preserving all formatting
      local inner = pandoc.write(pandoc.Pandoc(block.content), "typst")
      table.insert(bodies, "[" .. inner:gsub("%s+$", "") .. "]")
    end
  end

  if #widths == 0 then return el end

  local typst = string.format(
    "#grid(\n  columns: (%s),\n  gutter: %s,\n  %s\n)",
    table.concat(widths, ", "),
    gutter,
    table.concat(bodies, ",\n  ")
  )

  return pandoc.RawBlock("typst", typst)
end

-- The logos that ship with the extension, named without a directory, mapped to
-- the height each one needs: the Omni wordmark is a single line, the CSI
-- lockup two. Client logos we know nothing about get the fallback.
local shipped_logos = {
  ["logo.png"]     = "30px",
  ["logo-csi.png"] = "62px",
}
local fallback_logo_height = "50px"

-- Pass through as plain text so that Typst doesn't escape eg. @ in the email
-- Necessary since some fields like acknowledgement accept Markdown
local plain_text_yml_headers = {
  "cover-pattern",
  "organization-name",
  "contact-email",
}

function Meta(meta)
  if quarto.doc.is_format("typst") then
    for _, key in ipairs(plain_text_yml_headers) do
      if meta[key] then
        local value = pandoc.utils.stringify(meta[key])
        meta[key] = pandoc.MetaInlines({
          pandoc.RawInline("typst", '"' .. value .. '"'),
        })
      end
    end
  end

  if not quarto.doc.is_format("html") then
    return meta
  end

  local logo = pandoc.utils.stringify(meta["logo-ref"] or "")
  local file = logo:match("[^/\\]+$") or ""

  -- A bare shipped logo name is looked up in the extension; anything else is a
  -- path relative to the qmd and is left exactly as written.
  if shipped_logos[logo] then
    meta["logo-ref"] = pandoc.MetaString(extension_dir .. logo)
  end

  -- `logo-height: default` sizes the logo for us; an explicit length wins.
  local height = pandoc.utils.stringify(meta["logo-height"] or "")
  if height == "" or height == "default" then
    meta["logo-height"] = pandoc.MetaString(
      shipped_logos[file] or fallback_logo_height
    )
  end

  return meta
end

-- Build page footer with Lua as include-after-body does not insert into <main>.
-- Thus content would be full page width instead of <main> width.
local function build_footer_html(meta)
  local logo = pandoc.utils.stringify(meta["logo-ref"] or "")
  local organization_name = pandoc.utils.stringify(meta["organization-name"] or "")
  local contact_email = pandoc.utils.stringify(meta["contact-email"] or "")
  local year = os.date("%Y")

  local contact_line = ""
  if contact_email ~= "" then
    contact_line = '\n<p>Contact: <a href="mailto:' .. contact_email .. '">' ..
        contact_email .. '</a></p>'
  end

  return table.concat({
    '<div class="omni-footer">',
    '<img class="omni-footer-logo" src="' .. logo ..
    '" alt="' .. organization_name .. ' logo" />',
    '<div class="omni-footer-text">',
    '<p>&copy; ' .. year .. ' ' .. organization_name .. '</p>' .. contact_line,
    '</div>',
    '</div>',
  }, "\n")
end

function Pandoc(doc)
  if quarto.doc.is_format("html") then
    doc.blocks:insert(pandoc.RawBlock("html", build_footer_html(doc.meta)))
  end

  return doc
end
