local opt = vim.opt
local tablen = 4

vim.g.mapleader = " "
vim.g.maplocalleader = " "

opt.number = true

opt.relativenumber = true

opt.whichwrap = "<,>,[,],h,l"
opt.wrap = false

opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = tablen
opt.expandtab = true
opt.autoindent = true

opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus"

vim.opt.splitright = true
vim.opt.splitbelow = true

opt.scrolloff = 8
opt.sidescrolloff = 8

opt.showmode = false

opt.cursorline = true

opt.smoothscroll = true

local undodir = vim.fn.stdpath("data") .. "/undodir"

if vim.fn.isdirectory(undodir) == 0 then
	vim.fn.mkdir(undodir, "p")
end

opt.undodir = undodir
opt.undofile = true

opt.shadafile = "NONE"

vim.opt.winborder = "rounded"

opt.ignorecase = true
opt.smartcase = true

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevel = 99

-- neovim plugins
vim.pack.add({
	{ src = "https://github.com/catppuccin/nvim" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/rachartier/tiny-inline-diagnostic.nvim" },
	{ src = "https://github.com/stevearc/conform.nvim" },
	{ src = "https://github.com/rafamadriz/friendly-snippets" },
})

vim.pack.add({
	{ src = "https://github.com/nvim-lualine/lualine.nvim" },
}, {
	load = function(plug_data)
		vim.opt.runtimepath:append(plug_data.path)

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
	end,
})

vim.api.nvim_create_autocmd("VimEnter", {
	once = true,
	callback = function()
		require("catppuccin").setup({
			flavour = "mocha",
			transparent_background = true,
			float = {
				transparent = false,
				solid = false,
			},
		})
		vim.cmd("colorscheme catppuccin")
	end,
})

vim.pack.add({
	{ src = "https://github.com/echasnovski/mini.pairs" },
}, {
	load = function(plug_data)
		vim.opt.runtimepath:append(plug_data.path)
		require("mini.pairs").setup({
			modes = { insert = true, command = true, terminal = false },
			skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
			skip_ts = { "string" },
			skip_unbalanced = true,
			markdown = true,
		})
	end,
})

-- blink.cmp
vim.pack.add({
	{ src = "https://github.com/saghen/blink.cmp" },
}, {
	load = function(plug_data)
		vim.opt.runtimepath:append(plug_data.path)
		require("blink.cmp").setup({
			fuzzy = {
				implementation = "lua",
			},

			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
				providers = {
					lsp = { score_offset = 100 },
					path = { score_offset = 50 },
					snippets = { score_offset = 0 },
					buffer = { score_offset = -50 },
				},
			},

			keymap = {
				preset = "none",

				["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
				["<cr>"] = { "accept", "fallback" },

				["<C-Down>"] = { "scroll_documentation_down", "fallback" },
				["<C-Up>"] = { "scroll_documentation_up", "fallback" },

				["<Tab>"] = { "snippet_forward", "fallback" },
				["<S-Tab>"] = { "snippet_backward", "fallback" },

				["<Up>"] = { "select_prev", "fallback" },
				["<Down>"] = { "select_next", "fallback" },

				["<C-n>"] = { "select_next", "fallback" },
				["<C-p>"] = { "select_prev", "fallback" },
				["<C-e>"] = { "hide", "fallback" },
			},
		})
	end,
})

-- conform
require("conform").setup({
	format_on_save = {
		timeout_ms = 500,
		lsp_format = "fallback",
	},
	formatters_by_ft = {
		lua = { "stylua" },
		rust = { "rustfmt", lsp_format = "fallback" },
	},
})

-- keymaps
vim.keymap.set("i", "<C-q>", "<Esc>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-q>", ":q<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-s>", ":w<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-z>", ":undo<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "d", '"_d', { noremap = true, silent = true })
vim.keymap.set("v", "d", '"_d', { noremap = true, silent = true })

vim.keymap.set("n", "<leader>h", "<cmd>nohlsearch<cr>", { desc = "close search highlight" })

vim.keymap.set("n", "<leader>l", ":set splitright<CR>:vsplit<CR>")
vim.keymap.set("n", "<leader>j", ":set splitbelow<CR>:split<CR>")
vim.keymap.set("n", "<leader>h", ":set nosplitright<CR>:vsplit<CR>:set splitright<CR>")
vim.keymap.set("n", "<leader>k", ":set nosplitbelow<CR>:split<CR>:set splitbelow<CR>")

vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "left" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "down" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "up" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "right" })

vim.keymap.set("n", "<C-Up>", ":resize -2<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-Down>", ":resize +2<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "<S-j>", "gt", { noremap = true, silent = true })
vim.keymap.set("n", "<S-k>", "gT", { noremap = true, silent = true })
vim.keymap.set("n", "<S-n>", ":tabnew ", { noremap = true, silent = true })
vim.keymap.set("n", "<S-c>", "<cmd>tabclose<cr>", { noremap = true, silent = true })

vim.keymap.set("n", "<leader>t", function()
	vim.cmd("botright 10split | terminal")
end, { desc = "open terminal" })

vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "quit terminal" })

-- lsp keymaps
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
	callback = function(event)
		local client = assert(vim.lsp.get_client_by_id(event.data.client_id))

		if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
			vim.keymap.set("n", "<leader>h", function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
			end, { buffer = event.buf, desc = "LSP: Toggle Inlay Hints" })
		end

		vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = event.buf })
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = event.buf })
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = event.buf })
		vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = event.buf })
		vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, { buffer = event.buf })
		vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = event.buf })
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = event.buf })
		vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { buffer = event.buf })
		vim.keymap.set("n", "<leader>cf", vim.lsp.buf.format, { buffer = event.buf })
		vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, { buffer = event.buf })
		vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { buffer = event.buf })

		vim.keymap.set("n", "<leader>ld", function()
			vim.diagnostic.open_float({ source = true })
		end, { buffer = event.buf })

		vim.diagnostic.open_float = require("tiny-inline-diagnostic.override").open_float
	end,
})

require("tiny-inline-diagnostic").setup({
	preset = "modern",
	transparent_bg = true,
	transparent_cursorline = true,
})

-- lsp lazy boot
vim.api.nvim_create_autocmd("BufReadPost", {
	once = true,
	callback = function()
		vim.lsp.enable("lua_ls")
	end,
})
