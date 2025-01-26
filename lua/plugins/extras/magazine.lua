-- This is setup for the fork of cmp-nvim, refer https://github.com/iguanacucumber/magazine.nvim
-- Improve performance and add more features to nvim-cmp
return {
  {
    "iguanacucumber/magazine.nvim",
    name = "nvim-cmp",
    dependencies = {
      -- Snippet engine
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      -- LSP source for nvim-cmp
      { "iguanacucumber/mag-nvim-lsp", name = "cmp-nvim-lsp", opts = {} },
      { "iguanacucumber/mag-nvim-lua", name = "cmp-nvim-lua" },
      { "iguanacucumber/mag-buffer", name = "cmp-buffer" },
      { "iguanacucumber/mag-cmdline", name = "cmp-cmdline" },
      "https://codeberg.org/FelipeLema/cmp-async-path", -- better than cmp-path
    },
  },
}
