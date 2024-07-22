-- search/replace in multiple files
return {
  {
    "MagicDuck/grug-far.nvim",
    opts = {},
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
          grug.grug_far({ prefills = { flags = root } })
        end,
        mode = { "n" },
        desc = "Search and Replace in Project root",
      },
    },
  },
  {
    "folke/edgy.nvim",
    optional = true,
    opts = function(_, opts)
      opts.right = opts.right or {}
      table.insert(opts.right, {
        title = "Search and Replace",
        ft = "grug-far",
        size = { width = 0.35 },
      })
    end,
  },
}
