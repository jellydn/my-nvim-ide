-- Setup LSP servers and related tools base on LazyVim
local Lsp = require("utils.lsp")

local diagnostics = {
  Error = " ",
  Warn = " ",
  Hint = " ",
  Info = " ",
}

local setup_keymaps = function(client, buffer)
  -- Get default keymaps
  local keymaps = Lsp.get_default_keymaps()

  -- We don't want to use fzf-lua when running in vscode
  local has_fzf = not vim.g.vscode and package.loaded["fzf-lua"]
  local has_snacks = not vim.g.vscode and package.loaded["snacks"]

  if has_fzf then
    -- Override default keymaps with fzf-lua variants
    vim.list_extend(keymaps, {
      {
        keys = "gd",
        func = "<cmd>FzfLua lsp_definitions jump_to_single_result=true ignore_current_line=true<cr>",
        desc = "Goto Definition",
        has = "definitionProvider",
      },
      {
        keys = "gr",
        func = "<cmd>FzfLua lsp_references jump_to_single_result=true ignore_current_line=true<cr>",
        desc = "Goto References",
        has = "referencesProvider",
        nowait = true,
      },
      {
        keys = "gi",
        func = "<cmd>FzfLua lsp_implementations jump_to_single_result=true ignore_current_line=true<cr>",
        desc = "Goto Implementation",
        has = "implementationProvider",
      },
      {
        keys = "gy",
        func = "<cmd>FzfLua lsp_typedefs jump_to_single_result=true ignore_current_line=true<cr>",
        desc = "Goto Type Definition",
        has = "typeDefinitionProvider",
      },
    })
  end

  if has_snacks then
    vim.list_extend(keymaps, {
      {
        keys = "gd",
        func = function()
          Snacks.picker.lsp_definitions()
        end,
        desc = "Goto Definition",
        has = "definitionProvider",
      },
      {
        keys = "gr",
        func = function()
          Snacks.picker.lsp_references()
        end,
        desc = "Goto References",
        has = "referencesProvider",
        nowait = true,
      },
      {
        keys = "gi",
        func = function()
          Snacks.picker.lsp_implementations()
        end,
        desc = "Goto Implementation",
        has = "implementationProvider",
      },
      {
        keys = "gy",
        func = function()
          Snacks.picker.lsp_type_definitions()
        end,
        desc = "Goto Type Definition",
        has = "typeDefinitionProvider",
      },
    })
  end

  -- Add inlay hints toggle if supported
  if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
    table.insert(keymaps, {
      keys = "<leader>th",
      func = function()
        require("utils.toggle").inlay_hints(buffer)
      end,
      desc = "Toggle Inlay Hints",
    })
  end

  -- Setup all keymaps
  for _, keymap in ipairs(keymaps) do
    if not keymap.has or client.server_capabilities[keymap.has] then
      vim.keymap.set(keymap.mode or "n", keymap.keys, keymap.func, {
        buffer = buffer,
        desc = "LSP: " .. keymap.desc,
        nowait = keymap.nowait,
      })
    end
  end
end

