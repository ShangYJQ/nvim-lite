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
})

vim.pack.add({
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
}, {
	load = function(plug_data)
		vim.api.nvim_create_autocmd("BufReadPre", {
			once = true,
			callback = function()
				vim.opt.runtimepath:append(plug_data.path)
				---@diagnostic disable-next-line: missing-fields
				require("nvim-treesitter.configs").setup({
					ensure_installed = {
						"lua",
						"python",
						"json",
						"vim",
						"markdown",
						"cpp",
						"c",
						"rust",
						"bash",
						"javascript",
						"typescript",
						"yaml",
						"zig",
					},
					highlight = { enable = true },
					indent = { enable = true },
				})
			end,
		})
	end,
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
							if #clients == 0 then return "" end
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

vim.pack.add({
	{ src = "https://github.com/rafamadriz/friendly-snippets" },
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

				-- 添加更多导航键
				["<C-n>"] = { "select_next", "fallback" },
				["<C-p>"] = { "select_prev", "fallback" },
				["<C-e>"] = { "hide", "fallback" },
			},
		})
	end,
})

-- keymaps
vim.keymap.set("i", "<C-q>", "<Esc>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-q>", ":q!<CR>", { noremap = true, silent = true })
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

-- terminal
vim.keymap.set("n", "<leader>t", function()
	vim.cmd("botright 10split | terminal")
end, { desc = "open terminal" })

vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "quit terminal" })

-- lsp lazy boot
vim.api.nvim_create_autocmd("BufReadPost", {
	once = true,
	callback = function(e)
		require("lsp").setup()
	end,
})
