return {
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    keys = {
      { "<leader>tu", "<cmd>UndotreeToggle<cr>", desc = "Toggle Undo Tree" },
    },
    init = function()
      -- Persist undo, refer https://github.com/mbbill/undotree#usage
      local undodir = vim.fn.expand("~/.undo-nvim")

      if vim.fn.has("persistent_undo") == 1 then
        if vim.fn.isdirectory(undodir) == 0 then
          os.execute("mkdir -p " .. undodir)
        end

        vim.opt.undodir = undodir
        vim.opt.undofile = true
      end

      -- set layout style to 2, let g:undotree_WindowLayout = 2
      vim.g.undotree_WindowLayout = 2
    end,
  },
  {
    "folke/edgy.nvim",
    optional = true,
    opts = function(_, opts)
      opts.left = opts.left or {}
      table.insert(opts.left, {
        title = "Undo Tree",
        ft = "undotree",
      })
    end,
  },
}
