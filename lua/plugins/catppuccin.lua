-- Catppuccin colorscheme
vim.api.nvim_create_autocmd("VimEnter", {
	once = true,
	callback = function()
		require("catppuccin").setup({
			integrations = {
				gitsigns = true,
			},
			flavour = "mocha",
			-- transparent_background = not vim.g.neovide,
			float = { transparent = false, solid = false },
			term_colors = true,
		})
		vim.cmd("colorscheme catppuccin")
	end,
})
