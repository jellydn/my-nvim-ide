local IS_DEV = false

return {
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "<leader>h", group = "hurl", icon = "" },
      },
    },
  },
  {
    "jellydn/hurl.nvim",
    dir = IS_DEV and "~/Projects/research/hurl.nvim" or nil,
    ft = "hurl",
    dependencies = { "MunifTanjim/nui.nvim", "nvim-treesitter/nvim-treesitter" },
    opts = {
      mode = "split",
      auto_close = false,
      debug = false,
      show_notification = false,
      formatters = {
        json = { "jq" },
        html = {
          "prettier",
          "--parser",
          "html",
        },
      },
      fixture_vars = {
        {
          name = "random_int_number",
          callback = function()
            return math.random(1, 1000)
          end,
        },
        {
          name = "random_float_number",
          callback = function()
            local result = math.random() * 10
            return string.format("%.2f", result)
          end,
        },
        {
          name = "now",
          callback = function()
            return os.date("%d/%m/%Y")
          end,
        },
      },
    },
    keys = {
      -- Run API request
      { "<leader>hA", "<cmd>HurlRunner<CR>", desc = "Run All requests" },
      { "<leader>ha", "<cmd>HurlRunnerAt<CR>", desc = "Run Api request" },
      { "<leader>he", "<cmd>HurlRunnerToEntry<CR>", desc = "Run Api request to entry" },
      { "<leader>hE", "<cmd>HurlRunnerToEnd<CR>", desc = "Run Api request from current entry to end" },
      { "<leader>hv", "<cmd>HurlVerbose<CR>", desc = "Run Api in verbose mode" },
      -- Run Hurl request in visual mode
      { "<leader>hh", ":HurlRunner<CR>", desc = "Hurl Runner", mode = "v" },
      -- Show last response
      { "<leader>hh", "<cmd>HurlShowLastResponse<CR>", desc = "History", mode = "n" },
      -- Manage variable
      { "<leader>hg", ":HurlSetVariable", desc = "Add global variable" },
      { "<leader>hG", "<cmd>HurlManageVariable<CR>", desc = "Manage global variable" },
      -- Toggle
      { "<leader>tH", "<cmd>HurlToggleMode<CR>", desc = "Toggle Hurl Split/Popup" },
    },
  },
  {
    "folke/edgy.nvim",
    optional = true,
    opts = function(_, opts)
      opts.right = opts.right or {}
      table.insert(opts.right, {
        title = "hurl.nvim",
        ft = "hurl-nvim",
        size = { width = 0.5 },
      })
    end,
  },
}
