# nvim-lite

轻量级 Neovim 配置 - 集成 blink.cmp 和 LSP

## 特性

### 🚀 核心功能
- **轻量级设计**: 使用 Neovim 内置包管理器，快速启动
- **现代补全**: blink.cmp 提供快速智能的代码补全
- **LSP 集成**: 原生 LSP 支持，无需 nvim-lspconfig
- **模块化配置**: 每个语言独立配置文件

### 💡 blink.cmp 补全引擎
基于 tiny-nvim 项目的理念，集成了强大的 blink.cmp 补全系统：

#### 补全源（按优先级排序）
1. **LSP** - 语言服务器补全（最高优先级）
2. **Path** - 文件路径补全
3. **Snippets** - 代码片段
4. **Buffer** - 缓冲区内容补全

#### 快捷键
- `<C-space>`: 显示/隐藏补全菜单和文档
- `<CR>`: 接受补全
- `<C-n>`/`<C-p>` 或 `<Up>`/`<Down>`: 选择补全项
- `<Tab>`/`<S-Tab>`: 代码片段跳转
- `<C-e>`: 关闭补全菜单
- `<C-Up>`/`<C-Down>`: 滚动文档

### 🔧 LSP 功能

#### 已配置的语言服务器
- **Lua** (`lua_ls`) - Lua 语言支持
- **TypeScript/JavaScript** (`ts_ls`) - TS/JS 完整支持
- **Python** (`pyright`) - Python 语言支持
- **Go** (`gopls`) - Go 语言支持
- **Rust** (`rust_analyzer`) - Rust 语言支持
- **C/C++** (`clangd`) - C/C++ 支持
- **Zig** (`zls`) - Zig 语言支持
- 更多语言配置在 `lsp/` 目录中

#### LSP 快捷键
- `K` 或 `<leader>k`: 显示悬停文档
- `gd`: 跳转到定义
- `gD`: 跳转到声明
- `gi`: 跳转到实现
- `gr`: 查找引用
- `gy`: 跳转到类型定义
- `<leader>ca` 或 `<leader>.`: 代码操作
- `<leader>cr`: 重命名
- `<leader>cf`: 格式化代码
- `[d`/`]d`: 上/下一个诊断
- `<leader>e`: 显示诊断浮窗
- `<leader>q`: 诊断列表

### 📦 安装语言服务器

语言服务器需要单独安装，推荐方法：

```bash
# Lua
# Windows: scoop install lua-language-server
# Mac: brew install lua-language-server
# Linux: 从 GitHub releases 下载

# TypeScript/JavaScript
npm install -g typescript-language-server typescript

# Python
pip install pyright

# Go
go install golang.org/x/tools/gopls@latest

# Rust
rustup component add rust-analyzer

# C/C++
# Windows: scoop install llvm (包含 clangd)
# Mac: brew install llvm
# Linux: apt install clangd

# Zig
# 从 https://github.com/zigtools/zls 下载
```

### 🎨 UI 增强
- **主题**: Catppuccin Mocha（透明背景）
- **状态栏**: lualine 提供美观的状态信息
- **图标**: Nerd Font 图标支持
- **诊断**: 清晰的错误和警告显示

### ⚡ 性能优化
- 使用纯 Lua 实现的 fuzzy 匹配（避免二进制依赖）
- 延迟加载 LSP（首次打开文件时启动）
- 智能的补全触发和限制
- 优化的 Treesitter 配置

## 配置结构

```
nvim/
├── init.lua          # 主配置文件
├── lsp.lua           # LSP 主模块
├── lsp/              # 语言配置目录
│   ├── lua.lua       # Lua LSP 配置
│   ├── python.lua    # Python LSP 配置
│   ├── typescript.lua # TypeScript LSP 配置
│   └── ...           # 其他语言配置
└── README.md         # 本文件
```

## 添加新语言支持

在 `lsp/` 目录创建新文件，例如 `lsp/rust.lua`：

```lua
return {
    cmd = { "rust-analyzer" },
    filetypes = { "rust" },
    root_markers = { "Cargo.toml", ".git" },
    settings = {
        -- 语言特定设置
    },
}
```

文件名将自动映射到对应的 LSP 服务器名称。

## 基础键位映射

Leader key: `<Space>`

### 通用
| 按键 | 模式 | 功能 |
| --- | --- | --- |
| `<C-q>` | 插入/普通 | 退出/退出插入模式 |
| `<C-s>` | 普通 | 保存文件 |
| `<C-z>` | 普通 | 撤销 |
| `d` | 普通/可视 | 删除（不复制） |

### 窗口管理
| 按键 | 功能 |
| --- | --- |
| `<leader>l/j/h/k` | 分割窗口（右/下/左/上） |
| `<C-h/j/k/l>` | 窗口导航 |
| `<C-方向键>` | 调整窗口大小 |

### 终端
| 按键 | 功能 |
| --- | --- |
| `<leader>t` | 打开终端 |
| `<Esc>` | 退出终端模式 |

## 致谢

本配置受 [tiny-nvim](https://github.com/jellydn/tiny-nvim) 项目启发，
采用了其先进的配置理念和 blink.cmp 集成方案。