return {
  -- Lsp config
  {
    "neovim/nvim-lspconfig",
    event = "VeryLazy",
    dependencies = {
      "mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    ---@class PluginLspOpts
    opts = function()
      return {
        -- options for vim.diagnostic.config()
        ---@type vim.diagnostic.Opts
        diagnostics = {
          underline = true,
          update_in_insert = false,
          virtual_text = {
            spacing = 4,
            source = "if_many",
            prefix = "●",
            -- this will set set the prefix to a function that returns the diagnostics icon based on the severity
            -- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
            -- prefix = "icons",
          },
          severity_sort = true,
          signs = {
            text = {
              [vim.diagnostic.severity.ERROR] = diagnostics.Error,
              [vim.diagnostic.severity.WARN] = diagnostics.Warn,
              [vim.diagnostic.severity.HINT] = diagnostics.Hint,
              [vim.diagnostic.severity.INFO] = diagnostics.Info,
            },
          },
        },
        -- Enable this to enable the builtin LSP inlay hints on Neovim >= 0.10.0
        -- Be aware that you also will need to properly configure your LSP server to
        -- provide the inlay hints.
        inlay_hints = {
          enabled = true,
          exclude = { "vue" }, -- filetypes for which you don't want to enable inlay hints
        },
        -- add any global capabilities here
        capabilities = {
          workspace = {
            fileOperations = {
              didRename = true,
              willRename = true,
            },
          },
        },
        ---@type lspconfig.options
        servers = {},
        -- you can do any additional lsp server setup here
        -- return true if you don't want this server to be setup with lspconfig
        ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
        setup = {},
      }
    end,
    ---@param opts PluginLspOpts
    config = function(_, opts)
      -- Setup keymaps
      require("utils.lsp").on_attach(setup_keymaps)

      require("utils.lsp").setup()
      require("utils.lsp").on_dynamic_capability(setup_keymaps)

      -- diagnostics signs
      if type(opts.diagnostics.signs) ~= "boolean" then
        for severity, icon in pairs(opts.diagnostics.signs.text) do
          local name = vim.diagnostic.severity[severity]:lower():gsub("^%l", string.upper)
          name = "DiagnosticSign" .. name
          vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
        end
      end

      -- inlay hints
      if opts.inlay_hints.enabled then
        require("utils.lsp").on_supports_method("textDocument/inlayHint", function(_, buffer)
          if
            vim.api.nvim_buf_is_valid(buffer)
            and vim.bo[buffer].buftype == ""
            and not vim.tbl_contains(opts.inlay_hints.exclude, vim.bo[buffer].filetype)
          then
            require("utils.toggle").inlay_hints(buffer, true)
          end
        end)
      end

      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      local servers = opts.servers
      local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      local has_blink, blink = pcall(require, "blink.cmp")
      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        has_blink and blink.get_lsp_capabilities() or has_cmp and cmp_nvim_lsp.default_capabilities() or {},
        opts.capabilities or {}
      )

      local function setup(server)
        local server_opts = vim.tbl_deep_extend("force", {
          capabilities = vim.deepcopy(capabilities),
        }, servers[server] or {})

        if opts.setup[server] then
          if opts.setup[server](server, server_opts) then
            return
          end
        elseif opts.setup["*"] then
          if opts.setup["*"](server, server_opts) then
            return
          end
        end
        require("lspconfig")[server].setup(server_opts)
      end

      -- get all the servers that are available through mason-lspconfig
      local have_mason, mlsp = pcall(require, "mason-lspconfig")
      local all_mslp_servers = {}
      if have_mason then
        all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
      end

      local ensure_installed = {} ---@type string[]
      for server, server_opts in pairs(servers) do
        if server_opts then
          server_opts = server_opts == true and {} or server_opts
          if server_opts.enabled ~= false then
            -- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
            if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
              setup(server)
            else
              ensure_installed[#ensure_installed + 1] = server
            end
          end
        end
      end

      if have_mason then
        mlsp.setup({
          ensure_installed = vim.tbl_deep_extend("force", ensure_installed, {}),
          handlers = { setup },
        })
      end
    end,
  },
  -- cmdline tools and lsp servers
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    build = ":MasonUpdate",
    opts_extend = { "ensure_installed" },
    opts = {
      ensure_installed = {
        "stylua",
      },
    },
    ---@param opts MasonSettings | {ensure_installed: string[]}
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      mr:on("package:install:success", function()
        vim.defer_fn(function()
          -- trigger FileType event to possibly load this newly installed LSP server
          require("lazy.core.handler.event").trigger({
            event = "FileType",
            buf = vim.api.nvim_get_current_buf(),
          })
        end, 100)
      end)

      mr.refresh(function()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end)
    end,
  },
}
