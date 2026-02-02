--  plugins list
vim.pack.add({
	-- Theme and UI
	{ src = "https://github.com/catppuccin/nvim" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	{ src = "https://github.com/nvim-lualine/lualine.nvim" },
	{ src = "https://github.com/nvim-mini/mini.indentscope" },
	-- LSP and diagnostics
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/rachartier/tiny-inline-diagnostic.nvim" },

	-- cd ~/.local/share/nvim/site/pack/core/opt/blink.cmp
	-- rustup override set nightly
	-- cargo build --release
	-- cargo +nightly-2025-09-30 build --release

	{ src = "https://github.com/saghen/blink.cmp" },
	-- Formatting
	{ src = "https://github.com/stevearc/conform.nvim" },

	-- Editing enhancement
	{ src = "https://github.com/nvim-telescope/telescope.nvim" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/nvim-mini/mini.files" },
	{ src = "https://github.com/nvim-mini/mini.surround" },

	-- cd ~/.local/share/nvim/site/pack/core/opt/blink.pairs
	-- rustup override set nightly
	-- cargo build --release
	-- cargo +nightly-2025-09-30 build --release
	{ src = "https://github.com/saghen/blink.pairs" },
	{ src = "https://github.com/jake-stewart/multicursor.nvim" },

	-- cd .local/share/nvim/site/pack/core/opt/telescope-fzf-native.nvim
	-- make
	{ src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim" },

	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
})

require("plugins.catppuccin")
require("plugins.nvim-treesitter")
require("plugins.blink-cmp")
require("plugins.blink-pairs")
require("plugins.conform")
require("plugins.lualine")
require("plugins.gitsigns")
require("plugins.mini-surround")
require("plugins.telescope")
require("plugins.tiny-inline-diagnostics")
require("plugins.mini-files")
require("plugins.multicursor-nvim")
require("plugins.mini-indentscope")
