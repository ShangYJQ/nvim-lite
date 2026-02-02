-- auto create dir
vim.api.nvim_create_autocmd({ "BufNewFile", "BufWritePre" }, {
	pattern = "*",
	callback = function()
		local file_path = vim.fn.expand("<afile>:p:h")
		if file_path:match("^%w+://") then
			return
		end
		if vim.fn.isdirectory(file_path) == 0 then
			vim.fn.mkdir(file_path, "p")
		end
	end,
})

-- Highlight when yanking
---@diagnostic disable-next-line: param-type-mismatch
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})
