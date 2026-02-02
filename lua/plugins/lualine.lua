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
