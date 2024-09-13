local IS_DEV = false

return {
  {
    "jellydn/quick-code-runner.nvim",
    dir = IS_DEV and "~/Projects/research/quick-code-runner.nvim" or nil,
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {
      debug = false,
      position = "50%",
      size = {
        width = "60%",
        height = "60%",
      },
    },
    cmd = { "QuickCodeRunner", "QuickCodePad" },
    keys = {
      {
        "<leader>cp",
        ":QuickCodeRunner<CR>",
        desc = "Quick Code Runner",
        mode = { "v" },
      },
      {
        "<leader>cp",
        ":QuickCodePad<CR>",
        desc = "Quick Code Pad",
      },
    },
  },
}
