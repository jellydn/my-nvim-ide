-- This is useful for showing key presses on screen on recordings or live streams.
return {
  "NStefan002/screenkey.nvim",
  cmd = "Screenkey",
  opts = {},
  keys = {
    { "<leader>tk", ":Screenkey<cr>", desc = "Toggle Screenkey" },
  },
}
