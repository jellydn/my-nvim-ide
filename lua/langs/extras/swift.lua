-- Credits to https://github.com/lbennett-stacki/LazyVim/blob/swift-lang/lua/lazyvim/plugins/extras/lang/swift.lua
-- More info: https://wojciechkulik.pl/ios/the-complete-guide-to-ios-macos-development-in-neovim
-- brew install xcode-build-server
-- brew install xcbeautify
-- brew install swiftformat
-- brew install swiftlint
-- brew install ruby
-- gem install xcodeproj
-- python3 -m pip install -U pymobiledevice3
return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "swift" })
    end,
  },

  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "swiftlint",
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Refer https://www.swift.org/documentation/articles/zero-to-swift-nvim.html
        sourcekit = {},
      },
    },
  },

  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        swift = { "swiftlint" },
      },
    },
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        -- NOTE: brew install swiftformat
        swift = { "swiftformat" },
      },
    },
  },
}
