return {
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "<leader>fh", group = "harpoon" },
      },
    },
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
    },
    keys = {
      {
        "<leader>fhm",
        function()
          local harpoon = require("harpoon")
          harpoon.ui:toggle_quick_menu(harpoon:list())
        end,
        desc = "Harpoon menu",
      },
      {
        "<leader>fha",
        function()
          local harpoon = require("harpoon")
          harpoon:list():add()
        end,
        desc = "Harpoon Add File",
      },
      {
        "<leader>fhj",
        function()
          local harpoon = require("harpoon")
          harpoon:list():next()
        end,
        desc = "Harpoon Next",
      },
      {
        "<leader>fhk",
        function()
          local harpoon = require("harpoon")
          harpoon:list():prev()
        end,
        desc = "Harpoon Prev",
      },
    },
    opts = {
      settings = {
        save_on_toggle = false,
        sync_on_ui_close = false,
      },
    },
    config = function(_, options)
      local status_ok, harpoon = pcall(require, "harpoon")
      if not status_ok then
        return
      end

      ---@diagnostic disable-next-line: missing-parameter
      harpoon.setup(options)
      for i = 1, 4 do
        vim.keymap.set("n", "<leader>" .. i, function()
          require("harpoon"):list():select(i)
        end, { noremap = true, silent = true, desc = "Harpoon select " .. i })
      end
    end,
  },
}
