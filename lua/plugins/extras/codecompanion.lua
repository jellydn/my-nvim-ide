local IS_DEV = false

return {
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "<leader>A", group = "AI Code Companion" },
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
      -- Optional to show loading spinner on API request
      "jellydn/spinner.nvim",
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
      pre_defined_prompts = {
        -- Custom the prompt message
        ["Generate a Commit Message"] = {
          prompts = {
            {
              role = "user",
              content = function()
                return "Write commit message with commitizen convention. Write clear, informative commit messages that explain the 'what' and 'why' behind changes, not just the 'how'."
                  .. "\n\n```\n"
                  .. vim.fn.system("git diff")
                  .. "\n```"
              end,
              opts = {
                contains_code = true,
              },
            },
          },
        },
        -- Add custom prompts
        ["Generate a Commit Message for Staged"] = {
          strategy = "chat",
          description = "Generate a commit message for staged change",
          opts = {
            index = 9,
            mapping = "<LocalLeader>cM",
            slash_cmd = "staged-commit",
            auto_submit = true,
          },
          prompts = {
            {
              role = "user",
              content = function()
                return "Write commit message for the change with commitizen convention. Write clear, informative commit messages that explain the 'what' and 'why' behind changes, not just the 'how'."
                  .. "\n\n```\n"
                  .. vim.fn.system("git diff --staged")
                  .. "\n```"
              end,
              opts = {
                contains_code = true,
              },
            },
          },
        },
        ["Document"] = {
          strategy = "chat",
          description = "Write documentation for code.",
          opts = {
            index = 10,
            mapping = "<LocalLeader>cd",
            modes = { "v" },
            slash_cmd = "doc",
            auto_submit = true,
            user_prompt = false,
            stop_context_insertion = true,
          },
          prompts = {
            {
              role = "user",
              content = function(context)
                local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)

                return "Please brief how it works and provide documentation in comment code for the following code. Also suggest to have better naming to improve readability.\n\n```"
                  .. context.filetype
                  .. "\n"
                  .. code
                  .. "\n```\n\n"
              end,
              opts = {
                contains_code = true,
              },
            },
          },
        },
        ["Review"] = {
          strategy = "chat",
          description = "Review the provided code snippet.",
          opts = {
            index = 11,
            mapping = "<LocalLeader>cr",
            modes = { "v" },
            slash_cmd = "review",
            auto_submit = true,
            user_prompt = false,
            stop_context_insertion = true,
          },
          prompts = {
            {
              role = "user",
              content = function(context)
                local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)

                return "Please review the following code and provide suggestions for improvement then refactor the following code to improve its clarity and readability:\n\n```"
                  .. context.filetype
                  .. "\n"
                  .. code
                  .. "\n```\n\n"
              end,
              opts = {
                contains_code = true,
              },
            },
          },
        },
        ["Naming"] = {
          strategy = "chat",
          description = "Give betting naming for the provided code snippet.",
          opts = {
            index = 12,
            mapping = "<LocalLeader>cn",
            modes = { "v" },
            slash_cmd = "naming",
            auto_submit = true,
            user_prompt = false,
            stop_context_insertion = true,
          },
          prompts = {
            {
              role = "user",
              content = function(context)
                local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)

                return "Please provide better names for the following variables and functions:\n\n```"
                  .. context.filetype
                  .. "\n"
                  .. code
                  .. "\n```\n\n"
              end,
              opts = {
                contains_code = true,
              },
            },
          },
        },
      },
    },
    config = function(_, options)
      require("codecompanion").setup(options)

      -- Show loading spinner when request is started
      local spinner = require("spinner")
      local group = vim.api.nvim_create_augroup("CodeCompanionHooks", {})
      vim.api.nvim_create_autocmd({ "User" }, {
        pattern = "CodeCompanionRequest*",
        group = group,
        callback = function(request)
          if request.match == "CodeCompanionRequestStarted" then
            spinner.show()
          end
          if request.match == "CodeCompanionRequestFinished" then
            spinner.hide()
          end
        end,
      })
    end,
    keys = {
      -- Recommend setup
      {
        "<leader>Aa",
        "<cmd>CodeCompanionActions<cr>",
        desc = "Code Companion - Actions",
        mode = { "n", "v" },
      },
      { "<leader>Av", "<cmd>CodeCompanionToggle<cr>", desc = "Code Companion - Toggle", mode = { "n", "v" } },
      -- Some common usages with visual mode
      { "<leader>Ae", "<cmd>CodeCompanion /explain<cr>", desc = "Code Companion - Explain code", mode = "v" },
      { "<leader>Af", "<cmd>CodeCompanion /fix<cr>", desc = "Code Companion - Fix code", mode = "v" },
      {
        "<leader>Al",
        "<cmd>CodeCompanion /lsp<cr>",
        desc = "Code Companion - Explain LSP diagnostic",
        mode = { "n", "v" },
      },
      { "<leader>At", "<cmd>CodeCompanion /tests<cr>", desc = "Code Companion - Generate unit test", mode = "v" },
      -- Custom prompts
      { "<leader>Ad", "<cmd>CodeCompanion /doc<cr>", desc = "Code Companion - Document code", mode = "v" },
      { "<leader>Ar", "<cmd>CodeCompanion /review<cr>", desc = "Code Companion - Review code", mode = "v" },
      { "<leader>An", "<cmd>CodeCompanion /naming<cr>", desc = "Code Companion - Better naming", mode = "v" },
    },
  },
}
