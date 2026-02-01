-- LEADER KEY
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- EDITOR OPTIONS
local opt = vim.opt
-- Lsp servers
local lsp_servers = { "lua_ls", "rust_analyzer", "clangd", "ruff", "bashls", "jsonls" }

-- Display
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.showmode = false
opt.winborder = "rounded"

-- Line wrapping and cursor movement
opt.whichwrap = "<,>,[,],h,l"
opt.wrap = false

-- blink dot
vim.opt.list = true

vim.opt.listchars = {
    -- tab = "",
    trail = "·",
    extends = "›",
    precedes = "‹",
    -- eol = "¬",
    space = "·"
}

-- Indentation (4 spaces)
local tablen = 4
opt.tabstop = tablen
opt.softtabstop = tablen
opt.shiftwidth = tablen
opt.expandtab = true
opt.autoindent = true
vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

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

-- Search
opt.ignorecase = true
opt.smartcase = true

-- Folding via Treesitter
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldlevel = 99

vim.diagnostic.config({
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.INFO] = " ",
            [vim.diagnostic.severity.HINT] = " ",
        },
    },
})

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

-- neovide config
if vim.g.neovide then
    vim.notify("Config for neovide")
    require("neovide")
end

-- PLUGINS

-- Core plugins (no custom load callback)
vim.pack.add({
    -- Theme and UI
    { src = "https://github.com/catppuccin/nvim" },
    { src = "https://github.com/nvim-tree/nvim-web-devicons" },
    { src = "https://github.com/nvim-lualine/lualine.nvim" },
    { src = "https://github.com/nvim-mini/mini.indentscope" },
    -- LSP and diagnostics
    { src = "https://github.com/neovim/nvim-lspconfig" },
    { src = "https://github.com/rachartier/tiny-inline-diagnostic.nvim" },
    { src = "https://github.com/saghen/blink.cmp" },
    -- Formatting
    { src = "https://github.com/stevearc/conform.nvim" },

    -- Editing enhancement
    { src = "https://github.com/nvim-telescope/telescope.nvim" },
    { src = "https://github.com/nvim-lua/plenary.nvim" },

    -- cd ~/.local/share/nvim/site/pack/core/opt/blink.pairs
    -- rustup override set nightly
    -- cargo build --release
    -- cargo +nightly-2025-09-30 build --release
    { src = "https://github.com/saghen/blink.pairs" },
    { src = "https://github.com/jake-stewart/multicursor.nvim" },

    -- 需要自己编译 make
    -- cd .local/share/nvim/site/pack/core/opt/telescope-fzf-native.nvim
    -- make
    { src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim" },

    { src = "https://github.com/lewis6991/gitsigns.nvim" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter" },

})

-- PLUGIN CONFIGURATIONS

-- Catppuccin colorscheme (deferred to VimEnter for performance)
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

-- treesitter
require("nvim-treesitter.install").update("all")

require("nvim-treesitter.configs").setup({
    auto_install = true,
    ensure_installed = { "html", "css", "vim", "lua", "javascript", "typescript", "tsx", "zig", "python", "cpp", "c", "bash", "rust" },
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
})
-- gitsigns
require("gitsigns").setup()

-- Blink.cmp(autocompletion)
require("blink.cmp").setup({
    keymap = {
        preset = "enter",
        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<CR>"] = { "accept", "fallback" },
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
    fuzzy = { implementation = "prefer_rust_with_warning" },
    completion = {
        documentation = {
            auto_show = true,
            auto_show_delay_ms = 200,
        },
    },
    default = { "lsp", "path", "snippets", "buffer" },
    opts_extend = { "sources.default" },
})

-- Conform (formatting on save)
require("conform").setup({
    format_on_save = { timeout_ms = 500, lsp_format = "fallback" },
    formatters_by_ft = {
        lua = { "stylua" },
        rust = { "rustfmt", lsp_format = "fallback" },
        python = { "ruff_format" },
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

-- mini indent
require("mini.indentscope").setup {
    symbol = "│",
    draw = {
        delay = 20,
        animation = require("mini.indentscope").gen_animation.cubic(),
        priority = 2,
    },
}

-- Telescope set
require('telescope').setup {
    defaults = {
        layout_strategy = "horizontal",
        sorting_strategy = "ascending",
        layout_config = {
            prompt_position = "top",
            width = 0.9,
            height = 0.9,

            preview_width = 0.5,
        },
    },
    extensions = {
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
        }
    }
}
require("telescope").load_extension("fzf")


require("blink.pairs").setup({})

-- Tiny-inline-diagnostic (prettier diagnostic display)
require("tiny-inline-diagnostic").setup({
    preset = "modern",
    transparent_bg = true,
    transparent_cursorline = true,
})

-- KEYMAPS

local map = vim.keymap.set

-- multi cursors
local mc = require("multicursor-nvim")
mc.setup()

map({ "n", "x" }, "<S-c>", function() mc.lineAddCursor(1) end)
map({ "n", "x" }, "<leader><S-c>", function() mc.lineSkipCursor(1) end)

-- General editing
map("i", "<C-q>", "<Esc>", { desc = "Exit insert mode" })
map("n", "<C-q>", "<cmd>q<CR>", { desc = "Quit" })
map("n", "<C-Q>", "<cmd>q!<CR>", { desc = "Forced quit" })
map("n", "<C-z>", "<cmd>undo<CR>", { desc = "Undo" })
map({ "n", "v" }, "d", '"_d', { desc = "Delete to black hole register" })
map("n", "<leader>c", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

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

-- Tab navigation
map("n", "<S-n>", ":tabnew ", { desc = "New tab" })

-- Terminal
map("n", "<leader>t", function()
    vim.cmd("botright 10split | terminal")
    vim.cmd("startinsert")
end, { desc = "Open terminal" })
map("t", "<C-q>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })

-- Telescope
local builtin = require('telescope.builtin')
map('n', '<leader>f', builtin.find_files, { desc = 'Telescope find files' })
map('n', '<leader>/', builtin.live_grep, { desc = 'Telescope live grep' })
map('n', '<leader>b', builtin.buffers, { desc = 'Telescope buffers' })
map('n', '<leader>h', builtin.help_tags, { desc = 'Telescope help tags' })
map('n', '<leader>d', builtin.diagnostics, { desc = 'Telescope diagnostics' })
map('n', '<leader>s', builtin.lsp_document_symbols, { desc = 'Telescope lsp_document_symbols' })
map('n', '<leader>S', builtin.lsp_workspace_symbols, { desc = 'Telescope lsp_workspace_symbols' })

-- helix move
map("n", "gs", "0", { desc = "Move to left" })
map("n", "gl", "$", { desc = "Move to right" })

-- change x to helix mode
map("n", "x", "V", { noremap = true, silent = true })
map("v", "x", "<Esc>", { noremap = true, silent = true })

-- auto close pairs
-- map("i", "'", "''<left>")
-- map("i", "`", "``<left>")
-- map("i", '"', '""<left>')
-- map("i", "(", "()<left>")
-- map("i", "[", "[]<left>")
-- map("i", "{", "{}<left>")
-- map("i", "<", "<><left>")

-- LSP CONFIGURATION

-- LSP keymaps
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
    callback = function(event)
        local buf = event.buf
        local client = vim.lsp.get_client_by_id(event.data.client_id)

        -- add omnifunc to cmp with lsp
        vim.bo[buf].omnifunc = "v:lua.vim.lsp.omnifunc"

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
        map("n", "<leader>a", vim.lsp.buf.code_action, { buffer = buf, desc = "LSP: Code action" })
        map("n", "<leader>r", vim.lsp.buf.rename, { buffer = buf, desc = "LSP: Rename symbol" })

        -- Diagnostics
        -- map("n", "<leader>e", vim.diagnostic.open_float, { buffer = buf, desc = "LSP: Show diagnostics" })
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
        vim.lsp.enable(lsp_servers)
    end,
})
