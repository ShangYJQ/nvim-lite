local M = {}

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
	callback = function(event)
    local client = assert(vim.lsp.get_client_by_id(event.data.client_id))

    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
         vim.keymap.set('n', '<leader>h', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
        end, { buffer = event.buf, desc = 'LSP: Toggle Inlay Hints' })
    end

		vim.keymap.set("n", "gd", vim.lsp.buf.definition,  { buffer = event.buf})
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration,  { buffer = event.buf})
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation,  { buffer = event.buf})
		vim.keymap.set("n", "gr", vim.lsp.buf.references,  { buffer = event.buf})
		vim.keymap.set("n", "gy", vim.lsp.buf.type_definition,  { buffer = event.buf})
		vim.keymap.set("n", "K", vim.lsp.buf.hover,  { buffer = event.buf})
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action,  { buffer = event.buf})
		vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename,  { buffer = event.buf})
		vim.keymap.set("n", "<leader>cf", vim.lsp.buf.format,  { buffer = event.buf})
		vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help,  { buffer = event.buf})
		vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float,  { buffer = event.buf})

        vim.keymap.set("n","<leader>ld",function ()
            vim.diagnostic.open_float{source=true}
        end,{buffer=event.buf})

	vim.diagnostic.config {
        virtual_text = true,
    }

	end,
})

function M.setup()


    vim.lsp.enable('pyright')
	vim.lsp.enable('lua_ls')
	vim.lsp.enable('rust_analyzer')
	vim.lsp.enable('zls')
	vim.lsp.event('jsonls')
	vim.lsp.event('clangd')


end

return M
