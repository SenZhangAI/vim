# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal Vim/Neovim configuration:
- **Neovim (0.9+)**: primary editor. Lua-based config with lazy.nvim, native LSP, Treesitter, telescope
- **Vim**: fallback for quick edits / ssh. Shared basic settings only, no plugins

Languages: C/C++, Rust, Python, Go, Java, Markdown.

## Setup

```bash
./install.sh        # detects nvim/vim, sets up accordingly
brew upgrade neovim  # recommended: upgrade to 0.10+ first
```

Neovim plugins auto-install via lazy.nvim on first launch. Vim has no plugins to install.

## Architecture

**Routing** via `vimrc`:
```
vimrc → import.vim → include/*.vim (shared settings)
     ├─ has('nvim') → lua require('config')  → lazy.nvim + Lua plugins
     └─ else        → colorscheme only (no plugins)
```

### Shared VimScript (`include/`)
- `general.vim` — editor defaults (4-space indent, auto-save on focus lost, persistent undo, trailing whitespace strip). Neovim-default settings are gated by `!has('nvim')`.
- `keymaps.vim` — leader is `,`. `jk`=ESC. `C-j/C-k` move lines. Arrows switch buffers.
- `ignores.vim` — wildignore patterns

### Neovim path (`lua/`)
```
lua/config/init.lua    → entry: loads options, lazy, keymaps
lua/config/options.lua → nvim-specific (inccommand, termguicolors, etc.)
lua/config/keymaps.lua → diagnostic nav, quickfix toggle
lua/config/lazy.lua    → bootstrap lazy.nvim at ~/.vim/lazy/
lua/plugins/           → one file per plugin group:
  colorscheme.lua      → solarized.nvim
  treesitter.lua       → nvim-treesitter + textobjects
  lsp.lua              → mason + lspconfig + conform + nvim-lint
  cmp.lua              → nvim-cmp + LuaSnip
  telescope.lua        → telescope + fzf-native
  ui.lua               → lualine, bufferline, nvim-tree, which-key, alpha
  editor.lua           → autopairs, surround, flash, comment, easy-align, undotree, colorizer, rainbow-delimiters
  git.lua              → gitsigns, fugitive
  tabnine.lua          → TabNine AI completion
```

### Vim path
No plugins by design: only `include/*.vim` + `NeoSolarized` colorscheme. The former vim-plug + CoC stack was removed to stop maintaining two LSP setups.

## Editing Guidelines

- **Neovim plugins**: edit files in `lua/plugins/`. Each file returns a lazy.nvim spec table.
- **Shared settings**: edit `include/*.vim`. Use `if !has('nvim')` guards for vim-only settings.
- `general.vim` auto-saves on `FocusLost`/`InsertLeave` and strips trailing whitespace on write.
- lazy.nvim plugin dir: `~/.vim/lazy/`.
- Color scheme: `solarized.nvim` (Lua, neovim) / `NeoSolarized.vim` (VimScript, vim).
