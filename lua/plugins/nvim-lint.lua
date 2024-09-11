-- Run linter manual per buffer
-- @param name The name of the linter to run.
local function run_linter_by(name)
  -- Refer for more details https://github.com/mfussenegger/nvim-lint/issues/22#issuecomment-841415438
  require("lint").try_lint(name)
  local bufnr = vim.api.nvim_get_current_buf()
  vim.cmd(string.format("augroup au_%s_lint_%d", name, bufnr))
  vim.cmd("au!")
  vim.cmd(string.format("au BufWritePost <buffer=%d> lua require'lint'.try_lint('%s')", bufnr, name))
  vim.cmd(string.format("au BufEnter <buffer=%d> lua require'lint'.try_lint('%s')", bufnr, name))
  vim.cmd("augroup end")
end

return {
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "<leader>l", group = "linter/lsp", icon = "" },
      },
    },
  },
  {
    "williamboman/mason.nvim",
    optional = true,
    opts = {
      ensure_installed = {
        "eslint_d",
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    event = "VeryLazy",
    opts = {
      linters_by_ft = {
        -- markdown = { "markdownlint" },
        ["*"] = { "cspell", "codespell" }, -- Install with: pip install codespell
        javascript = { "oxlint" },
        typescript = { "oxlint" },
        javascriptreact = { "oxlint" },
        typescriptreact = { "oxlint" },
      },
      linters = {
        eslint_d = {
          args = {
            "--no-warn-ignored", -- Ignore warnings, support Eslint 9
            "--format",
            "json",
            "--stdin",
            "--stdin-filename",
            function()
              return vim.api.nvim_buf_get_name(0)
            end,
          },
        },
      },
    },
    config = function(_, opts)
      local lint = require("lint")
      lint.linters_by_ft = opts.linters_by_ft

      -- Ignore issue with missing eslint config file
      lint.linters.eslint_d = require("lint.util").wrap(lint.linters.eslint_d, function(diagnostic)
        if diagnostic.message:find("Error: Could not find config file") then
          return nil
        end
        return diagnostic
      end)

      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
        callback = function()
          local names = lint._resolve_linter_by_ft(vim.bo.filetype)

          -- Create a copy of the names table to avoid modifying the original.
          names = vim.list_extend({}, names)

          -- Add fallback linters.
          if #names == 0 then
            vim.list_extend(names, lint.linters_by_ft["_"] or {})
          end

          -- Add global linters.
          vim.list_extend(names, lint.linters_by_ft["*"] or {})

          -- Run linters.
          if #names > 0 then
            -- Check the if the linter is available, otherwise it will throw an error.
            for _, name in ipairs(names) do
              local cmd = vim.fn.executable(name)
              if cmd == 0 then
                vim.notify("Linter " .. name .. " is not available", vim.log.levels.INFO)
                return
              else
                -- Run the linter
                lint.try_lint(name)
              end
            end
          end
        end,
      })
    end,
    keys = {
      {
        -- Run lint by name
        "<leader>lR",
        function()
          local items = {
            -- Github actions
            "actionlint", -- go install github.com/rhysd/actionlint/cmd/actionlint@latest
            -- .env files
            "dotenv_linter", -- brew install dotenv-linter
            -- Markdown and writing
            "write_good", -- npm install -g write-good
            -- Eslint
            "eslint_d",
          }

          vim.ui.select(items, {
            prompt = "Select Linter to run",
          }, function(choice)
            if choice ~= nil then
              run_linter_by(choice)
            end
          end)
        end,
        desc = "Select Linter to run",
      },
      -- Fix .env variables
      {
        "<leader>le",
        function()
          local file = vim.fn.fnameescape(vim.fn.expand("%:p")) -- Escape file path for shell

          -- Warn user if file is not .env
          if not string.match(file, "%.env") then
            vim.notify("This is not a .env file", vim.log.levels.WARN)
            return
          end

          vim.cmd("silent !dotenv-linter fix " .. file)
        end,
        desc = "Fix .env file",
      },
    },
  },
}
