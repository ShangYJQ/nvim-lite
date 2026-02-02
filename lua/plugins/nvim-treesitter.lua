-- treesitter
require("nvim-treesitter.install").update("all")

require("nvim-treesitter.configs").setup({
	auto_install = true,
	ensure_installed = {
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
		"rust",
	},
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
})
