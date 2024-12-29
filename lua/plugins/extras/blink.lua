---@diagnostic disable: missing-fields
return {
  -- Disable nvim-cmp, use blink.cmp instead
  {
    "hrsh7th/nvim-cmp",
    enabled = false,
  },
  -- Auto completion
  {
    "saghen/blink.cmp",
    event = "InsertEnter",
    -- optional: provides snippets for the snippet source
    dependencies = {
      "L3MON4D3/LuaSnip",
      version = "v2.*",
      build = (function()
        -- Build Step is needed for regex support in snippets.
        -- This step is not supported in many windows environments.
        -- Remove the below condition to re-enable on windows.
        if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
          return
        end
        return "make install_jsregexp"
      end)(),
      dependencies = {
        -- `friendly-snippets` contains a variety of premade snippets.
        {
          "rafamadriz/friendly-snippets",
          config = function()
            require("luasnip.loaders.from_vscode").lazy_load()
          end,
        },
      },
    },
    -- use a release tag to download pre-built binaries
    version = "v0.*",
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    -- Refer https://github.com/Saghen/blink.cmp#configuration
    opts = {
      --  "enter" keymap
      --   ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
      --   ['<C-e>'] = { 'hide', 'fallback' },
      --   ['<CR>'] = { 'accept', 'fallback' },
      --
      --   ['<Tab>'] = { 'snippet_forward', 'fallback' },
      --   ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
      --
      --   ['<Up>'] = { 'select_prev', 'fallback' },
      --   ['<Down>'] = { 'select_next', 'fallback' },
      --   ['<C-p>'] = { 'select_prev', 'fallback' },
      --   ['<C-n>'] = { 'select_next', 'fallback' },
      --
      --   ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
      --   ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
      keymap = { preset = "enter" },
      completion = {
        -- Controls whether the documentation window will automatically show when selecting a completion item
        documentation = {
          auto_show = true,
        },
      },
      -- Experimental signature help support
      signature = {
        enabled = false,
      },
      appearance = {
        -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        nerd_font_variant = "mono",
      },
      snippets = {
        expand = function(snippet)
          require("luasnip").lsp_expand(snippet)
        end,
        active = function(filter)
          if filter and filter.direction then
            return require("luasnip").jumpable(filter.direction)
          end
          return require("luasnip").in_snippet()
        end,
        jump = function(direction)
          require("luasnip").jump(direction)
        end,
      },
      sources = {
        default = { "lsp", "path", "luasnip", "buffer" },
        -- Disable cmdline completions
        cmdline = {},
      },
    },
    -- without having to redefine it
    opts_extend = {
      "sources.completion.enabled_providers",
      "sources.default",
    },
  },
  -- lazydev
  {
    "saghen/blink.cmp",
    opts = {
      sources = {
        -- add lazydev to your completion providers
        default = { "lazydev" },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 100, -- show at a higher priority than lsp
          },
        },
      },
    },
  },
}
