return {
  -- Auto completion
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    version = false,
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      {
        "garymjr/nvim-snippets",
        opts = {
          friendly_snippets = true,
        },
        dependencies = { "rafamadriz/friendly-snippets" },
      },
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({

        snippet = {
          expand = function(args)
            vim.snippet.expand(args.body)
          end,
        },

        completion = { completeopt = "menu,menuone,noinsert" },
        mapping = cmp.mapping.preset.insert({
          -- Select the [n]ext item
          ["<C-n>"] = cmp.mapping.select_next_item(),
          -- Select the [p]revious item
          ["<C-p>"] = cmp.mapping.select_prev_item(),

          -- Scroll the documentation window [b]ack / [f]orward
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),

          -- Accept the completion.
          ["<CR>"] = cmp.mapping.confirm({ select = true }),

          -- Manually trigger a completion from nvim-cmp.
          ["<C-Space>"] = cmp.mapping.complete({}),
        }),
        sources = {
          { name = "nvim_lsp" },
          { name = "snippets" },
          { name = "path" },
          { name = "buffer" },
        },
      })
    end,
  },
  -- Snippets
  {
    "garymjr/nvim-snippets",
    keys = {
      {
        "<C-l>",
        function()
          return vim.snippet.active({ direction = 1 }) and "<cmd>lua vim.snippet.jump(1)<cr>" or "<C-l>"
        end,
        expr = true,
        silent = true,
        mode = { "i", "s" },
      },
      {
        "<C-h>",
        function()
          return vim.snippet.active({ direction = -1 }) and "<cmd>lua vim.snippet.jump(-1)<cr>" or "<C-h>"
        end,
        expr = true,
        silent = true,
        mode = { "i", "s" },
      },
    },
  },
  -- Copilot
  {
    "github/copilot.vim",
    event = "VeryLazy",
    config = function()
      -- For copilot.vim
      -- enable copilot for specific filetypes
      vim.g.copilot_filetypes = {
        ["TelescopePrompt"] = false,
      }

      -- Set to true to assume that copilot is already mapped
      vim.g.copilot_assume_mapped = true
      -- Set workspace folders
      vim.g.copilot_workspace_folders = "~/Projects"

      -- Setup keymaps
      local keymap = vim.keymap.set
      local opts = { silent = true }

      -- Set <C-y> to accept copilot suggestion
      keymap("i", "<C-y>", 'copilot#Accept("\\<CR>")', { expr = true, replace_keycodes = false })

      -- Set <C-i> to accept line
      keymap("i", "<C-i>", "<Plug>(copilot-accept-line)", opts)

      -- Set <C-j> to next suggestion, <C-k> to previous suggestion
      keymap("i", "<C-j>", "<Plug>(copilot-next)", opts)
      keymap("i", "<C-k>", "<Plug>(copilot-previous)", opts)

      -- Set <C-d> to dismiss suggestion
      keymap("i", "<C-d>", "<Plug>(copilot-dismiss)", opts)
    end,
  },
  -- Install LSP servers
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        -- formatters
        "prettier",
        "prettierd",
        -- code spell
        "codespell",
        "misspell",
        "cspell",
        -- markdown
        "markdownlint",
        -- rustywind for tailwindcss
        "rustywind",
        -- astro
        "astro-language-server",
        -- Solidity
        "solidity",
      },
    },
  },
  -- Refactoring
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-treesitter/nvim-treesitter" },
    },
    keys = {
      {
        "<leader>rm",
        function()
          require("refactoring").select_refactor({
            show_success_message = true,
          })
        end,
        mode = { "v" },
        desc = "Refactoring menu",
      },
      -- Debug variable
      {
        "<leader>dv",
        function()
          require("refactoring").debug.print_var({
            show_success_message = true,
            below = true,
          })
        end,
        mode = { "n", "x" },
        desc = "Print below variables",
      },
      {
        "<leader>dV",
        function()
          require("refactoring").debug.print_var({
            show_success_message = true,
            below = false,
          })
        end,
        mode = { "n", "x" },
        desc = "Print above variables",
      },
      -- Clean up debugging
      {
        "<leader>dc",
        function()
          require("refactoring").debug.cleanup({
            force = true,
            show_success_message = true,
          })
        end,
        desc = "Clear debugging",
      },
    },
    opts = {
      prompt_func_return_type = {
        go = false,
        java = false,

        cpp = false,
        c = false,
        h = false,
        hpp = false,
        cxx = false,
      },
      prompt_func_param_type = {
        go = false,
        java = false,

        cpp = false,
        c = false,
        h = false,
        hpp = false,
        cxx = false,
      },
      printf_statements = {},
      print_var_statements = {},
    },
  },
  -- Code comment
  {
    "folke/ts-comments.nvim",
    opts = {},
    event = "VeryLazy",
  },
  {
    -- A better annotation generator. Supports multiple languages and annotation conventions.
    -- <C-n> to jump to next annotation, <C-p> to jump to previous annotation
    "danymat/neogen",
    dependencies = "nvim-treesitter/nvim-treesitter",
    opts = { enabled = true },
    cmd = "Neogen",
    keys = {
      { "<leader>ci", "<cmd>Neogen<cr>", desc = "Neogen: Annotation generator" },
    },
  },
  -- Lightbulb for LSP code action (VS Code like)
  {
    "kosayoda/nvim-lightbulb",
    event = "LspAttach",
    opts = {
      autocmd = { enabled = true },
      -- Sign column.
      sign = {
        enabled = true,
        text = "⚡",
        hl = "LightBulbSign",
      },
    },
  },
}
