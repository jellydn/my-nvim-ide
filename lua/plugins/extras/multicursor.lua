return {
  "brenton-leighton/multiple-cursors.nvim",
  opts = {},
  vscode = false,
  keys = {
    {
      "<C-m>",
      "<Cmd>MultipleCursorsAddJumpNextMatch<CR>",
      mode = { "n", "x" },
      desc = "Add cursor and jump to next cword",
    },
  },
}
