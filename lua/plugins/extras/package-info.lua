return {
  {
    "vuki656/package-info.nvim",
    dependencies = "MunifTanjim/nui.nvim",
    keys = {
      {
        "<leader>ni",
        function()
          require("package-info").show()
        end,
        desc = "Show NPM Package Info",
      },
      {
        "<leader>nu",
        function()
          require("package-info").update()
        end,
        desc = "Update current package",
      },
    },
    opts = {},
  },
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "<leader>n", group = "NPM" },
      },
    },
  },
}
