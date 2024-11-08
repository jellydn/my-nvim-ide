return {
  {
    "folke/edgy.nvim",
    optional = true,
    opts = function(_, opts)
      opts.right = opts.right or {}
      table.insert(opts.right, "lspsagaoutline")
    end,
  },
  -- Setup LSP Saga
  {
    "glepnir/lspsaga.nvim",
    event = "LspAttach",
    opts = {
      -- Disable lightbulb and symbol in winbar
      lightbulb = {
        enable = false,
      },
      symbol_in_winbar = {
        enable = false,
      },
      -- Show LSP server name
      code_action = {
        show_server_name = true,
      },
      -- Open definition with "o" key
      definition = {
        keys = {
          edit = "o",
        },
      },
      callhierarchy = {
        keys = {
          edit = "o",
        },
      },
      -- Set max height for finder
      finder = {
        max_height = 0.6,
        methods = {
          tyd = "textDocument/typeDefinition",
        },
      },
      -- Disable auto preview and detail in outline
      outline = {
        auto_preview = false,
        detail = false,
      },
    },
    -- Group LspSaga keymap with prefix "<leader>l"
    keys = {
      -- LSP Finder
      { "<leader>lf", "<cmd>Lspsaga finder<CR>", desc = "LSP Finder" },
      -- Go to definition
      { "<leader>ld", "<cmd>Lspsaga goto_definition<CR>", desc = "Go to Definition" },
      -- Go to type definition
      { "<leader>lt", "<cmd>Lspsaga goto_type_definition<CR>", desc = "Go to Type Definition" },
      -- Peek definition
      { "<leader>lp", "<cmd>Lspsaga peek_definition<CR>", desc = "Peek Definition" },
      -- Tog<leader>le Outline
      { "<leader>ls", "<cmd>Lspsaga outline<CR>", desc = "Toggle Outline" },
      -- Hover Doc
      { "<leader>lh", "<cmd>Lspsaga hover_doc<CR>", desc = "Hover Doc" },
      -- Incoming call
      { "<leader>li", "<cmd>Lspsaga incoming_calls<CR>", desc = "Incoming Call" },
      -- Outgoing call
      { "<leader>lo", "<cmd>Lspsaga outgoing_calls<CR>", desc = "Outgoing Call" },
      -- Code action
      { "<leader>la", "<cmd>Lspsaga code_action<CR>", desc = "Code Action" },
      -- Source action
      {
        "<leader>lA",
        function()
          -- TODO: Not working yet
          require("lspsaga.codeaction").code_action({ context = { only = "source" } })
        end,
        desc = "Source Action",
      },
      -- Rename in project, c-k to quit
      { "<leader>lr", "<cmd>Lspsaga rename<CR>", desc = "Rename" },

      { "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", desc = "Jump to Next Diagnostic" },
      -- Jump to prev diagnostic
      { "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", desc = "Jump to Prev Diagnostic" },
      -- Jump to next error
      {
        "]e",
        function()
          require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.ERROR })
        end,
        desc = "Jump to Next Error",
      },
      -- Jump to next warning
      {
        "]w",
        function()
          require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.WARN })
        end,
        desc = "Jump to Next Warning",
      },
      -- Jump to next information
      {
        "]i",
        function()
          require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.INFO })
        end,
        desc = "Jump to Next Information",
      },
      -- Jump to next hint
      {
        "]H",
        function()
          require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.HINT })
        end,
        desc = "Jump to Next Hint",
      },
      -- Jump to prev error
      {
        "[e",
        function()
          require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.ERROR })
        end,
        desc = "Jump to Prev Error",
      },
      -- Jump to prev warning
      {
        "[w",
        function()
          require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.WARN })
        end,
        desc = "Jump to Prev Warning",
      },
      -- Jump to prev information
      {
        "[i",
        function()
          require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.INFO })
        end,
        desc = "Jump to Prev Information",
      },
      -- Jump to prev hint
      {
        "[H",
        function()
          require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.HINT })
        end,
        desc = "Jump to Prev Hint",
      },
    },
  },
}
