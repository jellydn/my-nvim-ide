return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        marksman = {},
      },
    },
  },
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "<leader>m", group = "markdown", icon = "" },
      },
    },
  },
  -- Markdown preview
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {},
    ft = { "markdown" },
    keys = {
      {
        "<leader>tm",
        "<cmd>RenderMarkdownToggle<cr>",
        desc = "Toggle Markdown preview",
      },
    },
  },
  {
    "previm/previm",
    config = function()
      -- define global for open markdown preview, let g:previm_open_cmd = 'open -a Safari'
      vim.g.previm_open_cmd = "open -a Arc"
    end,
    ft = { "markdown" },
    keys = {
      {
        "<leader>m",
        "<cmd>PrevimOpen<cr>",
        desc = "Markdown preview",
      },
    },
  },
}
