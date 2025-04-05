<h1 align="center">Welcome to my-nvim-ide 👋</h1>
<p>
  My personal neovim configuration.
</p>

<a href="https://dotfyle.com/jellydn/my-nvim-ide"><img src="https://dotfyle.com/jellydn/my-nvim-ide/badges/plugins?style=flat" /></a>
<a href="https://dotfyle.com/jellydn/my-nvim-ide"><img src="https://dotfyle.com/jellydn/my-nvim-ide/badges/leaderkey?style=flat" /></a>
<a href="https://dotfyle.com/jellydn/my-nvim-ide"><img src="https://dotfyle.com/jellydn/my-nvim-ide/badges/plugin-manager?style=flat" /></a>

[![IT Man - My Neovim IDE 2024 Version](https://i.ytimg.com/vi/MhBuhOhwGSM/hqdefault.jpg)](https://www.youtube.com/watch?v=MhBuhOhwGSM)

>[!NOTE]
> I'm switching to my new [tiny-nvim](https://github.com/jellydn/tiny-nvim) configuration for Neovim 0.11 and later versions.

## Why another neovim configuration?

I have been using Neovim for a long time and I have tried many configurations. I have learned a lot from them and I have decided to create my own configuration. This configuration is inspired by LazyVim and other configurations (kickstart.nvim, nvchad/tinyvim) and I have added my own ideas to it.

## Install Neovim

The easy way is using [MordechaiHadad/bob: A version manager for neovim](https://github.com/MordechaiHadad/bob).

```sh
bob use nightly
```

## Usage

```sh
git clone https://github.com/jellydn/my-nvim-ide.git ~/.config/nvim
```

### Try with NVIM_APPNAME

> Install requires Neovim 0.10.1+. Always review the code before installing a configuration.

Clone the repository and install the plugins:

```sh
git clone git@github.com:jellydn/my-nvim-ide ~/.config/my-nvim-ide
```

Open Neovim with this config:

```sh
NVIM_APPNAME=my-nvim-ide/ nvim
```

### Try with Docker

```sh
docker run -w /root -it --rm alpine:latest sh -uelic '
  apk add git nodejs npm neovim fzf ripgrep build-base make musl-dev go --update
  go install github.com/jesseduffield/lazygit@latest
  git clone https://github.com/jellydn/my-nvim-ide ~/.config/nvim
  nvim
  '
```

### Dynamic Configuration with `.nvim-config.lua`

This configuration allows you to dynamically enable extra plugins and languages based on project-specific settings. Here's how it works:

1. **Project-Specific Configuration File**: Create a `.nvim-config.lua` file in the root of your project directory. This file is not tracked by Git and can be used to set project-specific settings.

2. **Enable Extra Plugins and Languages**: Define which extra plugins and languages should be enabled for your project in the `.nvim-config.lua` file.

#### Example `.nvim-config.lua`

```lua
-- Enable extra plugins for this project
vim.g.enable_plugins = {
	["no-neck-pain"] = "yes",
  lspsaga = "yes"
}

-- Enable extra languages for this project
vim.g.enable_langs = {
  python = "yes"
}

-- Turn off auto start of eslint LSP, then you could run `ToggleEslint` to on/off
vim.g.lsp_eslint_enable = "no"

-- Use ts_ls for Typescript LSP
vim.g.typescript_lsp = "ts_ls"

```

## Cheatsheet

Here are the keybinding groups configured using the `which-key.nvim` plugin:

| Keybinding      | Description             |
| --------------- | ----------------------- |
| `<leader><tab>` | Tabs                    |
| `<leader>a`     | AI chat                 |
| `<leader>b`     | Buffer operations       |
| `<leader>c`     | Code actions            |
| `<leader>d`     | Debug actions           |
| `<leader>f`     | File/find operations    |
| `<leader>g`     | Git operations          |
| `<leader>o`     | Open task runner        |
| `<leader>q`     | Quit/session management |
| `<leader>r`     | Refactoring operations  |
| `<leader>s`     | Search operations       |
| `<leader>t`     | Toggle options          |
| `<leader>u`     | UI operations           |
| `<leader>w`     | Window management       |
| `<leader>x`     | Diagnostics/quickfix    |
| `[`             | Previous operations     |
| `]`             | Next operations         |
| `g`             | Goto operations         |
| `gs`            | Surround operations     |
| `z`             | Fold operations         |

For a detailed list of all keybindings, you can press `<leader>` in Neovim to bring up the `which-key` menu.

## Screenshots

[![Screenshot](https://i.gyazo.com/3134fcc6cd2a15340e10951d6a21f2c4.png)](https://gyazo.com/3134fcc6cd2a15340e10951d6a21f2c4)

[![Image from Gyazo](https://i.gyazo.com/073db438c28c8aeca19d2e6e77f696ca.gif)](https://gyazo.com/073db438c28c8aeca19d2e6e77f696ca)

## Features

- [ ] Core
  - [x] [Coding](./lua/core/coding.lua)
    - [x] Cmp for completion
    - [x] Snippets with LuaSnip
    - [x] Copilot
    - [x] Refactoring
    - [x] Ts comments
    - [x] Neogen for code annotation
    - [x] Lightbulb for code actions (VS Code like)
  - [x] [Colorscheme](./lua/core/colorscheme.lua) (Kanagaga)
  - [x] [Editor](./lua/core/editor.lua)
    - [x] Better escape with jj or jk
    - [x] Auto close buffer after 30 minutes of inactivity
    - [x] Git signs
    - [x] Tabline with bufferline
    - [x] Whichkey
    - [x] Noice
    - [x] Toggle Term
    - [x] Trouble
    - [x] Flash
    - [x] Mini icon
    - [x] Mini statusline
    - [x] Mini bufremove
    - [x] Mini surround
    - [x] Mini pairs
    - [x] Mini indent for indenting
    - [x] Edgy for layout management
    - [x] Setup Folding with conform.nvim
  - [x] [Lspconfig](./lua/core/lspconfig.lua)
    - [x] Lspconfig
    - [x] Mason
  - [x] [Treesitter](./lua/core/treesitter.lua)
    - [x] Treesitter
    - [x] Mini Cursorword
    - [x] Ts autotag
- [ ] Plugins
  - [x] Biome
  - [x] Cloak for secure .env with overlay
  - [x] conform for formatting
  - [x] copilot-chat
  - [x] dashboard
  - [x] eslint
  - [x] Fzf for file search
  - [x] hurl
  - [x] vim-jsdoc for JSDoc comments
  - [x] markdown
  - [x] nvim-lint
  - [x] nvim-notify
  - [x] oil for file explorer
  - [x] overseer to run tasks
  - [x] quick-code-runner for running code
  - [x] spectre for search and replace
  - [x] ssr for structure search and replace
  - [x] symbol-usage for symbol usage
  - [x] vimtest and neotest for running test
  - [x] tmux-navigator for tmux navigation
  - [x] treesj for join block of codes
  - [x] typecheck for Typescript type checking
  - [x] undotree for undo history
  - [x] vscode for vscode integration
  - [x] zenmode & twilight for coding in distraction free mode
- [ ] [Extras](./lua/plugins/extras)
  - [x] aerial for code navigation
  - [x] avante for AI chat
  - [x] grug-far for search and replace
  - [x] harpoon for quickly navigate between buffers
  - [x] hardtime for learning VIM motion
  - [x] lspsaga for LSP actions
  - [x] mini-hipatterns for highlighting patterns
  - [x] multicursor
  - [x] no-neck-pain for center the layout
  - [x] nvim-ufo for folding
  - [x] package-info for npm package information
  - [x] screenkey for showing key press
  - [x] snipe for quick jump between buffer
  - [x] statuscol for status color
  - [x] wakatime for tracking time

## Neovide

```toml
# .config/neovide/config.toml
fork = true # Detach from the terminal instead of waiting for the Neovide process to terminate.
frame = "buttonless" # Transparent decorations including a transparent bar.
maximized = true # Maximize the window on startup, while still having decorations and the status bar of your OS visible.
title-hidden = true
```

# Fonts

I recommend using the following repo to get a "Nerd Font" (Font that supports icons)

[getnf](https://github.com/ronniedroid/getnf)

## Uninstall

```sh
  rm -rf ~/.config/nvim
  rm -rf ~/.local/share/nvim
  rm -rf ~/.cache/nvim
  rm -rf ~/.local/state/nvim
```

# Tips

- Improve key repeat on Mac OSX, need to restart

```sh
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 14
```

- VSCode on Mac

To enable key-repeating, execute the following in your Terminal, log out and back in, and then restart VS Code:

```sh
# For VS Code
defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
# For VS Code Insider
defaults write com.microsoft.VSCodeInsiders ApplePressAndHoldEnabled -bool false
# If necessary, reset global default
defaults delete -g ApplePressAndHoldEnabled
# For Cursor
defaults write com.todesktop.230313mzl4w4u92 ApplePressAndHoldEnabled -bool false
```

Also increasing Key Repeat and Delay Until Repeat settings in System Preferences -> Keyboard.

[![Key repeat rate](https://i.gyazo.com/e58be996275fe50bee31412ea5930017.png)](https://gyazo.com/e58be996275fe50bee31412ea5930017)

- Disable `full stop with double-space` if you see the delay with `<space>-<space>`

[![Which-key](https://i.gyazo.com/6403f6c57d2e54aca230589b2173eeb0.png)](https://gyazo.com/6403f6c57d2e54aca230589b2173eeb0)

## Resources

[![IT Man - LazyVim Power User Guide](https://i.ytimg.com/vi/jveM3hZs_oI/hqdefault.jpg)](https://www.youtube.com/watch?v=jveM3hZs_oI)

[![IT Man - Talk #33 NeoVim as IDE [Vietnamese]](https://i.ytimg.com/vi/dFi8CzvqkNE/hqdefault.jpg)](https://www.youtube.com/watch?v=dFi8CzvqkNE)

[![IT Man - Talk #35 #Neovim IDE for Web Developer](https://i.ytimg.com/vi/3EbgMJ-RcWY/hqdefault.jpg)](https://www.youtube.com/watch?v=3EbgMJ-RcWY)

[![IT Man - Step-by-Step Guide: Integrating Copilot Chat with Neovim [Vietnamese]](https://i.ytimg.com/vi/By_CCai62JE/hqdefault.jpg)](https://www.youtube.com/watch?v=By_CCai62JE)

[![IT Man - Power up your Neovim with Gen.nvim](https://i.ytimg.com/vi/2nt_qcchW_8/hqdefault.jpg)](https://www.youtube.com/watch?v=2nt_qcchW_8)

[![IT Man - Boost Your Neovim Productivity with GitHub Copilot Chat](https://i.ytimg.com/vi/6oOPGaKCd_Q/hqdefault.jpg)](https://www.youtube.com/watch?v=6oOPGaKCd_Q)

[![IT Man - Get to know GitHub Copilot Chat in #Neovim and be productive IMMEDIATELY](https://i.ytimg.com/vi/sSih4khcstc/hqdefault.jpg)](https://www.youtube.com/watch?v=sSih4khcstc)

[![IT Man - Master Neovim with CopilotChat.nvim v3: Features, Demos, and Innovations](https://i.ytimg.com/vi/PfYnLcSVPh0/hqdefault.jpg)](https://www.youtube.com/watch?v=PfYnLcSVPh0)

[![IT Man - Enhance Your Neovim Experience with LSP Plugins](https://i.ytimg.com/vi/JwWNIQgL4Fk/hqdefault.jpg)](https://www.youtube.com/watch?v=JwWNIQgL4Fk)

[![IT Man - Bringing Zed AI Experience to Neovim with codecompanion.nvim](https://i.ytimg.com/vi/KbWI4ilHKv4/hqdefault.jpg)](https://www.youtube.com/watch?v=KbWI4ilHKv4)

## Show your support

Give a ⭐️ if this project helped you!
