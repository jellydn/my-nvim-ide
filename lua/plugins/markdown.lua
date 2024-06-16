return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        marksman = {},
      },
    },
  },
  -- Markdown preview
  {
    "MeanderingProgrammer/markdown.nvim",
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
      -- add <leader>m to open markdown preview
      {
        "<leader>mp",
        "<cmd>PrevimOpen<cr>",
        desc = "[M]arkdown [p]review",
      },
    },
  },
}
