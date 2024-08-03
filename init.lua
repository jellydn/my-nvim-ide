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

require("lazy").setup({
  spec = {
    { import = "core.editor" },
    { import = "core.coding" },
    { import = "core.colorscheme" },
    { import = "core.lspconfig" },
    { import = "core.treesitter" },
    { import = "plugins" },
    -- Extra plugins won't be loaded by default
    -- Add the extra plugins here if needed
    -- { import = "plugins.extras.grug-far" },
    -- { import = "plugins.extras.statuscol" },
    -- { import = "plugins.extras.nvim-ufo" },
    -- { import = "plugins.extras.hardtime" },
    -- { import = "plugins.extras.mini-hipatterns" },
    { import = "langs" },
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
