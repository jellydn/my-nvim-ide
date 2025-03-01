local logo = [[
      ██╗████████╗    ███╗   ███╗ █████╗ ███╗   ██╗
      ██║╚══██╔══╝    ████╗ ████║██╔══██╗████╗  ██║
      ██║   ██║       ██╔████╔██║███████║██╔██╗ ██║
      ██║   ██║       ██║╚██╔╝██║██╔══██║██║╚██╗██║
      ██║   ██║       ██║ ╚═╝ ██║██║  ██║██║ ╚████║
      ╚═╝   ╚═╝       ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝
]]

logo = string.rep("\n", 4) .. logo .. "\n\n"

-- Terminal Mappings
local function term_nav(dir)
  return function(self)
    return self:is_floating() and "<c-" .. dir .. ">" or vim.schedule(function()
      vim.cmd.wincmd(dir)
    end)
  end
end

local enable_no_neck_pain = false
local enabled_fzf = false
local enable_oil = false
local enable_nvim_dashboard = false
local hostname = io.popen("hostname"):read("*a"):gsub("%s+", "")

return {
  -- Disable toggle term and use Snacks terminal instead
  {
    "akinsho/toggleterm.nvim",
    enabled = false,
  },
  -- Disable mini buffer remove and use Snacks buffer delete instead
  {
    "echasnovski/mini.bufremove",
    enabled = false,
  },
  -- Disable mini cursor word and use Snacks words instead
  {
    "echasnovski/mini.cursorword",
    enabled = false,
  },
  -- Disable nvim notify and use Snacks notify instead
  {
    "rcarriga/nvim-notify",
    enabled = false,
  },
  -- Disable dashboard
  {
    "nvimdev/dashboard-nvim",
    enabled = enable_nvim_dashboard,
  },
  -- Disable mynote
  {
    "jellydn/my-note.nvim",
    enabled = false,
  },
  {
    "folke/zen-mode.nvim",
    enabled = false,
  },
  {
    "kosayoda/nvim-lightbulb",
    enabled = false,
  },
  {
    "shortcuts/no-neck-pain.nvim",
    enabled = enable_no_neck_pain,
    opts = {
      width = 120,
    },
  },
  {
    "echasnovski/mini.indentscope",
    enabled = false,
  },
  {
    "ibhagwan/fzf-lua",
    enabled = enabled_fzf,
    optional = true,
  },
  {
    "stevearc/oil.nvim",
    enabled = enable_oil,
    optional = true,
  },
  -- Layout management
  {
    "folke/edgy.nvim",
    optional = true,
    ---@module 'edgy'
    ---@param opts Edgy.Config
    opts = function(_, opts)
      for _, pos in ipairs({ "top", "bottom", "left", "right" }) do
        opts[pos] = opts[pos] or {}
        table.insert(opts[pos], {
          ft = "snacks_terminal",
          size = { height = 0.4 },
          title = "%{b:snacks_terminal.id}: %{b:term_title}",
          filter = function(_buf, win)
            return vim.w[win].snacks_win
              and vim.w[win].snacks_win.position == pos
              and vim.w[win].snacks_win.relative == "editor"
              and not vim.w[win].trouble_preview
          end,
        })
      end
    end,
  },
  -- Flash
  {
    "folke/flash.nvim",
    optional = true,
    specs = {
      {
        "folke/snacks.nvim",
        opts = {
          picker = {
            win = {
              input = {
                keys = {
                  ["<a-s>"] = { "flash", mode = { "n", "i" } },
                  ["s"] = { "flash" },
                },
              },
            },
            actions = {
              flash = function(picker)
                require("flash").jump({
                  pattern = "^",
                  label = { after = { 0, 0 } },
                  search = {
                    mode = "search",
                    exclude = {
                      function(win)
                        return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "snacks_picker_list"
                      end,
                    },
                  },
                  action = function(match)
                    local idx = picker.list:row2idx(match.pos[1])
                    picker.list:_move(idx, true, true)
                  end,
                })
              end,
            },
          },
        },
      },
    },
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      image = {
        -- NOTE: brew install imagemagick to install on Mac, refer https://imagemagick.org/script/download.php for more detail
        enabled = true,
      },
      explorer = {
        enabled = not enable_oil,
      },
      picker = {
        enabled = not enabled_fzf,
        ---@class snacks.picker.sources.Config
        sources = {
          files = {
            hidden = true, -- show hidden files
            follow = true,
          },
        },
        ----@class snacks.picker.layout.Config
        layout = {
          layout = {
            backdrop = true,
          },
        },
        ----@class snacks.picker.formatters.Config
        formatters = {
          file = {
            filename_first = true, -- display filename before the file path
          },
        },
        ---@class snacks.picker.previewers.Config
        previewers = {
          git = {
            native = true, -- use native (terminal) or Neovim for previewing git diffs and commits
            cmd = { "delta " },
          },
        },
        ---@class snacks.picker.icons.Config
        icons = {
          files = {
            enabled = false, -- show file icons
          },
        },
        ---@class snacks.picker.win.Config
        win = {
          -- input window
          input = {
            keys = {
              -- Close picker
              ["<Esc>"] = { "close", mode = { "n", "i" } },
              -- Hidden
              ["<a-.>"] = { "toggle_hidden", mode = { "i", "n" } },
              ["<a-h"] = false,
            },
          },
        },
      },
      dashboard = {
        enabled = not enable_nvim_dashboard,
        preset = {
          header = logo,
          keys = {
            { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            {
              icon = " ",
              key = "c",
              desc = "Config",
              action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
            },
            { icon = " ", key = "s", desc = "Restore Session", section = "session" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
            { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy },
            { icon = "󰊳 ", key = "u", desc = "Update", group = "@property", action = ":Lazy update" },
          },
        },
        sections = {
          { section = "header" },
          { icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
          {
            section = "terminal",
            title = "Productsway.com",
            icon = "©",
            --  local user = hostname or vim.env.USER or "User"
            --  local user = vim.fn.expand("$USER")
            cmd = "echo Welcome back, " .. hostname .. "! | bunx cowsay --think",
          },
        },
      },
      bigfile = { enabled = true },
      scratch = { enabled = true },
      zen = {
        enabled = not enable_no_neck_pain,
        win = {
          -- Hide backdrop
          backdrop = { transparent = false },
        },
        toggles = {
          -- Turn off dim plugin for zen mode
          dim = false,
        },
        show = {
          statusline = false, -- can only be shown when using the global statusline
          tabline = true,
        },
        -- Zoom mode
        zoom = {
          toggles = {
            -- Turn off dim plugin for zoom mode
            dim = false,
            git_signs = false,
            mini_diff_signs = false,
            -- diagnostics = false,
            -- inlay_hints = false,
          },
          show = { statusline = false, tabline = true },
          win = {
            backdrop = { transparent = false },
            width = 120,
          },
        },
      },
      indent = {
        enabled = true,
      },
      input = { enabled = true },
      notifier = {
        enabled = true,
        --- Available style: "compact"|"fancy"|"minimal"
        style = "fancy", -- similar to the default nvim-notify style
        level = vim.log.levels.WARN, -- Show only warning and above
      },
      quickfile = { enabled = true },
      statuscolumn = {
        enabled = true,
      },
      words = { enabled = true },
      styles = {
        notification = {
          wo = { wrap = true }, -- Wrap notifications
        },
        -- LazyGit full screen
        lazygit = {
          width = 0,
          height = 0,
        },
      },
      -- Learn this tip from LazyVim
      terminal = {
        win = {
          keys = {
            nav_h = { "<C-h>", term_nav("h"), desc = "Go to Left Window", expr = true, mode = "t" },
            nav_j = { "<C-j>", term_nav("j"), desc = "Go to Lower Window", expr = true, mode = "t" },
            nav_k = { "<C-k>", term_nav("k"), desc = "Go to Upper Window", expr = true, mode = "t" },
            nav_l = { "<C-l>", term_nav("l"), desc = "Go to Right Window", expr = true, mode = "t" },
          },
        },
      },
    },
    keys = {
      -- Picker
      {
        "<leader>,",
        function()
          Snacks.picker.buffers()
        end,
        desc = "Buffers",
      },
      {
        "<leader>/",
        function()
          Snacks.picker.grep()
        end,
        desc = "Grep",
      },
      {
        "<leader>:",
        function()
          Snacks.picker.command_history()
        end,
        desc = "Command History",
      },
      {
        "<leader><space>",
        function()
          Snacks.picker.files()
        end,
        desc = "Find Files",
      },
          -- Explorer
      not enable_oil
          and {
            "<leader>e",
            function()
              Snacks.picker.explorer({
                cwd = vim.fn.expand("%:p:h"),
                auto_close = true,
                layout = {
                  preset = "vertical",
                },
                win = {
                  list = {
                    keys = {
                      ["-"] = "explorer_up",
                    },
                  },
                },
              })
            end,
            desc = "Explorer",
          }
        or {
          "<leader>fe",
          function()
            Snacks.picker.explorer({
              cwd = vim.fn.expand("%:p:h"),
              auto_close = true,
              layout = {
                preset = "vertical",
              },
              win = {
                list = {
                  keys = {
                    ["-"] = "explorer_up",
                  },
                },
              },
            })
          end,
          desc = "Explorer",
        },
      -- find
      {
        "<leader>fb",
        function()
          Snacks.picker.buffers()
        end,
        desc = "Buffers",
      },
      {
        "<leader>fB",
        function()
          Snacks.picker.buffers({ hidden = true, nofile = true })
        end,
        desc = "Buffers (all)",
      },
      {
        "<leader>fc",
        function()
          Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
        end,
        desc = "Find Config File",
      },
      {
        "<leader>ff",
        function()
          Snacks.picker.files()
        end,
        desc = "Find Files",
      },
      {
        "<leader>fg",
        function()
          Snacks.picker.git_files()
        end,
        desc = "Find Git Files",
      },
      {
        "<leader>fr",
        function()
          Snacks.picker.recent()
        end,
        desc = "Recent",
      },
      {
        "<leader>ft",
        function()
          Snacks.terminal()
        end,
        desc = "Toggle Terminal",
      },
      {
        "<leader>fp",
        function()
          Snacks.picker.projects()
        end,
        desc = "Projects",
      },
      -- git
      {
        "<leader>gc",
        function()
          Snacks.picker.git_log()
        end,
        desc = "Git Log",
      },
      {
        "<leader>gs",
        function()
          Snacks.picker.git_status()
        end,
        desc = "Git Status",
      },
      {
        "<leader>gS",
        function()
          Snacks.picker.git_stash()
        end,
        desc = "Git Stash",
      },
      -- Grep
      {
        "<leader>sb",
        function()
          Snacks.picker.lines()
        end,
        desc = "Buffer Lines",
      },
      {
        "<leader>sB",
        function()
          Snacks.picker.grep_buffers()
        end,
        desc = "Grep Open Buffers",
      },
      {
        "<leader>sg",
        function()
          Snacks.picker.grep()
        end,
        desc = "Grep",
      },
      {
        "<leader>sw",
        function()
          Snacks.picker.grep_word()
        end,
        desc = "Visual selection or word",
        mode = { "n", "x" },
      },
      -- search
      {
        '<leader>s"',
        function()
          Snacks.picker.registers()
        end,
        desc = "Registers",
      },
      {
        "<leader>sa",
        function()
          Snacks.picker.autocmds()
        end,
        desc = "Autocmds",
      },
      {
        "<leader>sc",
        function()
          Snacks.picker.command_history()
        end,
        desc = "Command History",
      },
      {
        "<leader>sC",
        function()
          Snacks.picker.commands()
        end,
        desc = "Commands",
      },
      {
        "<leader>sd",
        function()
          Snacks.picker.diagnostics()
        end,
        desc = "Diagnostics",
      },
      {
        "<leader>sD",
        function()
          Snacks.picker.diagnostics_buffer()
        end,
        desc = "Buffer Diagnostics",
      },
      {
        "<leader>sh",
        function()
          Snacks.picker.help()
        end,
        desc = "Help Pages",
      },
      {
        "<leader>sH",
        function()
          Snacks.picker.highlights()
        end,
        desc = "Highlights",
      },
      {
        "<leader>sj",
        function()
          Snacks.picker.jumps()
        end,
        desc = "Jumps",
      },
      {
        "<leader>sk",
        function()
          Snacks.picker.keymaps()
        end,
        desc = "Keymaps",
      },
      {
        "<leader>sl",
        function()
          Snacks.picker.loclist()
        end,
        desc = "Location List",
      },
      {
        "<leader>sM",
        function()
          Snacks.picker.man()
        end,
        desc = "Man Pages",
      },
      {
        "<leader>sm",
        function()
          Snacks.picker.marks()
        end,
        desc = "Marks",
      },
      {
        "<leader>sR",
        function()
          Snacks.picker.resume()
        end,
        desc = "Resume",
      },
      {
        "<leader>sq",
        function()
          Snacks.picker.qflist()
        end,
        desc = "Quickfix List",
      },
      {
        "<leader>su",
        function()
          Snacks.picker.undo()
        end,
        desc = "Undotree",
      },
      {
        "<leader>uC",
        function()
          Snacks.picker.colorschemes()
        end,
        desc = "Colorschemes",
      },
      {
        "<leader>sp",
        function()
          Snacks.picker.lazy()
        end,
        desc = "Search for Plugin Spec",
      },
      -- LSP
      {
        "<leader>ss",
        function()
          Snacks.picker.lsp_symbols()
        end,
        desc = "LSP Symbols",
      },
      -- Zen mode
      {
        "<leader>cz",
        function()
          if enable_no_neck_pain then
            vim.cmd("NoNeckPain")
          else
            Snacks.zen()
          end
        end,
        desc = "Toggle Zen Mode",
      },
      {
        "<leader>tz",
        function()
          Snacks.zen.zoom()
        end,
        desc = "Toggle Zoom",
      },

      -- Notifier
      {
        "<leader>uH",
        function()
          Snacks.notifier.show_history()
        end,
        desc = "Notification History",
      },
      {
        "<leader>un",
        function()
          Snacks.notifier.hide()
        end,
        desc = "Dismiss All Notifications",
      },
      -- Note
      {
        "<leader>no",
        function()
          Snacks.scratch()
        end,
        desc = "Open Note/Scratch Buffer",
      },
      {
        "<leader>ns",
        function()
          Snacks.scratch.select()
        end,
        desc = "Select Note/Scratch Buffer",
      },
      -- Buffer
      {
        "<S-q>",
        function()
          Snacks.bufdelete()
        end,
        desc = "Delete Buffer",
      },
      {
        "<leader>bd",
        function()
          Snacks.bufdelete()
        end,
        desc = "Delete Buffer",
      },
      {
        "<leader>cR",
        function()
          Snacks.rename.rename_file()
        end,
        desc = "Rename File",
      },
      {
        "<leader>gg",
        function()
          Snacks.lazygit()
        end,
        desc = "Lazygit",
      },
      {
        "<leader>go",
        function()
          Snacks.gitbrowse()
        end,
        desc = "Git Open on browser",
        mode = {
          "n",
          "v",
        },
      },
      {
        "<leader>gf",
        function()
          Snacks.lazygit.log_file()
        end,
        desc = "Lazygit Current File History",
      },
      {
        "<leader>gl",
        function()
          Snacks.lazygit.log()
        end,
        desc = "Lazygit Log (cwd)",
      },
      {
        "<leader>gL",
        function()
          Snacks.git.blame_line()
        end,
        desc = "Git Blame Line",
      },
      {
        "<c-/>",
        function()
          Snacks.terminal()
        end,
        desc = "Toggle Terminal",
      },
      {
        "<c-_>",
        function()
          Snacks.terminal()
        end,
        desc = "which_key_ignore",
      },
      {
        "]]",
        function()
          Snacks.words.jump(vim.v.count1)
        end,
        desc = "Next Reference",
        mode = { "n", "t" },
      },
      {
        "[[",
        function()
          Snacks.words.jump(-vim.v.count1)
        end,
        desc = "Prev Reference",
        mode = { "n", "t" },
      },
    },
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          -- Setup some globals for debugging (lazy-loaded)
          _G.dd = function(...)
            Snacks.debug.inspect(...)
          end
          _G.bt = function()
            Snacks.debug.backtrace()
          end
          vim.print = _G.dd -- Override print to use snacks for `:=` command

          -- Create some toggle mappings
          Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
          Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
          Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
          Snacks.toggle.diagnostics():map("<leader>ud")
          Snacks.toggle.line_number():map("<leader>ul")
          Snacks.toggle
            .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
            :map("<leader>uc")
          Snacks.toggle.treesitter():map("<leader>uT")
          Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
          Snacks.toggle.inlay_hints():map("<leader>uh")
          Snacks.toggle.indent():map("<leader>ug")
          Snacks.toggle.dim():map("<leader>uD")
        end,
      })
    end,
  },
  not enabled_fzf and {
    "folke/todo-comments.nvim",
    optional = true,
    keys = {
      {
        "<leader>st",
        function()
          Snacks.picker.todo_comments()
        end,
        desc = "Todo",
      },
      {
        "<leader>sT",
        function()
          Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } })
        end,
        desc = "Todo/Fix/Fixme",
      },
    },
  } or {},
  not enabled_fzf and {
    "folke/trouble.nvim",
    optional = true,
    specs = {
      "folke/snacks.nvim",
      opts = function(_, opts)
        return vim.tbl_deep_extend("force", opts or {}, {
          picker = {
            actions = require("trouble.sources.snacks").actions,
            win = {
              input = {
                keys = {
                  ["<c-t>"] = {
                    "trouble_open",
                    mode = { "n", "i" },
                  },
                },
              },
            },
          },
        })
      end,
    },
  } or {},
}
