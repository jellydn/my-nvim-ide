-- search/replace in multiple files
return {
  -- Disable nvim spectre
  {
    "nvim-pack/nvim-spectre",
    enabled = false,
  },
  {
    "MagicDuck/grug-far.nvim",
    opts = { headerMaxWidth = 100 },
    cmd = "GrugFar",
    keys = {
      {
        "<leader>sr",
        function()
          local grug = require("grug-far")
          local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
          local filesFilter = ext and ext ~= "" and "*." .. ext or nil
          local root = require("utils.root").get()
          grug.grug_far({
            transient = true,
            prefills = { filesFilter = filesFilter, flags = root },
          })
        end,
        mode = { "n", "v" },
        desc = "Search and Replace",
      },
      -- Search and replace in LSP root
      {
        "<leader>s/",
        function()
          local grug = require("grug-far")
          local root = require("utils.root").git()
          grug.grug_far({
            transient = true,
            prefills = { flags = root },
          })
        end,
        mode = { "n" },
        desc = "Search and Replace in Project root",
      },
      -- Search on select word
      {
        "<leader>sf",
        function()
          local grug = require("grug-far")
          local root = require("utils.root").git()
          grug.grug_far({
            transient = true,
            prefills = { search = vim.fn.expand("<cword>"), flags = root },
          })
        end,
        desc = "Search word on all files",
      },

      -- Search on current file
      {
        "<leader>sF",
        function()
          local grug = require("grug-far")
          grug.grug_far({
            transient = true,
            prefills = {
              search = vim.fn.expand("<cword>"),
              paths = vim.fn.expand("%"),
            },
          })
        end,
        desc = "Search word on current file",
      },
    },
  },
  {
    "folke/edgy.nvim",
    optional = true,
    opts = function(_, opts)
      opts.left = opts.left or {}
      table.insert(opts.left, {
        title = "Search and Replace",
        ft = "grug-far",
        size = { width = 0.3 },
      })
    end,
  },
}
