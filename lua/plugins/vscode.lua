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
-- Refer to https://github.com/vscode-neovim/vscode-neovim#code-navigation-bindings for default keymaps
vim.api.nvim_create_autocmd("User", {
  pattern = "NvimIdeKeymaps", -- This pattern will be called when the plugin is loaded
  callback = function()
    local vscode = require("vscode")
    -- +File
    -- Find file
    vim.keymap.set("n", "<leader><space>", "<cmd>Find<cr>")
    -- Open other files
    vim.keymap.set("n", "<leader>,", function()
      vscode.call("workbench.action.showAllEditors")
    end)
    -- Find in files
    vim.keymap.set("n", "<leader>/", function()
      vscode.call("workbench.action.findInFiles")
    end)
    -- Open file explorer in left sidebar
    vim.keymap.set("n", "<leader>e", function()
      vscode.call("workbench.view.explorer")
    end)

    -- +Search
    -- Open symbol
    vim.keymap.set("n", "<leader>ss", function()
      vscode.call("workbench.action.gotoSymbol")
    end)
    -- Search word under cursor
    vim.keymap.set("n", "<leader>sw", function()
      local code = require("vscode")
      code.action("editor.action.addSelectionToNextFindMatch")
      code.action("workbench.action.findInFiles")
      -- Or send as the param like this: code.action("workbench.action.findInFiles", { args = { query = vim.fn.expand("<cword>") } })
    end)

    -- +Code
    -- Code Action
    vim.keymap.set("n", "<leader>ca", function()
      vscode.call("editor.action.codeAction")
    end)
    -- Source Action
    vim.keymap.set("n", "<leader>cA", function()
      vscode.call("editor.action.sourceAction")
    end)
    -- Code Rename
    vim.keymap.set("n", "<leader>cr", function()
      vscode.call("editor.action.rename")
    end)
    -- Quickfix shortcut
    vim.keymap.set("n", "<leader>.", function()
      vscode.call("editor.action.quickFix")
    end)
    -- Code format
    vim.keymap.set("n", "<leader>cf", function()
      vscode.call("editor.action.formatDocument")
    end)
    -- Refactor
    vim.keymap.set("n", "<leader>cR", function()
      vscode.call("editor.action.refactor")
    end)

    -- +Terminal
    -- Open terminal
    vim.keymap.set("n", "<leader>ft", function()
      vscode.call("workbench.action.terminal.focus")
    end)

    -- +LSP
    -- View problem
    vim.keymap.set("n", "<leader>xx", function()
      vscode.call("workbench.actions.view.problems")
    end)
    -- Go to next/prev error
    vim.keymap.set("n", "]e", function()
      vscode.call("editor.action.marker.next")
    end)
    vim.keymap.set("n", "[e", function()
      vscode.call("editor.action.marker.prev")
    end)

    -- Find references
    vim.keymap.set("n", "gr", function()
      vscode.call("references-view.find")
    end)

    -- +Git
    -- Git status
    vim.keymap.set("n", "<leader>gs", function()
      vscode.call("workbench.view.scm")
    end)
    -- Go to next/prev change
    vim.keymap.set("n", "]h", function()
      vscode.call("workbench.action.editor.nextChange")
    end)
    vim.keymap.set("n", "[h", function()
      vscode.call("workbench.action.editor.previousChange")
    end)

    -- +Buffer
    -- Close buffer
    vim.keymap.set("n", "<leader>bd", function()
      vscode.call("workbench.action.closeActiveEditor")
    end)
    -- Close other buffers
    vim.keymap.set("n", "<leader>bo", function()
      vscode.call("workbench.action.closeOtherEditors")
    end)

    -- +Project
    vim.keymap.set("n", "<leader>fp", function()
      vscode.call("workbench.action.openRecent")
    end)

    -- Markdown preview
    vim.keymap.set("n", "<leader>mp", function()
      vscode.call("markdown.showPreviewToSide")
    end)

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
