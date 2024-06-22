--- Check if it's weekend
---@return boolean
local function is_weekend()
  local day = tonumber(os.date("%w"))
  return day == 0 or day == 6
end

--- Check if it's day time
---@return boolean
local function is_day_time()
  local hour = tonumber(os.date("%H"))
  return hour >= 9 and hour < 19
end
local is_transparent = is_day_time() and not is_weekend()

return {
  {
    "rebelot/kanagawa.nvim",
    lazy = true,
    opts = {
      dimInactive = true, -- dim inactive window `:h hl-NormalNC`
      -- Remove gutter background
      colors = {
        theme = {
          all = {
            ui = {
              bg_gutter = "none",
            },
          },
        },
      },
      overrides = function()
        return {
          -- Transparent background
          NormalFloat = { bg = "none" },
          FloatBorder = { bg = "none" },
          FloatTitle = { bg = "none" },
        }
      end,
    },
  },
  {
    "EdenEast/nightfox.nvim",
    opts = {
      options = {
        transparent = is_transparent,
        styles = {
          comments = "italic",
          keywords = "bold",
          types = "italic,bold",
        },
      },
    },
    lazy = true,
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    opts = {
      variant = "moon",
      disable_background = is_transparent,
      disable_float_background = is_transparent,
      styles = {
        bold = true,
        italic = true,
        transparency = is_transparent,
      },
    },
    lazy = true,
  },
  {
    "catppuccin/nvim",
    lazy = true,
    name = "catppuccin",
    opts = {
      transparent_background = is_transparent,
    },
  },
  {
    "Mofiqul/dracula.nvim",
    lazy = true,
    opts = {
      transparent_bg = is_transparent,
      show_end_of_buffer = true,
      -- set italic comment
      italic_comment = true,
    },
    config = function(_, opts)
      local dracula = require("dracula")
      dracula.setup(opts)
      -- Disable spell check as it's too red
      vim.o.spell = false
    end,
  },
}
