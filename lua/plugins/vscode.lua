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
    -- +File
    -- Find file
    vim.keymap.set("n", "<leader><space>", "<cmd>Find<cr>")
    -- Open other files
    vim.keymap.set("n", "<leader>,", [[<cmd>call VSCodeNotify('workbench.action.showAllEditors')<cr>]])
    -- Find in files
    vim.keymap.set("n", "<leader>/", [[<cmd>call VSCodeNotify('workbench.action.findInFiles')<cr>]])
    -- Open file explorer in left sidebar
    vim.keymap.set("n", "<leader>e", [[<cmd>call VSCodeNotify('workbench.view.explorer')<cr>]])

    -- +Search
    -- Open symbol
    vim.keymap.set("n", "<leader>ss", [[<cmd>call VSCodeNotify('workbench.action.gotoSymbol')<cr>]])
    -- Search word under cursor
    vim.keymap.set("n", "<leader>sw", function()
      local code = require("vscode")
      code.action("editor.action.addSelectionToNextFindMatch")
      code.action("workbench.action.findInFiles")
    end)

    -- +Code
    -- Code Action
    vim.keymap.set("n", "<leader>ca", [[<cmd>call VSCodeNotify('editor.action.codeAction')<cr>]])
    -- Source Action
    vim.keymap.set("n", "<leader>cA", [[<cmd>call VSCodeNotify('editor.action.sourceAction')<cr>]])
    -- Code Rename
    vim.keymap.set("n", "<leader>cr", [[<cmd>call VSCodeNotify('editor.action.rename')<cr>]])
    -- Quickfix shortcut
    vim.keymap.set("n", "<leader>.", [[<cmd>call VSCodeNotify('editor.action.quickFix')<cr>]])
    -- Code format
    vim.keymap.set("n", "<leader>cf", [[<cmd>call VSCodeNotify('editor.action.formatDocument')<cr>]])
    -- Refactor
    vim.keymap.set("n", "<leader>rm", [[<cmd>call VSCodeNotify('editor.action.refactor')<cr>]])

    -- +Terminal
    -- Open terminal
    vim.keymap.set("n", "<leader>ft", [[<cmd>call VSCodeNotify('workbench.action.terminal.focus')<cr>]])

    -- +LSP
    -- View problem
    vim.keymap.set("n", "<leader>xx", [[<cmd>call VSCodeNotify('workbench.actions.view.problems')<cr>]])
    -- Go to next/prev error
    vim.keymap.set("n", "]e", [[<cmd>call VSCodeNotify('editor.action.marker.next')<cr>]])
    vim.keymap.set("n", "[e", [[<cmd>call VSCodeNotify('editor.action.marker.prev')<cr>]])

    -- Find references
    vim.keymap.set("n", "gr", [[<cmd>call VSCodeNotify('references-view.find')<cr>]])

    -- +Git
    -- Git status
    vim.keymap.set("n", "<leader>gs", [[<cmd>call VSCodeNotify('workbench.view.scm')<cr>]])
    -- Go to next/prev change
    vim.keymap.set("n", "]h", [[<cmd>call VSCodeNotify('workbench.action.editor.nextChange')<cr>]])
    vim.keymap.set("n", "[h", [[<cmd>call VSCodeNotify('workbench.action.editor.previousChange')<cr>]])

    -- +Buffer
    -- Close buffer
    vim.keymap.set("n", "<leader>bd", [[<cmd>call VSCodeNotify('workbench.action.closeActiveEditor')<cr>]])
    -- Close other buffers
    vim.keymap.set("n", "<leader>bo", [[<cmd>call VSCodeNotify('workbench.action.closeOtherEditors')<cr>]])

    -- +Project
    vim.keymap.set("n", "<leader>fp", [[<cmd>call VSCodeNotify('workbench.action.openRecent')<cr>]])

    -- Other keymaps will be used with https://github.com/VSpaceCode/vscode-which-key, so we don't need to define them here
    -- Trigger which-key by pressing <CMD+Space>, refer more default keymaps https://github.com/VSpaceCode/vscode-which-key/blob/15c5aa2da5812a21210c5599d9779c46d7bfbd3c/package.json#L265
  end,
})

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { highlight = { enable = false } },
  },
}
