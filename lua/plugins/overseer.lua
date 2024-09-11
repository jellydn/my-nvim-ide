return {
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "<leader>o", group = "overseer/task", icon = "" },
      },
    },
  },
  {
    "stevearc/overseer.nvim",
    dependencies = {
      -- Uncomment to use toggleterm as the strategy
      -- "akinsho/toggleterm.nvim",
    },
    opts = {
      dap = false,
      -- strategy = "toggleterm",
      -- Configuration for task floating windows
      task_win = {
        -- How much space to leave around the floating window
        padding = 2,
        border = "single", -- or double
        -- Set any window options here (e.g. winhighlight)
        win_opts = {
          winblend = 2,
          winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
        },
      },
    },
    keys = {
      {
        "<leader>ot",
        "<CMD>OverseerRun<CR>",
        desc = "Run Task",
      },
      -- Quick action
      {
        "<leader>oq",
        "<CMD>OverseerQuickAction<CR>",
        desc = "Quick Action",
      },
      -- Rerun last command
      {
        "<leader>or",
        function()
          local overseer = require("overseer")
          local tasks = overseer.list_tasks({ recent_first = true })
          if vim.tbl_isempty(tasks) then
            vim.notify("No tasks found", vim.log.levels.WARN)
          else
            overseer.run_action(tasks[1], "restart")
          end
        end,
        desc = "Rerun Last Task",
      },
      -- Toggle
      {
        "<leader>oo",
        "<CMD>OverseerToggle bottom<CR>",
        desc = "Toggle at bottom",
      },
    },
  },
}
