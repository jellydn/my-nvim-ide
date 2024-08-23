-- Calculate min width of the window should be 70% of the editor width or 90 columns
-- whichever is smaller
local function zen_mode_width()
  local width = vim.api.nvim_win_get_width(0)
  local min_width = math.max(width * 0.75, 90)
  return math.min(width, min_width)
end

return {
  -- Not performant so only enable when needed
  {
    "folke/twilight.nvim",
    lazy = true,
    opts = {
      dimming = {
        inactive = true, -- when true, other windows will be fully dimmed (unless they contain the same buffer)
      },
      context = 20, -- amount of lines we will try to show around the current line
      treesitter = true, -- use treesitter when available for the filetype
    },
    keys = {
      {
        "<leader>tt",
        "<cmd>Twilight<cr>",
        desc = "Toggle twilight",
      },
    },
  },
  {
    "folke/zen-mode.nvim",
    cmd = { "ZenMode" },
    opts = {
      window = {
        width = zen_mode_width(),
      },
      plugins = {
        options = {
          enabled = true,
          ruler = false, -- disables the ruler text in the cmd line area
          showcmd = false, -- disables the command in the last line of the screen
          laststatus = 0, -- turn off the statusline in zen mode
        },
        twilight = { enabled = false }, -- disables to start Twilight when zen mode opens
        -- NOTE: Those options are disables by default, change to enabled = true to enable
        gitsigns = { enabled = false }, -- disables git signs
        tmux = { enabled = false }, -- disables the tmux statusline
        -- NOTE: Need to add to wezterm config https://github.com/folke/zen-mode.nvim#wezterm
        wezterm = {
          enabled = false,
          font = "+1", -- +1 font size or fixed size, e.g. 21
        },
        alacritty = {
          enabled = true,
          font = "19.5", -- set font size to 19.5
        },
        kitty = {
          enabled = true,
          font = "+0.5", -- increase font size by 0.5
        },
        neovide = {
          enabled = true,
          scale = 1.1, -- Increase scale by 10%
        },
      },
    },
    keys = {
      -- add <leader>cz to enter zen mode
      {
        "<leader>cz",
        "<cmd>ZenMode<cr>",
        desc = "Distraction Free Mode",
      },
    },
  },
}
