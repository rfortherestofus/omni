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

  -- Later appendix headings (2nd, 3rd, ...) don't fall under the level == 1
  -- rule below, since they're level 2 -- but each one still needs its own
  -- fresh page like the first did (which gets it from the banner above).
  if el.classes:includes("appendix") then
    return {
      pandoc.RawBlock("typst", "#pagebreak(weak: true)"),
      el,
    }
  end

  -- Section breaks (level 1) start on a fresh page. Level 2 ("h1" body
  -- headings) flow naturally with surrounding content.
  if el.level == 1 then
    return {
      pandoc.RawBlock("typst", "#pagebreak(weak: true)"),
      el,
    }
  end

  return el
end

-- brand-color keys for the 7 hues x 3 shades used by the opt-in chapter-dot
-- element (see design_elements.typ). A bare "dot-<hue>" (no shade) defaults
-- to the -600 (darkest) shade, matching the legacy pdf_report.css default.
-- The three deprecated aliases from that stylesheet are kept for parity with
-- content ported from the old Rmd template.
local chapter_dot_colors = {
  ["dot-plum"] = "plum-600",
  ["dot-plum-200"] = "plum-200",
  ["dot-plum-400"] = "plum-400",
  ["dot-plum-600"] = "plum-600",
  ["dot-orange-red"] = "orange-red-600",
  ["dot-orange-red-200"] = "orange-red-200",
  ["dot-orange-red-400"] = "orange-red-400",
  ["dot-orange-red-600"] = "orange-red-600",
  ["dot-olive-green"] = "olive-green-600",
  ["dot-olive-green-200"] = "olive-green-200",
  ["dot-olive-green-400"] = "olive-green-400",
  ["dot-olive-green-600"] = "olive-green-600",
  ["dot-teal"] = "teal-600",
  ["dot-teal-200"] = "teal-200",
  ["dot-teal-400"] = "teal-400",
  ["dot-teal-600"] = "teal-600",
  ["dot-golden-yellow"] = "golden-yellow-600",
  ["dot-golden-yellow-200"] = "golden-yellow-200",
  ["dot-golden-yellow-400"] = "golden-yellow-400",
  ["dot-golden-yellow-600"] = "golden-yellow-600",
  ["dot-periwinkle"] = "periwinkle-600",
  ["dot-periwinkle-200"] = "periwinkle-200",
  ["dot-periwinkle-400"] = "periwinkle-400",
  ["dot-periwinkle-600"] = "periwinkle-600",
  ["dot-steel-blue"] = "steel-blue-600",
  ["dot-steel-blue-200"] = "steel-blue-200",
  ["dot-steel-blue-400"] = "steel-blue-400",
  ["dot-steel-blue-600"] = "steel-blue-600",
  -- deprecated legacy aliases (pdf_report.css backward-compat classes)
  ["dot-purple"] = "plum-600",
  ["dot-green"] = "olive-green-600",
  ["dot-red"] = "orange-red-600",
}

function Div(el)
  if not quarto.doc.is_format("typst") then
    return el
  end

  if el.classes:includes("chapter-dot") then
    local brand_key = "primary"
    for _, class in ipairs(el.classes) do
      if chapter_dot_colors[class] then
        brand_key = chapter_dot_colors[class]
      end
    end
    local inner = pandoc.write(pandoc.Pandoc(el.content), "typst"):gsub("%s+$", "")
    return pandoc.RawBlock(
      "typst",
      '#chapter-dot(body: [' .. inner .. '], color: brand-color.at("' .. brand_key .. '"))'
    )
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

-- `use-csi-style` is the source of truth for CSI (Center for Social Investment) branding
local function is_true(value)
  if type(value) == "boolean" then
    return value
  end
  return value ~= nil and pandoc.utils.stringify(value) == "true"
end

-- Logos that ship inside the extension
local shipped_logos = {
  ["logo.png"] = true,
  ["logo-csi.png"] = true,
  ["logo-no-text.png"] = true,
  ["logo-no-text-csi.png"] = true,
  ["logo-no-text-transparent.png"] = true,
}

local function resolve_logo_path(value)
  if shipped_logos[value] then
    return extension_dir .. value
  end
  return value
end

local default_logo_heights = {
  ["logo.png"] = "30px",
  ["logo-csi.png"] = "62px",
}

local function resolve_logo_height(value, resolved_logo_ref)
  if value and value ~= "default" then
    return value
  end
  local basename = resolved_logo_ref:match("([^/]+)$")
  return default_logo_heights[basename] or "50px"
end

-- Pass through as plain text so that Typst doesn't escape eg. @ in the email
-- Necessary since some fields like acknowledgement accept Markdown
local plain_text_yml_headers = {
  "cover-pattern",
  "organization-name",
  "contact-email",
  "logo-ref",
  "logo-icon-ref",
  "title",
  "subtitle"
}

-- Quarto/Pandoc already parses raw HTML like <br> in a metadata field into a
-- RawInline before this filter runs, so stringify() would silently drop it.
local function is_br(el)
  return el.t == "RawInline" and el.format == "html"
      and el.text:match("^%s*<%s*[Bb][Rr]%s*/?%s*>%s*$")
end

