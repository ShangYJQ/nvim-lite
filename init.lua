if vim.g.neovide then
	vim.notify("Config for neovide")
	require("neovide")
end

-- LEADER KEY
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- EDITOR OPTIONS
local opt = vim.opt
-- Display
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.showmode = false
opt.winborder = "rounded"

-- Line wrapping and cursor movement
opt.whichwrap = "<,>,[,],h,l"
opt.wrap = false

-- Indentation (4 spaces)
local tablen = 4
opt.tabstop = tablen
opt.softtabstop = tablen
opt.shiftwidth = tablen
opt.expandtab = true
opt.autoindent = true

-- Clipboard (disable for SSH sessions)
opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus"

-- Window splits
opt.splitright = true
opt.splitbelow = true

-- Scrolling
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.smoothscroll = true

-- Persistent undo
local undodir = vim.fn.stdpath("data") .. "/undodir"
if vim.fn.isdirectory(undodir) == 0 then
	vim.fn.mkdir(undodir, "p")
end
opt.undodir = undodir
opt.undofile = true

-- Search (smart case-sensitivity)
opt.ignorecase = true
opt.smartcase = true

-- Folding via Treesitter
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldlevel = 99

-- netrw
vim.g.netrw_liststyle = 1 -- Use the long listing view
vim.g.netrw_sort_by = "size" -- Sort files by size
vim.g.netrw_winsize = 30
vim.g.netrw_liststyle = 3
vim.g.netrw_banner = 0
vim.g.netrw_localcopydircmd = "cp -r"

-- PLUGINS

