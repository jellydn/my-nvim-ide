local Lsp = require("utils.lsp")

return {
  "neovim/nvim-lspconfig",
  ---@class PluginLspOpts
  opts = {
    servers = {
      denols = {
        root_dir = require("lspconfig").util.root_pattern("deno.json", "deno.jsonc", "deno.lock"),
        settings = {
          deno = {
            inlayHints = {
              parameterNames = { enabled = "all", suppressWhenArgumentMatchesName = true },
              parameterTypes = { enabled = false },
              variableTypes = { enabled = false, suppressWhenTypeMatchesName = true },
              propertyDeclarationTypes = { enabled = false },
              functionLikeReturnTypes = { enable = true },
              enumMemberValues = { enabled = true },
            },
          },
        },
      },
    },
    setup = {
      denols = function(_, opts)
        Lsp.on_attach(function(client, bufnr)
          if client.name == "denols" then
            -- Attach twoslash queries
            require("twoslash-queries").attach(client, bufnr)
          end
        end)
      end,
    },
  },
}
