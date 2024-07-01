local Lsp = require("utils.lsp")

return {
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "spectral-language-server" })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      servers = {
        -- Refer https://github.com/stoplightio/spectral to more information
        -- Simply add the following to your .spectral.yaml file
        -- echo 'extends: ["spectral:oas", "spectral:asyncapi"]' > .spectral.yaml
        spectral = {},
      },
      setup = {
        spectral = function()
          -- Disable spectral client if no config file is found
          if not Lsp.spectral_config_path() then
            return true
          end
        end,
      },
    },
  },
}