-- Core plugins (no custom load callback)
vim.pack.add({
	-- Theme and UI
	{ src = "https://github.com/catppuccin/nvim" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	{ src = "https://github.com/nvim-lualine/lualine.nvim" },
	-- LSP and diagnostics
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/rachartier/tiny-inline-diagnostic.nvim" },
	-- { src = "https://github.com/saghen/blink.cmp" },
	-- Formatting
	{ src = "https://github.com/stevearc/conform.nvim" },
	-- Editing enhancement
	{ src = "https://github.com/echasnovski/mini.pairs" },
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
})

-- PLUGIN CONFIGURATIONS

-- Catppuccin colorscheme (deferred to VimEnter for performance)
vim.api.nvim_create_autocmd("VimEnter", {
	once = true,
	callback = function()
		require("catppuccin").setup({
			flavour = "mocha",
			transparent_background = not vim.g.neovide,
			float = { transparent = false, solid = false },
		})
		vim.cmd("colorscheme catppuccin")
	end,
})

-- Mini.pairs (auto-pairing brackets/quotes)
require("mini.pairs").setup({
	modes = { insert = true, command = true, terminal = false },
	skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
	skip_ts = { "string" },
	skip_unbalanced = true,
	markdown = true,
})

-- gitsigns
require("gitsigns").setup()

-- Blink.cmp (autocompletion)
-- require("blink.cmp").setup({
-- 	keymap = {
-- 		preset = "enter",
-- 		["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
-- 		["<CR>"] = { "accept", "fallback" },
-- 		["<C-Down>"] = { "scroll_documentation_down", "fallback" },
-- 		["<C-Up>"] = { "scroll_documentation_up", "fallback" },
-- 		["<Tab>"] = { "snippet_forward", "fallback" },
-- 		["<S-Tab>"] = { "snippet_backward", "fallback" },
-- 		["<Up>"] = { "select_prev", "fallback" },
-- 		["<Down>"] = { "select_next", "fallback" },
-- 		["<C-n>"] = { "select_next", "fallback" },
-- 		["<C-p>"] = { "select_prev", "fallback" },
-- 		["<C-e>"] = { "hide", "fallback" },
-- 	},
-- 	fuzzy = { implementation = "prefer_rust_with_warning" },
-- 	appearance = {
-- 		use_nvim_cmp_as_default = true,
-- 		nerd_font_variant = "normal",
-- 	},
--
-- 	completion = {
-- 		documentation = {
-- 			auto_show = true,
-- 			auto_show_delay_ms = 200,
-- 		},
-- 	},
--
-- 	cmdline = {
-- 		keymap = {
-- 			preset = "inherit",
-- 			["<CR>"] = { "accept_and_enter", "fallback" },
-- 		},
-- 	},
-- 	default = { "lsp", "path", "snippets", "buffer" },
-- 	opts_extend = { "sources.default" },
-- })

-- Conform (formatting on save)
require("conform").setup({
	formatters = {
		clang_format = {
			prepend_args = { "--style={IndentWidth: 4, TabWidth: 4, UseTab: Never}" },
		},
	},
	format_on_save = { timeout_ms = 500, lsp_format = "fallback" },
	formatters_by_ft = {
		lua = { "stylua" },
		rust = { "rustfmt", lsp_format = "fallback" },
	},
})

-- Lualine (statusline)
require("lualine").setup({
	options = {
		icons_enabled = true,
		theme = "auto",
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		disabled_filetypes = {
			statusline = {},
			winbar = {},
		},
		ignore_focus = {},
		always_divide_middle = true,
		always_show_tabline = true,
		globalstatus = true,
		refresh = {
			statusline = 100,
			tabline = 100,
			winbar = 100,
		},
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch", "diff" },
		lualine_c = {
			{
				"diagnostics",
				symbols = {
					error = " ",
					warn = " ",
					info = " ",
					hint = " ",
				},
			},
			{ "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
			"filename",
		},
		lualine_x = {
			{
				function()
					local clients = vim.lsp.get_clients({ bufnr = 0 })
					if #clients == 0 then
						return ""
					end
					local names = {}
					for _, c in ipairs(clients) do
						table.insert(names, c.name)
					end
					return " " .. table.concat(names, ", ")
				end,
			},
			"encoding",
			"fileformat",
			"progress",
		},
		lualine_y = { "location" },
		lualine_z = {
			function()
				return " " .. os.date("%R")
			end,
		},
	},
})

-- Tiny-inline-diagnostic (prettier diagnostic display)
require("tiny-inline-diagnostic").setup({
	preset = "modern",
	transparent_bg = true,
	transparent_cursorline = true,
})

-- KEYMAPS

local map = vim.keymap.set

-- General editing
map("i", "<C-q>", "<Esc>", { desc = "Exit insert mode" })
map("n", "<C-q>", "<cmd>q<CR>", { desc = "Quit" })
map("n", "<C-Q>", "<cmd>q!<CR>", { desc = "Forced quit" })
map("n", "<C-z>", "<cmd>undo<CR>", { desc = "Undo" })
map({ "n", "v" }, "d", '"_d', { desc = "Delete to black hole register" })
map("n", "<leader>h", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Window navigation (Ctrl + hjkl)
map("n", "<C-h>", "<C-w>h", { desc = "Focus left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Focus below window" })
map("n", "<C-k>", "<C-w>k", { desc = "Focus above window" })
map("n", "<C-l>", "<C-w>l", { desc = "Focus right window" })

-- Window splitting (leader + hjkl)
map("n", "<leader>l", "<cmd>set splitright<CR><cmd>vsplit<CR>", { desc = "Split right" })
map("n", "<leader>j", "<cmd>set splitbelow<CR><cmd>split<CR>", { desc = "Split below" })
map("n", "<leader>h", "<cmd>set nosplitright<CR><cmd>vsplit<CR><cmd>set splitright<CR>", { desc = "Split left" })
map("n", "<leader>k", "<cmd>set nosplitbelow<CR><cmd>split<CR><cmd>set splitbelow<CR>", { desc = "Split above" })

-- Window resizing (Ctrl + arrows)
map("n", "<C-Up>", "<cmd>resize -2<CR>", { desc = "Decrease height" })
map("n", "<C-Down>", "<cmd>resize +2<CR>", { desc = "Increase height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Decrease width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase width" })

-- Tab navigation (Shift + jk)
map("n", "<S-j>", "gt", { desc = "Next tab" })
map("n", "<S-k>", "gT", { desc = "Previous tab" })
map("n", "<S-n>", ":tabnew ", { desc = "New tab" })
map("n", "<S-c>", "<cmd>tabclose<CR>", { desc = "Close tab" })

map("n", "<Leader>e", "<cmd>Lexplore<CR>", { desc = "netrw explore" })

-- Terminal
map("n", "<leader>t", function()
	vim.cmd("botright 10split | terminal")
end, { desc = "Open terminal" })
map("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })

-- LSP CONFIGURATION

-- LSP keymaps (attached per buffer)
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
	callback = function(event)
		local buf = event.buf
		local client = vim.lsp.get_client_by_id(event.data.client_id)

		-- Toggle inlay hints if supported
		if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
			map("n", "<leader>ih", function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = buf }))
			end, { buffer = buf, desc = "LSP: Toggle inlay hints" })
		end

		-- Navigation
		map("n", "gd", vim.lsp.buf.definition, { buffer = buf, desc = "LSP: Go to definition" })
		map("n", "gD", vim.lsp.buf.declaration, { buffer = buf, desc = "LSP: Go to declaration" })
		map("n", "gi", vim.lsp.buf.implementation, { buffer = buf, desc = "LSP: Go to implementation" })
		map("n", "gr", vim.lsp.buf.references, { buffer = buf, desc = "LSP: Find references" })
		map("n", "gy", vim.lsp.buf.type_definition, { buffer = buf, desc = "LSP: Go to type definition" })

		-- Documentation and help
		map("n", "K", vim.lsp.buf.hover, { buffer = buf, desc = "LSP: Hover documentation" })
		map("i", "<C-k>", vim.lsp.buf.signature_help, { buffer = buf, desc = "LSP: Signature help" })

		-- Code actions
		map("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = buf, desc = "LSP: Code action" })
		map("n", "<leader>cr", vim.lsp.buf.rename, { buffer = buf, desc = "LSP: Rename symbol" })
		map("n", "<leader>cf", vim.lsp.buf.format, { buffer = buf, desc = "LSP: Format buffer" })

		-- Diagnostics
		map("n", "<leader>e", vim.diagnostic.open_float, { buffer = buf, desc = "LSP: Show diagnostics" })
		map("n", "<leader>ld", function()
			vim.diagnostic.open_float({ source = true })
		end, { buffer = buf, desc = "LSP: Show diagnostics with source" })

		-- Override diagnostic float with tiny-inline-diagnostic
		vim.diagnostic.open_float = require("tiny-inline-diagnostic.override").open_float
	end,
})

-- Lazy load LSP on first buffer read
vim.api.nvim_create_autocmd("BufReadPost", {
	once = true,
	callback = function()
		-- for vue_ls: read from VUE_LS_PATH env
		-- run npm list -g @vue/language-server to find path
		-- local vue_language_server_path = vim.env.VUE_LS_PATH
		-- if vue_language_server_path then
		-- 	local vue_plugin = {
		-- 		name = "@vue/typescript-plugin",
		-- 		location = vue_language_server_path,
		-- 		languages = { "vue" },
		-- 		configNamespace = "typescript",
		-- 		enableForWorkspaceTypeScriptVersions = true,
		-- 	}
		-- 	vim.lsp.config("vtsls", {
		-- 		filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
		-- 		settings = {
		-- 			vtsls = {
		-- 				tsserver = {
		-- 					globalPlugins = {
		-- 						vue_plugin,
		-- 					},
		-- 				},
		-- 			},
		-- 		},
		-- 	})
		-- 	vim.lsp.enable("vue_ls")
		-- end
		vim.lsp.enable("lua_ls")
		vim.lsp.enable("rust_analyzer")
		vim.lsp.enable("clangd")
		-- vim.lsp.enable("eslint")
		-- vim.lsp.enable("vtsls")
	end,
})

-- Notify if VUE_LS_PATH is not set when opening .vue files
-- vim.api.nvim_create_autocmd("BufReadPost", {
-- 	pattern = "*.vue",
-- 	callback = function()
-- 		if not vim.env.VUE_LS_PATH then
-- 			vim.notify(
-- 				"VUE_LS_PATH environment variable is not set. Vue LSP will not work.\nRun `npm list -g @vue/language-server` to find the path.",
-- 				vim.log.levels.WARN
-- 			)
-- 		end
-- 	end,
-- })
