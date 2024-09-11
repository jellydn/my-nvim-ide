-- Change the global to false to disable the eslint LSP start on startup
local enable_eslint = vim.g.lsp_eslint_enable == "yes" or false

local Lsp = require("utils.lsp")

local eslint_config = {
  settings = {
    -- helps eslint find the eslintrc when it's placed in a subfolder instead of the cwd root
    workingDirectories = { mode = "auto" },
    -- change to flag to true to use the flat config (Eslint 9+), refer https://eslint.org/blog/2024/04/eslint-v9.0.0-released/
    experimental = {
      useFlatConfig = false,
    },
  },
}

local function toggle_eslint()
  enable_eslint = not enable_eslint
  if enable_eslint then
    Lsp.start_lsp_client_by_name("eslint", eslint_config)
    vim.cmd(":e") -- Workaround for the LSP on_attach function not being triggered
  else
    Lsp.stop_lsp_client_by_name("eslint")
  end
end

vim.api.nvim_create_user_command("ToggleEslint", toggle_eslint, {
  desc = "Toggle ESLint LSP",
})

return {
  {
    "neovim/nvim-lspconfig",
    -- other settings removed for brevity
    opts = {
      servers = {
        eslint = eslint_config,
      },
      setup = {
        eslint = function()
          if enable_eslint == false then
            return true
          end
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
