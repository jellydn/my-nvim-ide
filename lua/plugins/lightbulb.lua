return {
  "kosayoda/nvim-lightbulb",
  event = "LspAttach",
  opts = {
    autocmd = { enabled = true },
    -- Sign column.
    sign = {
      enabled = true,
      text = "⚡",
      hl = "LightBulbSign",
    },
  },
}
