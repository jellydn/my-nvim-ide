local function calculate_with()
  local width = vim.api.nvim_win_get_width(0)
  local min_width = math.max(width * 0.70, 85)
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
      width = calculate_with(),
    },
    keys = {
      -- add <leader>cz to enter zen mode
      {
        "<leader>cz",
        "<cmd>NoNeckPain<cr>",
        desc = "Distraction Free Mode",
      },
      -- Increase and decrease width of NoNeckPain
      {
        "<leader>zu",
        "<cmd>NoNeckPainWidthUp<cr>",
        desc = "Increase NoNeckPain Width",
      },
      {
        "<leader>zd",
        "<cmd>NoNeckPainWidthDown<cr>",
        desc = "Decrease NoNeckPain Width",
      },
    },
  },
}
