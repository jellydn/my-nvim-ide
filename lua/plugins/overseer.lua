return {
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "<leader>T", group = "task", icon = "" },
      },
    },
  },
  {
    "stevearc/overseer.nvim",
    dependencies = {
      "akinsho/toggleterm.nvim",
    },
    opts = {
      dap = false,
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
        "<leader>Tt",
        "<CMD>OverseerRun<CR>",
        desc = "Overseer - Run Task",
      },
      -- Quick action
      {
        "<leader>Tq",
        "<CMD>OverseerQuickAction<CR>",
        desc = "Overseer - Quick Action",
      },
      -- Rerun last command
      {
        "<leader>Tr",
        function()
          local overseer = require("overseer")
          local tasks = overseer.list_tasks({ recent_first = true })
          if vim.tbl_isempty(tasks) then
            vim.notify("No tasks found", vim.log.levels.WARN)
          else
            overseer.run_action(tasks[1], "restart")
          end
        end,
        desc = "Overseer - Rerun Last Task",
      },
      -- Toggle
      {
        "<leader>To",
        "<CMD>OverseerToggle bottom<CR>",
        desc = "Overseer - Toggle at bottom",
      },
    },
  },
}
