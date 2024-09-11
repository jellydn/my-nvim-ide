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

local enable_plugins = vim.g.enable_plugins or {}

--- Import extra plugins if enabled
---@param plugin_name string
local function load_optional_plugin(plugin_name)
  return enable_plugins[plugin_name] == "yes" and { import = "plugins.extras." .. plugin_name } or nil
end

require("lazy").setup({
  spec = {
    { import = "core.editor" },
    { import = "core.coding" },
    { import = "core.colorscheme" },
    { import = "core.lspconfig" },
    { import = "core.treesitter" },
    { import = "plugins" },
    { import = "langs" },
    -- Extra plugins won't be loaded by default
    -- Add the extra plugins here if needed
    load_optional_plugin("lspsaga"),
    load_optional_plugin("no-neck-pain"),
    load_optional_plugin("wakatime"),
    load_optional_plugin("snipe"),
    load_optional_plugin("mini-hipatterns"),
    load_optional_plugin("aerial"),
    load_optional_plugin("multicursor"),
    load_optional_plugin("avante"),
    load_optional_plugin("package-info"),
    load_optional_plugin("grug-far"),
    load_optional_plugin("screenkey"),
    load_optional_plugin("statuscol"),
    load_optional_plugin("nvim-ufo"),
    load_optional_plugin("hardtime"),
    load_optional_plugin("harpoon"),
    -- Extra languages won't be loaded by default
    -- { import = "langs.extras.ruby" },
    -- { import = "langs.extras.swift" },
  },
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
