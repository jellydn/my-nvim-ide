return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    build = "make",
    opts = {
      hints = { enabled = false }, -- Disable hints
      provider = "copilot", -- You can then change this provider here
      mappings = {
        ask = "<leader>ra",
        edit = "<leader>re",
        refresh = "<leader>rr",
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    config = function(_, options)
      require("avante").setup(options)

      local wk = require("which-key")
      wk.add({
        { "<leader>ra", desc = "Ask AI" },
        { "<leader>re", desc = "Edit selected" },
        { "<leader>rr", desc = "Refresh AI" },
      })
    end,
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    optional = true,
    opts = {
      file_types = { "markdown", "Avante" },
    },
    ft = { "markdown", "Avante" },
  },
}
