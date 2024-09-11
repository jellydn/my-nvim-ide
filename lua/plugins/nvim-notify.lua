return {
  {
    "rcarriga/nvim-notify",
    keys = {
      {
        "<leader>un",
        function()
          require("notify").dismiss({ silent = true, pending = true })
        end,
        desc = "Dismiss All Notifications",
      },
    },
    opts = {
      level = vim.log.levels.WARN,
      stages = "static",
      render = "minimal",
      timeout = 1500, -- 1.5s
      max_height = function()
        return math.floor(vim.o.lines * 0.40)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.80)
      end,
      on_open = function(win)
        vim.api.nvim_win_set_config(win, { zindex = 100 })
      end,
    },
    init = function()
      local lazy = require("utils.lazy")
      if not lazy.has("noice.nvim") then
        lazy.on_very_lazy(function()
          vim.notify = require("notify")
        end)
      end
    end,
  },
}
