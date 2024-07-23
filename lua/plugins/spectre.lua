--- General configuration for spectre base on current git repo
---@param default_opts table | nil
---@return table
function _G.get_spectre_options(default_opts)
  local Path = require("utils.path")
  local opts = default_opts or {}

  if Path.is_git_repo() then
    local git_root = require("utils.root").get()
    opts.cwd = git_root
  end

  return opts
end

return {
  {
    -- Search and replace with pattern
    "nvim-pack/nvim-spectre",
    cmd = "Spectre",
    opts = { open_cmd = "noswapfile vnew" },
    keys = {
      -- Search and replace from git root
      {
        "<leader>sr",
        function()
          local git_root = require("utils.root").git()
          require("spectre").open({
            cwd = git_root,
          })
        end,
        desc = "Replace in Files (Git root)",
      },
      -- Search and replace from LSP root, useful for monorepo
      {
        "<leader>s/",
        ":lua require('spectre').open(_G.get_spectre_options())<CR>",
        desc = "Replace in files",
      },
      -- Search on select word
      {
        "<leader>sf",
        ":lua require('spectre').open_visual(_G.get_spectre_options({ select_word = true }))<CR>",
        desc = "Search word on all files",
      },
      -- Search on current file
      {
        "<leader>sF",
        ":lua require('spectre').open_file_search(_G.get_spectre_options({ select_word = true }))<CR>",
        desc = "Search word on current file",
      },
    },
  },
  {
    "folke/edgy.nvim",
    optional = true,
    opts = function(_, opts)
      opts.left = opts.left or {}
      table.insert(opts.left, {
        title = "Spectre",
        ft = "spectre_panel",
        size = { width = 0.3 },
      })
    end,
  },
}
