local logo = [[
      ██╗████████╗    ███╗   ███╗ █████╗ ███╗   ██╗
      ██║╚══██╔══╝    ████╗ ████║██╔══██╗████╗  ██║
      ██║   ██║       ██╔████╔██║███████║██╔██╗ ██║
      ██║   ██║       ██║╚██╔╝██║██╔══██║██║╚██╗██║
      ██║   ██║       ██║ ╚═╝ ██║██║  ██║██║ ╚████║
      ╚═╝   ╚═╝       ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝
]]

logo = string.rep("\n", 4) .. logo .. "\n\n"

return {
  {
    "folke/persistence.nvim",
    event = "BufReadPre", -- this will only start session saving when an actual file was opened
    opts = {
      dir = vim.fn.stdpath("state") .. "/my-sessions/", -- directory where session files are saved
    },
    keys = {
      { "<leader>qs", function() require("persistence").save() end, desc = "Save session" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore last session" },
      { "<leader>qS", function() require("persistence").select() end, desc = "Select session to restore" },
      { "<leader>qd", function() require("persistence").stop() end, desc = "Stop persistence" },
    },
  },
  {
    "nvimdev/dashboard-nvim",
    lazy = false, -- As https://github.com/nvimdev/dashboard-nvim/pull/450, dashboard-nvim shouldn't be lazy-loaded to properly handle stdin.
    opts = function()
      local opts = {
        theme = "hyper",
        config = {
          packages = { enable = false },
          header = vim.split(logo, "\n"),
          shortcut = {
            { icon = "󰊳 ", desc = "Update", group = "@property", action = "Lazy update", key = "u" },
            {
              icon = " ",
              icon_hl = "@variable",
              desc = "Files",
              group = "Label",
              action = [[lua require('fzf-lua').files({cwd_prompt = false})]],
              key = "f",
            },
            {
              icon = " ",
              desc = "Config",
              group = "Number",
              action = [[lua require('fzf-lua').files({ cwd = '~/.config/nvim' })]],
              key = "c",
            },
            {
              icon = " ",
              desc = " Restore Session",
              group = "Number",
              action = [[lua require('persistence').load()]],
              key = "s",
            },
            { icon = "󰒲 ", desc = " Lazy", group = "Number", action = "Lazy", key = "l" },
            { icon = " ", desc = " Quit", group = "Number", action = "qa", key = "q" },
          },
          footer = function()
            return { "productsway.com" }
          end,
          project = { enable = false },
          mru = { limit = 5, cwd_only = true },
        },
      }

      -- open dashboard after closing lazy
      if vim.o.filetype == "lazy" then
        vim.api.nvim_create_autocmd("WinClosed", {
          pattern = tostring(vim.api.nvim_get_current_win()),
          once = true,
          callback = function()
            vim.schedule(function()
              vim.api.nvim_exec_autocmds("UIEnter", { group = "dashboard" })
            end)
          end,
        })
      end

      -- open dashboard with leader ;
      vim.keymap.set("n", "<leader>;", function()
        -- close all open buffers before open dashboard
        for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
          ---@diagnostic disable-next-line: redundant-parameter
          local buftype = vim.api.nvim_buf_get_option(bufnr, "buftype")
          if buftype ~= "terminal" then
            vim.api.nvim_buf_delete(bufnr, { force = true })
          end
        end

        vim.cmd("Dashboard")
      end, { desc = "Open Dashboard", noremap = true })

      return opts
    end,
  },
}
