if not vim.g.vscode then
  return {}
end

local enabled = {
  "lazy.nvim",
  "nvim-treesitter",
  "ts-comments.nvim",
  "nvim-treesitter",
  "nvim-treesitter-textobjects",
  "nvim-ts-context-commentstring",
  "vim-repeat",
}

local Config = require("lazy.core.config")
Config.options.checker.enabled = false
Config.options.change_detection.enabled = false
Config.options.defaults.cond = function(plugin)
  return vim.tbl_contains(enabled, plugin.name) or plugin.vscode
end

-- Add some vscode specific keymaps
vim.api.nvim_create_autocmd("User", {
  pattern = "NvimIdeKeymaps", -- This pattern will be called when the plugin is loaded
  callback = function()
    -- find file
    vim.keymap.set("n", "<leader><space>", "<cmd>Find<cr>")
    -- find in files
    vim.keymap.set("n", "<leader>/", [[<cmd>call VSCodeNotify('workbench.action.findInFiles')<cr>]])
    -- open symbol
    vim.keymap.set("n", "<leader>ss", [[<cmd>call VSCodeNotify('workbench.action.gotoSymbol')<cr>]])
    -- view problem
    vim.keymap.set("n", "<leader>xx", [[<cmd>call VSCodeNotify('workbench.actions.view.problems')<cr>]])
    -- open file explorer in left sidebar
    vim.keymap.set("n", "<leader>e", [[<cmd>call VSCodeNotify('workbench.view.explorer')<cr>]])
    -- Code Action
    vim.keymap.set("n", "<leader>ca", [[<cmd>call VSCodeNotify('editor.action.codeAction')<cr>]])
    -- Open terminal
    vim.keymap.set("n", "<leader>ft", [[<cmd>call VSCodeNotify('workbench.action.terminal.focus')<cr>]])
  end,
})

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { highlight = { enable = false } },
  },
}
