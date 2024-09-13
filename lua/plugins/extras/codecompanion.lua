local IS_DEV = false

return {
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "<leader>C", group = "Code Companion" },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "yaml", "markdown" } },
  },
  {
    dir = IS_DEV and "~/research/codecompanion.nvim" or nil,
    "jellydn/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      strategies = {
        chat = {
          adapter = "copilot",
          roles = { llm = "  Copilot Chat", user = "IT Man" },
          keymaps = {
            send = {
              modes = {
                n = "<CR>",
                i = "<C-CR>",
              },
              index = 1,
              callback = "keymaps.send",
              description = "Send",
            },
            close = {
              modes = {
                n = "q",
              },
              index = 3,
              callback = "keymaps.close",
              description = "Close Chat",
            },
            stop = {
              modes = {
                n = "<C-c>",
              },
              index = 4,
              callback = "keymaps.stop",
              description = "Stop Request",
            },
          },
        },
        inline = { adapter = "copilot" },
        agent = { adapter = "copilot" },
      },
      display = {
        chat = {
          window = {
            layout = "vertical", -- float|vertical|horizontal|buffer
          },
        },
      },
      opts = {
        log_level = "DEBUG",
      },
    },
    keys = {
      {
        "<leader>Ca",
        "<cmd>CodeCompanionActions<cr>",
        desc = "Companion actions",
      },
      { "<leader>Cv", "<cmd>CodeCompanionToggle<cr>", desc = "CopilotChat - Toggle" },
    },
  },
}