function Meta(meta)
  local use_csi_style = is_true(meta["use-csi-style"])
  local organization_name = use_csi_style
      and "Center for Social Investment"
      or "Omni Institute"

  if not meta["organization-name"] then
    meta["organization-name"] = pandoc.MetaString(organization_name)
  end

  if quarto.doc.is_format("typst") then
    local logo_ref_input = meta["logo-ref"] and pandoc.utils.stringify(meta["logo-ref"])
    meta["logo-ref"] = pandoc.MetaString(
      logo_ref_input and resolve_logo_path(logo_ref_input)
      or (extension_dir .. (use_csi_style and "logo-csi.png" or "logo.png"))
    )

    local icon_for_logo = {
      ["logo.png"] = "logo-no-text.png",
      ["logo-csi.png"] = "logo-no-text-csi.png",
    }
    local logo_icon_ref_input = meta["logo-icon-ref"] and pandoc.utils.stringify(meta["logo-icon-ref"])
    meta["logo-icon-ref"] = pandoc.MetaString(
      (logo_icon_ref_input and resolve_logo_path(logo_icon_ref_input))
      or (logo_ref_input and icon_for_logo[logo_ref_input] and extension_dir .. icon_for_logo[logo_ref_input])
      or (logo_ref_input and resolve_logo_path(logo_ref_input))
      or extension_dir .. (use_csi_style and "logo-no-text-csi.png" or "logo-no-text.png")
    )
    -- Stored as raw Typst code (no quotes) since it's a length
    if meta["logo-height"] then
      meta["logo-height"] = pandoc.MetaInlines({
        pandoc.RawInline("typst", pandoc.utils.stringify(meta["logo-height"])),
      })
    else
      meta["logo-height"] = pandoc.MetaInlines({
        pandoc.RawInline("typst", use_csi_style and "60pt" or "29pt"),
      })
    end
    if meta["logo-footer-height"] then
      meta["logo-footer-height"] = pandoc.MetaInlines({
        pandoc.RawInline("typst", pandoc.utils.stringify(meta["logo-footer-height"])),
      })
    end

    for _, key in ipairs(plain_text_yml_headers) do
      if meta[key] then
        if key == "title" then
          -- `title` is reused by the Typst template in places that must stay
          -- single-line (running footer, suggested citation), so keep it flat
          -- and instead carry the line-broken version separately for the
          -- title/cover-page headings only.
          local flat_inlines, display_inlines, has_break = {}, {}, false
          for _, el in ipairs(meta[key]) do
            if is_br(el) then
              has_break = true
              table.insert(flat_inlines, pandoc.Space())
              table.insert(display_inlines, pandoc.RawInline("typst", "#linebreak()"))
            else
              table.insert(flat_inlines, el)
              table.insert(display_inlines, el)
            end
          end
          meta.title = pandoc.MetaInlines(flat_inlines)
          if has_break then
            -- This overrides title-display so even if user suppied that via YAML header
            -- it will be overwritten with title
            meta["title-display"] = pandoc.MetaInlines(display_inlines)
          end
        elseif key == "subtitle" then
          -- Subtitle is only ever shown on the title/cover pages,
          -- so it can keep the line break inline without a separate flat variant.
          local inlines = {}
          for _, el in ipairs(meta[key]) do
            if is_br(el) then
              table.insert(inlines, pandoc.RawInline("typst", "#linebreak()"))
            else
              table.insert(inlines, el)
            end
          end
          meta[key] = pandoc.MetaInlines(inlines)
        else
          local value = pandoc.utils.stringify(meta[key])
          meta[key] = pandoc.MetaInlines({
            pandoc.RawInline("typst", '"' .. value .. '"'),
          })
        end
      end
    end
  end

  if not quarto.doc.is_format("html") then
    return meta
  end

  local logo_ref_input = meta["logo-ref"] and pandoc.utils.stringify(meta["logo-ref"])
  local resolved_logo_ref = logo_ref_input and resolve_logo_path(logo_ref_input)
      or (extension_dir .. (use_csi_style and "logo-csi.png" or "logo.png"))
  meta["logo-ref"] = pandoc.MetaString(resolved_logo_ref)

  local logo_height_input = meta["logo-height"] and pandoc.utils.stringify(meta["logo-height"])
  meta["logo-height"] = pandoc.MetaString(resolve_logo_height(logo_height_input, resolved_logo_ref))

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

  local logo_footer_height = meta["logo-footer-height"]
      and pandoc.utils.stringify(meta["logo-footer-height"])
      or (is_true(meta["use-csi-style"]) and "60px" or nil)
  local logo_style = logo_footer_height and (' style="height: ' .. logo_footer_height .. ';"') or ""

  return table.concat({
    '<div class="omni-footer" id="omni-footer">',
    '<img class="omni-footer-logo" src="' .. logo ..
    '" alt="' .. organization_name .. ' logo"' .. logo_style .. ' />',
    '<div class="omni-footer-text">',
    '<p>&copy; ' .. year .. ' ' .. organization_name .. '</p>' .. contact_line,
    '</div>',
    '</div>',
    -- Move footnotes before footer
    '<script>',
    'document.addEventListener("DOMContentLoaded", function () {',
    '  var footer = document.getElementById("omni-footer");',
    '  var footnotes = document.getElementById("footnotes");',
    '  if (footer && footnotes) { footnotes.after(footer); }',
    '});',
    '</script>',
  }, "\n")
end

function Pandoc(doc)
  if quarto.doc.is_format("html") then
    doc.blocks:insert(pandoc.RawBlock("html", build_footer_html(doc.meta)))
  end

  return doc
end
