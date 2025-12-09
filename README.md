# nvim-lite

轻量级 Neovim 配置 - 集成 blink.cmp 和 LSP

## 特性

- **轻量级设计**: 使用 Neovim 内置包管理器，快速启动
- **现代补全**: blink.cmp 提供快速智能的代码补全
- **LSP 集成**: 原生 LSP 支持
- **UI 增强**: Catppuccin 主题 + lualine 状态栏 + tiny-inline-diagnostic

---

## 📦 LSP 安装指南

### Lua (`lua_ls`)

**用途**: Lua 语言智能补全、诊断、格式化

**安装方法**:

```bash
# Windows (scoop)
scoop install lua-language-server

# macOS (Homebrew)
brew install lua-language-server

# Linux (Ubuntu/Debian)
# 从 GitHub Releases 下载: https://github.com/LuaLS/lua-language-server/releases
```

**格式化工具** (可选):

```bash
# stylua - Lua 代码格式化
cargo install stylua
# 或
npm install -g @johnnymorganz/stylua-bin
```

---

### TypeScript / JavaScript (`vtsls`)

**用途**: TypeScript/JavaScript 智能补全、类型检查、重构

**安装方法**:

```bash
npm install -g @vtsls/language-server
```

**代码检查** (`eslint`):

```bash
# 项目本地安装（推荐）
npm install --save-dev eslint

# 或全局安装
npm install -g eslint
```

---

### Vue (`vue_ls` + `vtsls`)

**用途**: Vue 单文件组件支持，与 TypeScript 深度集成

**安装方法**:

```bash
npm install -g @vue/language-server
```

**环境变量配置** (必须):

```bash
# 找到安装路径
npm list -g @vue/language-server

# 设置环境变量 VUE_LS_PATH
# Windows (PowerShell)
$env:VUE_LS_PATH = "C:\Users\<你的用户名>\AppData\Roaming\npm\node_modules\@vue\language-server"

# macOS / Linux
export VUE_LS_PATH="/usr/local/lib/node_modules/@vue/language-server"
```

> ⚠️ 如果未设置 `VUE_LS_PATH`，打开 `.vue` 文件时会显示警告

---

### Rust (`rust_analyzer`)

**用途**: Rust 语言智能补全、诊断、内联提示

**安装方法**:

```bash
# 通过 rustup（推荐）
rustup component add rust-analyzer

# 或独立安装
# Windows (scoop)
scoop install rust-analyzer

# macOS (Homebrew)
brew install rust-analyzer
```

**格式化工具**:

```bash
# rustfmt（通常随 Rust 安装）
rustup component add rustfmt
```

---

### C / C++ (`clangd`)

**用途**: C/C++ 智能补全、诊断、代码导航

**安装方法**:

```bash
# Windows (scoop)
scoop install llvm
# clangd 包含在 LLVM 中

# macOS (Homebrew)
brew install llvm
# 或单独安装
brew install clangd

# Linux (Ubuntu/Debian)
sudo apt install clangd

# Linux (Fedora)
sudo dnf install clang-tools-extra
```

**编译数据库** (推荐):

为获得最佳体验，在项目根目录生成 `compile_commands.json`:

```bash
# CMake 项目
cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON ..

# Make 项目 (使用 Bear)
bear -- make
```

---

## 🔧 LSP 快捷键

| 按键 | 功能 |
| --- | --- |
| `K` | 悬停文档 |
| `gd` | 跳转到定义 |
| `gD` | 跳转到声明 |
| `gi` | 跳转到实现 |
| `gr` | 查找引用 |
| `gy` | 跳转到类型定义 |
| `<leader>ca` | 代码操作 |
| `<leader>cr` | 重命名符号 |
| `<leader>cf` | 格式化代码 |
| `<leader>e` | 显示诊断 |
| `<leader>ih` | 切换内联提示 |
| `<C-k>` (插入模式) | 签名帮助 |

---

## 💡 blink.cmp 补全快捷键

| 按键 | 功能 |
| --- | --- |
| `<C-space>` | 显示/隐藏补全 |
| `<CR>` | 接受补全 |
| `<Up>` / `<Down>` | 选择补全项 |
| `<C-n>` / `<C-p>` | 选择补全项 |
| `<Tab>` / `<S-Tab>` | 代码片段跳转 |
| `<C-e>` | 关闭补全 |
| `<C-Up>` / `<C-Down>` | 滚动文档 |

---

## ⌨️ 通用快捷键

Leader key: `<Space>`

### 编辑
| 按键 | 功能 |
| --- | --- |
| `<C-s>` | 保存 |
| `<C-q>` | 退出 (插入模式退出到普通模式) |
| `<C-z>` | 撤销 |
| `d` | 删除（不复制到剪贴板） |

### 窗口
| 按键 | 功能 |
| --- | --- |
| `<leader>l/j/h/k` | 分割窗口 |
| `<C-h/j/k/l>` | 窗口导航 |
| `<C-方向键>` | 调整窗口大小 |

### 标签页
| 按键 | 功能 |
| --- | --- |
| `<S-j>` / `<S-k>` | 下/上一个标签 |
| `<S-n>` | 新建标签 |
| `<S-c>` | 关闭标签 |

### 终端
| 按键 | 功能 |
| --- | --- |
| `<leader>t` | 打开终端 |
| `<Esc>` | 退出终端模式 |

---

## 📁 配置结构

```
nvim/
├── init.lua          # 主配置文件（所有配置）
└── README.md         # 本文件
```

---

## 致谢

本配置受 [tiny-nvim](https://github.com/jellydn/tiny-nvim) 项目启发。
