return {
  {
    "stevearc/aerial.nvim",
    event = "LspAttach",
    opts = {},
    keys = {
      { "<leader>to", "<cmd>AerialToggle<cr>", desc = "Toggle Aerial (Outline)" },
    },
  },
  {
    "folke/edgy.nvim",
    optional = true,
    opts = function(_, opts)
      opts.right = opts.right or {}
      table.insert(opts.right, {
        title = "Outline",
        ft = "aerial",
      })
    end,
  },
}
