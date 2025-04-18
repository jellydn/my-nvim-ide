local M = {}
--- Check if it's Warn Terminal
---@return boolean
local function is_warp_terminal()
  return os.getenv("TERM_PROGRAM") == "WarpTerminal"
end

local function is_alacritty_terminal()
  return os.getenv("TERM") == "xterm-256color"
end

local function is_tmux()
  return os.getenv("TMUX") ~= nil
end

local function is_kitty_terminal()
  return os.getenv("TERM") == "xterm-kitty"
end

local function is_ghostty_terminal()
  return os.getenv("TERM") == "xterm-ghostty"
end

local function is_vscode()
  return vim.g.vscode or os.getenv("TERM_PROGRAM") == "vscode"
end

-- Default color scheme
local default_color_scheme = "kanagawa"

local night_themes = {
  "catppuccin-mocha",
  "dracula",
  "kanagawa",
  "nightfox",
  "rose-pine",
  "night-owl",
  "tokyonight",
  "cobalt2",
}

local function select_theme()
  vim.ui.select(night_themes, {
    prompt = "Select colorscheme:",
  }, function(colorscheme)
    if colorscheme ~= nil then
      vim.notify("Selected colorscheme: " .. colorscheme)
      vim.cmd.colorscheme(colorscheme)
    end
  end)
end

-- Define a keymap to randomize color scheme
vim.keymap.set("n", "<leader>sC", select_theme, {
  desc = "Theme switcher",
})

-- Select color scheme based on the time
M.selectColorSchemeByTime = function()
  -- If it's vscode,, warp terminal, tmux, neovide then use default color scheme
  if
    is_vscode()
    or is_warp_terminal()
    or is_tmux()
    or is_alacritty_terminal()
    or is_kitty_terminal()
    or is_ghostty_terminal()
    or vim.g.neovide
  then
    return default_color_scheme
  end

  local idx = tonumber(os.date("%S")) % #night_themes + 1

  local colorscheme = night_themes[idx]
  return colorscheme
end

return M
