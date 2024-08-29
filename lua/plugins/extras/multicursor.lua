return {
  "brenton-leighton/multiple-cursors.nvim",
  opts = {},
  keys = {
    {
      "<A-d>",
      "<Cmd>MultipleCursorsAddJumpNextMatch<CR>",
      mode = { "n", "x" },
      desc = "Add cursor and jump to next cword",
    },
    {
      "<A-D>",
      "<Cmd>MultipleCursorsAddDown<CR>",
      mode = { "n", "x" },
      desc = "Add cursor and move down",
    },
  },
}
