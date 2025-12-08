# Neovim Configuration

A minimal and clean Neovim configuration using the built-in `vim.pack` plugin manager (Neovim 0.12+).

## Requirements

- **Neovim** >= 0.12 (for `vim.pack` support)
- **Git** (for plugin installation)
- A [Nerd Font](https://www.nerdfonts.com/) (for icons)

## Features

- **Single-file configuration** – everything lives in `init.lua`
- **Built-in plugin manager** – uses native `vim.pack` API
- **Catppuccin Mocha** theme with transparent background
- **Treesitter** syntax highlighting and folding
- **Lualine** statusline with git and diagnostics info
- **Auto pairs** via mini.pairs

## Plugins

| Plugin                                                                | Description                   |
| --------------------------------------------------------------------- | ----------------------------- |
| [catppuccin/nvim](https://github.com/catppuccin/nvim)                 | Colorscheme                   |
| [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons)   | File icons                    |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Syntax highlighting & folding |
| [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)          | Statusline                    |
| [mini.pairs](https://github.com/echasnovski/mini.pairs)               | Auto pairs                    |

## Keymaps

Leader key: `<Space>`

### General

| Key     | Mode          | Action                 |
| ------- | ------------- | ---------------------- |
| `<C-q>` | Insert        | Escape to Normal mode  |
| `<C-q>` | Normal        | Quit without saving    |
| `<C-s>` | Normal        | Save file              |
| `<C-z>` | Normal        | Undo                   |
| `d`     | Normal/Visual | Delete without yanking |

### Window Management

| Key         | Mode   | Action                 |
| ----------- | ------ | ---------------------- |
| `<leader>l` | Normal | Split window right     |
| `<leader>j` | Normal | Split window below     |
| `<leader>h` | Normal | Split window left      |
| `<leader>k` | Normal | Split window above     |
| `<C-h>`     | Normal | Move to left window    |
| `<C-j>`     | Normal | Move to window below   |
| `<C-k>`     | Normal | Move to window above   |
| `<C-l>`     | Normal | Move to right window   |
| `<C-Up>`    | Normal | Decrease window height |
| `<C-Down>`  | Normal | Increase window height |
| `<C-Left>`  | Normal | Decrease window width  |
| `<C-Right>` | Normal | Increase window width  |

### Terminal

| Key         | Mode     | Action                  |
| ----------- | -------- | ----------------------- |
| `<leader>t` | Normal   | Open terminal at bottom |
| `<Esc>`     | Terminal | Exit terminal mode      |

## Editor Settings

- **Line numbers**: Relative
- **Indentation**: 4 spaces (expandtab)
- **Search**: Case-insensitive (smart case enabled)
- **Folding**: Treesitter-based expressions
- **Persistent undo**: Enabled (stored in `~/.local/share/nvim/undodir`)
- **Scroll offset**: 8 lines vertical, 8 columns horizontal
- **Smooth scrolling**: Enabled
- **Window border**: Rounded

## Treesitter Languages

Pre-configured parsers:
`lua`, `python`, `json`, `vim`, `markdown`, `cpp`, `c`, `rust`, `bash`, `javascript`, `typescript`, `yaml`, `zig`

## Installation

```bash
# Linux/macOS
git clone https://github.com/ShangYJQ/nvim-lite.git ~/.config/nvim
```

```bash
# Windows (PowerShell)
git clone https://github.com/ShangYJQ/nvim-lite.git $env:LOCALAPPDATA\nvim
```

Start Neovim – plugins will be installed automatically.
