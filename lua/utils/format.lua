local M = {}

--- This function formats the selected text with JSON format
function M.format_json_with_jq()
  -- Save the selected text to a temporary file
  local temp_name = vim.fn.tempname()
  vim.cmd("'<,'>write !jq '.' >" .. temp_name)

  -- Replace the selected text with the formatted JSON
  vim.cmd("'<,'>read " .. temp_name)
  vim.cmd("'<,'>delete")
  vim.fn.delete(temp_name)
end

return M
