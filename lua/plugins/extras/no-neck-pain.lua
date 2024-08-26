local function zen_mode_width()
  local width = vim.api.nvim_win_get_width(0)
  local min_width = math.max(width * 0.75, 90)
  return math.min(width, min_width)
end

return {
  -- Disable zen-mode by default and use no-neck-pain instead
  {
    "folke/zen-mode.nvim",
    enabled = false,
  },
  {
    "shortcuts/no-neck-pain.nvim",
    opts = {
      width = zen_mode_width(),
    },
    keys = {
      -- add <leader>cz to enter zen mode
      {
        "<leader>cz",
        "<cmd>NoNeckPain<cr>",
        desc = "Distraction Free Mode",
      },
    },
  },
}
