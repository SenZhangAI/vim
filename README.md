## sen's vim config

个人 Vim/Neovim 配置：

- **Neovim (0.11+)** — 主力编辑器。Lua 配置，lazy.nvim 插件管理，定位文档阅读 + 快速修改（代码交给 Claude 写），Treesitter + snacks.nvim + 只读 LSP 导航
- **Vim** — 只保留共享基础设置，不装插件（临时改文件 / ssh 场景）

支持语言：C/C++、Rust、Python、Go、Java、Lua、Markdown

灵感来自 [skywind3000/vim](https://github.com/skywind3000/vim)

## 安装

```bash
# 建议先升级 Neovim 到 0.10+
brew upgrade neovim

# 安装配置
./install.sh   # 自动检测 nvim/vim，安装依赖和 Nerd Font
```

首次启动 Neovim 会自动通过 lazy.nvim 安装所有插件。Mason 会自动下载 LSP 服务器（clangd, rust_analyzer, pyright, jdtls, lua_ls）。

## 架构

通过 `vimrc` 路由：

```
vimrc → import.vim → include/*.vim (共享配置)
     ├─ has('nvim') → lua/config/   → lazy.nvim + Lua 插件
     └─ else        → 只加载配色，不装插件
```

### 共享配置 (`include/`)

| 文件 | 说明 |
|------|------|
| `general.vim` | 编辑器默认值（4空格缩进、外部修改自动重载、持久撤销、去除尾部空白） |
| `keymaps.vim` | Leader 键 `,`，`jk`=ESC，Alt-j/k 移动行，方向键切换缓冲区 |
| `ignores.vim` | wildignore 文件忽略模式 |

### Neovim 路径 (`lua/`)

```
lua/config/
  init.lua       → 入口：加载 options, lazy, keymaps
  options.lua    → Neovim 专属选项（inccommand, termguicolors 等）
  keymaps.lua    → 诊断导航、quickfix 切换、终端切换(Ctrl-j)、bracket 导航
  lazy.lua       → lazy.nvim 引导（插件目录 ~/.vim/lazy/）

lua/plugins/
  colorscheme.lua → solarized.nvim 配色
  treesitter.lua  → 语法高亮 + 文本对象
  snacks.lua      → snacks.nvim: picker, dashboard, notifier, indent, input, bigfile, words
  lsp.lua         → lspconfig (只做导航, 启用 PATH 中已有的服务器) + mason (手动)
  markdown.lua    → render-markdown.nvim
  ui.lua          → lualine, bufferline, nvim-tree, which-key
  editor.lua      → surround, flash, easy-align, undotree,
                    rainbow-delimiters, todo-comments
  git.lua         → gitsigns, fugitive
```

### Vim 路径

刻意不装插件：只有 `include/*.vim` 共享设置 + `NeoSolarized` 配色。原来的 vim-plug + CoC 已移除，避免同时维护两套 LSP。

## 核心快捷键

| 按键 | 功能 | VS Code 对应 |
|------|------|-------------|
| `Ctrl-p` | 搜索文件 | `Cmd+P` |
| `Ctrl-b` | 开关文件树 | `Cmd+B` |
| `Ctrl-j` | 开关终端 | `Cmd+J` |
| `,f` | 全文搜索 | `Cmd+Shift+F` |
| `<Space>c` | 命令列表 | `Cmd+Shift+P` |
| `F2` / `,rn` | 重命名符号 | `F2` |
| `,ac` | 代码操作 | `Cmd+.` |
| `gd` | 跳转到定义 | — |
| `gr` | 查看引用 | — |
| `K` | 悬浮文档 | — |
| `s` | Flash 快速跳转 | — |

完整快捷键参考和使用技巧见 [USAGE.md](USAGE.md)。

## 插件列表

<details>
<summary>展开查看全部插件</summary>

| 插件 | 用途 |
|------|------|
| solarized.nvim | 配色方案 |
| snacks.nvim | 模糊搜索、启动界面、通知、缩进线、输入框、大文件优化 |
| nvim-treesitter | 语法高亮 + 文本对象 |
| render-markdown.nvim | Markdown 渲染 |
| nvim-lspconfig + mason | LSP 导航 (服务器手动安装) |
| nvim-tree.lua | 文件树 |
| lualine.nvim | 状态栏 |
| bufferline.nvim | 缓冲区标签栏 |
| which-key.nvim | 快捷键提示 |
| gitsigns.nvim | Git 行级标记 |
| vim-fugitive | Git 命令集成 |
| flash.nvim | 快速跳转 |
| nvim-surround | 包围编辑 |
| vim-easy-align | 文本对齐 |
| undotree | 撤销历史树 |
| todo-comments.nvim | TODO/FIXME 高亮 |
| rainbow-delimiters.nvim | 彩虹括号 |

</details>

## 参考

- [skywind3000/vim](https://github.com/skywind3000/vim)
- [如何在 Linux 下利用 Vim 搭建 C/C++ 开发环境?](https://www.zhihu.com/question/47691414)

## License

[MIT](LICENSE)
