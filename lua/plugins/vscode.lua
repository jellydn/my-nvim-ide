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
    -- Find file
    vim.keymap.set("n", "<leader><space>", "<cmd>Find<cr>")
    -- Find in files
    vim.keymap.set("n", "<leader>/", [[<cmd>call VSCodeNotify('workbench.action.findInFiles')<cr>]])
    -- Open symbol
    vim.keymap.set("n", "<leader>ss", [[<cmd>call VSCodeNotify('workbench.action.gotoSymbol')<cr>]])
    -- View problem
    vim.keymap.set("n", "<leader>xx", [[<cmd>call VSCodeNotify('workbench.actions.view.problems')<cr>]])
    -- Open file explorer in left sidebar
    vim.keymap.set("n", "<leader>e", [[<cmd>call VSCodeNotify('workbench.view.explorer')<cr>]])
    -- Code Action
    vim.keymap.set("n", "<leader>ca", [[<cmd>call VSCodeNotify('editor.action.codeAction')<cr>]])
    -- Code Rename
    vim.keymap.set("n", "<leader>cr", [[<cmd>call VSCodeNotify('editor.action.rename')<cr>]])
    -- LSP Reference
    vim.keymap.set("n", "gr", [[<cmd>call VSCodeNotify('editor.action.referenceSearch.trigger')<cr>]])
    -- Git status
    vim.keymap.set("n", "<leader>gs", [[<cmd>call VSCodeNotify('workbench.view.scm')<cr>]])
    -- Switch project
    vim.keymap.set("n", "<leader>fp", [[<cmd>call VSCodeNotify('workbench.action.openRecent')<cr>]])
    -- Open terminal
    vim.keymap.set("n", "<leader>ft", [[<cmd>call VSCodeNotify('workbench.action.terminal.focus')<cr>]])

    -- Close buffer
    vim.keymap.set("n", "<leader>bd", [[<cmd>call VSCodeNotify('workbench.action.closeActiveEditor')<cr>]])
  end,
})

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { highlight = { enable = false } },
  },
}
