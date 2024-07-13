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
    event = "BufReadPre",
    opts = {
      dir = vim.fn.stdpath("state") .. "/nvim-sessions/", -- directory where session files are saved
      branch = true, -- use git branch to save session
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
            {
              icon = "󰊳 ",
              desc = "Update",
              group = "@property",
              action = "Lazy update",
              key = "u",
            },
            {
              icon = " ",
              icon_hl = "@variable",
              desc = "Files",
              group = "Label",
              action = [[lua require('fzf-lua').files({cwd_prompt = false})]],
              key = "f",
            },
            {
              icon = " ",
              desc = " Restore Session",
              group = "Number",
              action = [[lua require('persistence').load()]],
              key = "s",
            },
            {
              icon = " ",
              desc = "Config",
              group = "Number",
              action = [[lua require('fzf-lua').files({ cwd = '~/.config/nvim' })]],
              key = "c",
            },
            {
              icon = "󰒲 ",
              desc = " Lazy",
              group = "Number",
              action = "Lazy",
              key = "l",
            },
            {
              icon = " ",
              desc = " Quit",
              group = "Number",
              action = "qa",
              key = "q",
            },
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

      return opts
    end,
  },
}
