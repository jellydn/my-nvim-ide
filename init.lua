-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("config.lazy").load("options")

if vim.g.deprecation_warnings == false then
  vim.deprecate = function() end
end

-- Load project setting if available, e.g: .nvim-config.lua
-- This file is not tracked by git
-- It can be used to set project specific settings
local project_setting = vim.fn.getcwd() .. "/.nvim-config.lua"
-- Check if the file exists and load it
if vim.loop.fs_stat(project_setting) then
  -- Read the file and run it with pcall to catch any errors
  local ok, err = pcall(dofile, project_setting)
  if not ok then
    vim.notify("Error loading project setting: " .. err, vim.log.levels.ERROR)
  end
end

local enable_extra_plugins = vim.g.enable_plugins
  or {
    lspsaga = "yes",
    ["no-neck-pain"] = "yes",
    wakatime = "no",
    harpoon = "no",
  }

local enable_extra_langs = vim.g.enable_langs or {
  go = "yes",
  rust = "yes",
  python = "no",
  ruby = "no",
}

-- Core spec
local spec = {
  { import = "core.editor" },
  { import = "core.coding" },
  { import = "core.colorscheme" },
  { import = "core.lspconfig" },
  { import = "core.treesitter" },
  { import = "plugins" },
  { import = "langs" },
}

-- Enable extra plugins and languages
for plugin_name, enabled in pairs(enable_extra_plugins) do
  if enabled == "yes" then
    table.insert(spec, { import = "plugins.extras." .. plugin_name })
  end
end
for lang_name, enabled in pairs(enable_extra_langs) do
  if enabled == "yes" then
    table.insert(spec, { import = "langs.extras." .. lang_name })
  end
end

require("lazy").setup({
  spec = spec,
  checker = { enabled = true }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

-- Do not set colorscheme if using vscode
require("config.lazy").setup(not vim.g.vscode and require("themer").selectColorSchemeByTime() or "")
