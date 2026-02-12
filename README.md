## sen's vim config

个人 Vim/Neovim 配置，支持双架构：

- **Neovim (0.9+)** — Lua 配置，lazy.nvim 插件管理，原生 LSP + Treesitter + Telescope
- **Vim 8+** — VimScript 配置，vim-plug + CoC + fzf（兼容模式）

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

通过 `vimrc` 实现双路径自动路由：

```
vimrc → import.vim → include/*.vim (共享配置)
     ├─ has('nvim') → lua/config/   → lazy.nvim + Lua 插件
     └─ else        → bundle.vim    → vim-plug + CoC
```

### 共享配置 (`include/`)

| 文件 | 说明 |
|------|------|
| `general.vim` | 编辑器默认值（4空格缩进、自动保存、持久撤销、去除尾部空白） |
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
  lsp.lua         → mason + lspconfig + conform + nvim-lint + lazydev
  cmp.lua         → nvim-cmp + LuaSnip 自动补全
  telescope.lua   → 模糊搜索 + fzf-native
  ui.lua          → lualine, bufferline, nvim-tree, which-key, alpha, dressing
  editor.lua      → autopairs, surround, flash, comment, easy-align,
                    undotree, colorizer, rainbow-delimiters,
                    todo-comments, indent-blankline
  git.lua         → gitsigns, fugitive
```

### Vim 8 路径 (`bundle.vim`)

vim-plug 管理，插件按组加载。CoC 提供 LSP/补全，fzf 模糊搜索，airline 状态栏，NERDTree 文件树。LSP 服务器配置见 `coc-settings.json`。

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
<summary>展开查看全部 30+ 插件</summary>

| 插件 | 用途 |
|------|------|
| solarized.nvim | 配色方案 |
| nvim-treesitter | 语法高亮 + 文本对象 |
| nvim-lspconfig + mason | LSP 客户端 + 服务器管理 |
| lazydev.nvim | Neovim Lua API 补全 |
| conform.nvim | 保存时自动格式化 |
| nvim-lint | 代码检查 |
| nvim-cmp + LuaSnip | 自动补全 + 代码片段 |
| telescope.nvim | 模糊搜索 |
| trouble.nvim | 诊断/引用面板 |
| fidget.nvim | LSP 进度指示 |
| nvim-tree.lua | 文件树 |
| lualine.nvim | 状态栏 |
| bufferline.nvim | 缓冲区标签栏 |
| alpha-nvim | 启动界面 |
| which-key.nvim | 快捷键提示 |
| dressing.nvim | 美化 UI 组件 |
| gitsigns.nvim | Git 行级标记 |
| vim-fugitive | Git 命令集成 |
| flash.nvim | 快速跳转 |
| nvim-surround | 包围编辑 |
| Comment.nvim | 注释切换 |
| nvim-autopairs | 括号自动配对 |
| vim-easy-align | 文本对齐 |
| undotree | 撤销历史树 |
| todo-comments.nvim | TODO/FIXME 高亮 |
| indent-blankline.nvim | 缩进参考线 |
| nvim-colorizer.lua | 颜色代码预览 |
| rainbow-delimiters.nvim | 彩虹括号 |

</details>

## 参考

- [skywind3000/vim](https://github.com/skywind3000/vim)
- [如何在 Linux 下利用 Vim 搭建 C/C++ 开发环境?](https://www.zhihu.com/question/47691414)

## License

[MIT](LICENSE)
