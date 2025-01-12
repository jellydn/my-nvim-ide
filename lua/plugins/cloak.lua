return {
  "laytan/cloak.nvim",
  -- TODO: Support for Fzf lua when it's available, refer https://github.com/laytan/cloak.nvim/issues/17 or migrate to https://github.com/philosofonusus/ecolog.nvim
  opts = { enabled = true, cloak_character = "*" },
  ft = "sh",
  keys = {
    {
      "<leader>tc",
      "<cmd>CloakToggle<cr>",
      desc = "Toggle Cloak",
    },
  },
}
