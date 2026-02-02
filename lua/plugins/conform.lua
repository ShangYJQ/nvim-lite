-- Conform (formatting on save)
require("conform").setup({
	format_on_save = { timeout_ms = 500, lsp_format = "fallback" },
	formatters_by_ft = {
		lua = { "stylua" },
		rust = { "rustfmt", lsp_format = "fallback" },
		python = { "ruff_format" },
	},
})
