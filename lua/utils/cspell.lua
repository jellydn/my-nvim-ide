local Path = require("utils.path")

local M = {}

function M.create_cspell_json_if_not_exist()
  local cspell_json_path = Path.get_root_directory() .. "/cspell.json"

  if vim.fn.filereadable(cspell_json_path) == 0 then
    local file = io.open(cspell_json_path, "w")
    if file then
      local default_content = [[
{
  "$schema": "https://raw.githubusercontent.com/streetsidesoftware/cspell/main/cspell.schema.json",
  "version": "0.2",
  "language": "en",
  "globRoot": ".",
  "dictionaryDefinitions": [
    {
      "name": "cspell-tool",
      "path": "./cspell-tool.txt",
      "addWords": true
    }
  ],
  "dictionaries": [
    "cspell-tool"
  ],
  "ignorePaths": [
    "node_modules",
    "dist",
    "build",
    "/cspell-tool.txt"
  ]
}
]]
      file:write(default_content)
      file:close()
    else
      vim.notify("Could not create cSpell.json", vim.log.levels.WARN, { title = "cSpell" })
    end
  end
end

-- Add unknown word under cursor to dictionary
function M.add_word_to_c_spell_dictionary()
  local word = vim.fn.expand("<cword>")

  -- Show popup to confirm the action
  local confirm = vim.fn.confirm("Add '" .. word .. "' to cSpell dictionary?", "&Yes\n&No", 2)
  if confirm ~= 1 then
    M.add_word_from_diagnostics_to_c_spell_dictionary()
    return
  end

  M.create_cspell_json_if_not_exist()
  local dictionary_path = Path.get_root_directory() .. "/cspell-tool.txt"

  -- Append the word to the dictionary file
  local file = io.open(dictionary_path, "a")
  if file then
    -- Detect new line at the end of the file or not
    local last_char = file:seek("end", -1)
    if last_char ~= nil and last_char ~= "\n" then
      word = "\n" .. word
    end

    file:write(word .. "")
    file:close()
    -- Reload buffer to update the dictionary
    vim.cmd("e!")
  else
    vim.notify("Could not open cSpell dictionary", vim.log.levels.WARN, { title = "cSpell" })
  end
end

-- Add unknown word from cspell diagnostics source to dictionary
function M.add_word_from_diagnostics_to_c_spell_dictionary()
  -- Get diagnostics source and only get from cspell
  local bufnr = vim.api.nvim_get_current_buf()
  local winnr = vim.api.nvim_get_current_win()
  local cursor = vim.api.nvim_win_get_cursor(winnr)
  local diagnostics = vim.lsp.diagnostic.get_line_diagnostics(bufnr, cursor[1] - 1)
  local cspell_diagnostics = {}
  for _, diagnostic in ipairs(diagnostics) do
    if diagnostic.source == "cspell" then
      table.insert(cspell_diagnostics, diagnostic)
    end
  end

  -- Get the first word from the first cspell diagnostic
  -- E.g. "Unknown word ( word )"
  local word = cspell_diagnostics[1].message:match("%((.+)%)")
  if word == nil then
    vim.notify("Could not find unknown word", vim.log.levels.WARN, { title = "cSpell" })
    return
  end

  -- Show popup to confirm the action
  local confirm = vim.fn.confirm("Add '" .. word .. "' to cSpell dictionary?", "&Yes\n&No", 2)
  if confirm ~= 1 then
    return
  end

  M.create_cspell_json_if_not_exist()
  local dictionary_path = Path.get_root_directory() .. "/cspell-tool.txt"

  -- Append the word to the dictionary file
  local file = io.open(dictionary_path, "a")
  if file then
    -- Detect new line at the end of the file or not
    local last_char = file:seek("end", -1)
    if last_char ~= nil and last_char ~= "\n" then
      word = "\n" .. word
    end

    file:write(word .. "")
    file:close()
    -- Reload buffer to update the dictionary
    vim.cmd("e!")
  else
    vim.notify("Could not open cSpell dictionary", vim.log.levels.WARN, { title = "cSpell" })
  end
end

return M
