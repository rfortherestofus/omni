local color_map = {
  ["white"]            = "#ffffff",
  ["ivory"]            = "#f9f7f4",
  ["ivory-400"]        = "#e9dfcf",
  ["orange-red-200"]   = "#ff9e85",
  ["orange-red-400"]   = "#ff5e34",
  ["orange-red-600"]   = "#cc4100",
  ["golden-yellow-200"]= "#fde880",
  ["golden-yellow-400"]= "#fcd82b",
  ["golden-yellow-600"]= "#f7b925",
  ["olive-green-200"]  = "#b8c690",
  ["olive-green-400"]  = "#89a046",
  ["olive-green-600"]  = "#3b5530",
  ["teal-200"]         = "#c5dfd9",
  ["teal-400"]         = "#8ac0b3",
  ["teal-600"]         = "#41816f",
  ["plum-200"]         = "#dd9cb9",
  ["plum-400"]         = "#c65a8b",
  ["plum-600"]         = "#921c4c",
  ["periwinkle-200"]   = "#d4ddeb",
  ["periwinkle-400"]   = "#a9bad8",
  ["periwinkle-600"]   = "#5776b2",
  ["steel-blue-200"]   = "#bfcbd3",
  ["steel-blue-400"]   = "#677384",
  ["steel-blue-600"]   = "#405065",
  ["navy"]             = "#081c39",
}

function Span(el)
  if not quarto.doc.is_format("typst") then
    return el
  end

  for _, class in ipairs(el.classes) do
    local color = color_map[class]
    if color then
      -- Render the span's inline content as Typst, preserving any
      -- nested formatting (bold, italic, other spans, etc.)
      local inner = pandoc.write(
        pandoc.Pandoc({ pandoc.Plain(el.content) }),
        "typst"
      )
      -- Strip the trailing newline pandoc.write adds
      inner = inner:gsub("%s+$", "")
      return pandoc.RawInline(
        "typst",
        '#text(fill: rgb("' .. color .. '"))[' .. inner .. ']'
      )
    end
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