local ts = require("nvim-treesitter")

ts.setup({
	install_dir = vim.fn.stdpath("data") .. "/site",
})

-- 安装解析器
ts.install({
	"html",
	"css",
	"vim",
	"lua",
	"javascript",
	"typescript",
	"tsx",
	"zig",
	"python",
	"cpp",
	"c",
	"bash",
	"make",
	"markdown",
	"rust",
	"json",
	"toml",
	"cmake",
	"git_config",
	"git_rebase",
	"gitcommit",
	"gitignore",
	"zsh",
	"latex",
	"yaml",
})

-- 自动启用ts高亮
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("TSHighlight", { clear = true }),
	callback = function(ev)
		local ignore = { "checkhealth", "lazy", "vim", "help" }
		if vim.tbl_contains(ignore, vim.bo[ev.buf].filetype) then
			return
		end
		pcall(vim.treesitter.start, ev.buf)
	end,
})
