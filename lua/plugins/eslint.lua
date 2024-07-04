local Lsp = require("utils.lsp")

return {
  {
    "neovim/nvim-lspconfig",
    -- other settings removed for brevity
    opts = {
      servers = {
        eslint = {
          settings = {
            -- helps eslint find the eslintrc when it's placed in a subfolder instead of the cwd root
            workingDirectories = { mode = "auto" },
            -- change to flag to true to use the flat config (Eslint 9+), refer https://eslint.org/blog/2024/04/eslint-v9.0.0-released/
            experimental = {
              useFlatConfig = false,
            },
          },
        },
      },
      setup = {
        eslint = function()
          Lsp.on_attach(function(client, bufnr)
            if client.name == "eslint" then
              vim.api.nvim_create_autocmd("BufWritePre", {
                buffer = bufnr,
                command = "EslintFixAll",
              })
            end
          end)
        end,
      },
    },
  },
}
