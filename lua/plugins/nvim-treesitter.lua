-- treesitter
-- 注意：去掉了 .configs
require('nvim-treesitter').setup({
  -- 注意：新版的参数和旧版完全不同了！
  -- 详情参考文档中的“快速入门”
  install_dir = vim.fn.stdpath('data') .. '/site'
})

-- 手动安装你需要的解析器
require('nvim-treesitter').install({ "html",
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
		"rust",})
