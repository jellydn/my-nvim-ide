local create_cmd = vim.api.nvim_create_user_command

local function setProjectRootByCurrentBuffer()
  -- get path by test file
  local path = vim.fn.expand("%:p:h")
  -- find up to 5 levels to find package.json
  for i = 1, 5 do
    local package_json = path .. "/package.json"
    if vim.fn.filereadable(package_json) == 1 then
      break
    end
    path = vim.fn.fnamemodify(path, ":h")
  end

  -- set project root
  vim.g["test#project_root"] = path
end

-- Usage: :TestWithJest when in test file or :TestWithVitest when in test file
-- vim-test plugin has not supported on large project or monorepo yet. A lot of issues on github
-- e.g: "Not a test file" error when running any of the test command
create_cmd("JestRunner", function()
  setProjectRootByCurrentBuffer()
  vim.g["test#javascript#runner"] = "jest"

  -- set npx jest to run test
  vim.g["test#javascript#jest#executable"] = "npx jest"
  vim.g["test#javascript#jest#options"] = "--detectOpenHandles --updateSnapshot"

  vim.cmd("TestNearest")
end, {})

create_cmd("VitestRunner", function()
  setProjectRootByCurrentBuffer()
  vim.g["test#javascript#runner"] = "vitest"

  -- set npx vitest to run test
  vim.g["test#javascript#vitest#executable"] = "npx vitest"
  vim.g["test#javascript#vitest#options"] = "--update"

  vim.cmd("TestNearest")
end, {})

return {
  {
    "vim-test/vim-test",
    cmd = { "TestNearest", "TestFile", "TestSuite" },
    keys = {
      { "<leader>ct", "<cmd>TestNearest<cr>", desc = "Run Test Nearest" },
      { "<leader>cT", "<cmd>TestFile<cr>", desc = "Run Test File" },
      { "<leader>cS", "<cmd>TestSuite<cr>", desc = "Run Test Suite" },
    },
    config = function()
      local tt = require("toggleterm")
      local ttt = require("toggleterm.terminal")

      vim.g["test#custom_strategies"] = {
        tterm = function(cmd)
          tt.exec(cmd)
        end,

        tterm_close = function(cmd)
          local term_id = 0
          tt.exec(cmd, term_id)
          ttt.get_or_create_term(term_id):close()
        end,
      }

      vim.g["test#strategy"] = "tterm"

      -- add -A to deno test
      vim.g["test#javascript#denotest#options"] = "-A"
    end,
  },
  {
    "nvim-neotest/neotest",
    dependencies = { "nvim-neotest/nvim-nio", { "nvim-neotest/neotest-plenary" } },
    opts = {
      -- Can be a list of adapters like what neotest expects,
      -- or a list of adapter names,
      -- or a table of adapter names, mapped to adapter configs.
      -- The adapter will then be automatically loaded with the config.
      adapters = {},
      -- Example for loading neotest-go with a custom config
      -- adapters = {
      --   ["neotest-go"] = {
      --     args = { "-tags=integration" },
      --   },
      -- },
      status = { virtual_text = true },
      output = { open_on_run = true },
    },
    config = function(_, opts)
      local neotest_ns = vim.api.nvim_create_namespace("neotest")
      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            -- Replace newline and tab characters with space for more compact diagnostics
            local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
            return message
          end,
        },
      }, neotest_ns)

      if opts.adapters then
        local adapters = {}
        for name, config in pairs(opts.adapters or {}) do
          if type(name) == "number" then
            if type(config) == "string" then
              config = require(config)
            end
            adapters[#adapters + 1] = config
          elseif config ~= false then
            local adapter = require(name)
            if type(config) == "table" and not vim.tbl_isempty(config) then
              local meta = getmetatable(adapter)
              if adapter.setup then
                adapter.setup(config)
              elseif meta and meta.__call then
                adapter(config)
              else
                error("Adapter " .. name .. " does not support setup")
              end
            end
            adapters[#adapters + 1] = adapter
          end
        end
        opts.adapters = adapters
      end

      require("neotest").setup(opts)
    end,
    keys = {
      {
        "<leader>t",
        "",
        desc = "+test",
      },
      {
        "<leader>tt",
        function()
          require("neotest").run.run(vim.fn.expand("%"))
        end,
        desc = "Run File",
      },
      {
        "<leader>tT",
        function()
          require("neotest").run.run(vim.uv.cwd())
        end,
        desc = "Run All Test Files",
      },
      {
        "<leader>tr",
        function()
          require("neotest").run.run()
        end,
        desc = "Run Nearest",
      },
      {
        "<leader>tl",
        function()
          require("neotest").run.run_last()
        end,
        desc = "Run Last",
      },
      {
        "<leader>ts",
        function()
          require("neotest").summary.toggle()
        end,
        desc = "Toggle Summary",
      },
      {
        "<leader>to",
        function()
          require("neotest").output.open({ enter = true, auto_close = true })
        end,
        desc = "Show Output",
      },
      {
        "<leader>tO",
        function()
          require("neotest").output_panel.toggle()
        end,
        desc = "Toggle Output Panel",
      },
      {
        "<leader>tS",
        function()
          require("neotest").run.stop()
        end,
        desc = "Stop",
      },
      {
        "<leader>tw",
        function()
          require("neotest").watch.toggle(vim.fn.expand("%"))
        end,
        desc = "Toggle Watch",
      },
    },
  },
  {
    "folke/edgy.nvim",
    optional = true,
    opts = function(_, opts)
      opts.right = opts.right or {}
      opts.bottom = opts.bottom or {}
      table.insert(opts.right, {
        title = "Neotest Summary",
        ft = "neotest-summary",
      })
      table.insert(opts.bottom, {
        title = "Neotest Output",
        ft = "neotest-output-panel",
        size = { height = 15 },
      })
    end,
  },
}
