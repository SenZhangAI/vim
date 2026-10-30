# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal Vim/Neovim configuration:
- **Neovim (0.11+)**: primary editor, used for reading docs/code and quick edits (code is written by Claude). Lua config with lazy.nvim, Treesitter, snacks.nvim, read-only LSP navigation. No completion/snippets/formatters/linters by design
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
- `general.vim` — editor defaults (4-space indent, no auto-save but auto-reload via `checktime` since files are edited externally, persistent undo, trailing whitespace strip). All autocmds live in augroup `vimrc_general`. Neovim-default settings are gated by `!has('nvim')`.
- `keymaps.vim` — leader is `,`. `jk`=ESC. `A-j/A-k` move lines. Arrows switch buffers.
- `ignores.vim` — wildignore patterns

### Neovim path (`lua/`)
```
lua/config/init.lua    → entry: loads options, lazy, keymaps
lua/config/options.lua → nvim-specific (inccommand, termguicolors, etc.)
lua/config/keymaps.lua → diagnostic nav, quickfix toggle, terminal toggle, built-in undotree
lua/config/lazy.lua    → bootstrap lazy.nvim at ~/.vim/lazy/
lua/plugins/           → one file per plugin group:
  colorscheme.lua      → solarized.nvim
  treesitter.lua       → nvim-treesitter (main branch, needs tree-sitter CLI)
  snacks.lua           → snacks.nvim: explorer sidebar, picker, dashboard, notifier, indent, input, bigfile, words
  lsp.lua              → lspconfig; enables only servers found on PATH / mason bin. mason is manual (:Mason)
  ui.lua               → mini.icons (style = "ascii"), lualine, which-key
  git.lua              → gitsigns (diff/blame; git status/log pickers live in snacks.lua)
```

### Vim path
No plugins by design: only `include/*.vim` + `NeoSolarized` colorscheme. The former vim-plug + CoC stack was removed to stop maintaining two LSP setups.

## Editing Guidelines

- **No Nerd Font**: icons are deliberately ASCII so any terminal/font works. mini.icons (`style = "ascii"`) is the only icon provider; do not add nvim-web-devicons. Plugins with their own icon tables (snacks picker/notifier, which-key keys, lazy ui) get ASCII values via their config options. Never introduce Private Use Area glyphs (U+E000-F8FF, U+F0000+).
- **Minimal plugin set** (10): editing is done by AI, so only reading/navigation/review plugins. Markdown is syntax-highlighted only (Treesitter), not rendered: render-markdown was tried and removed by preference. Prefer Neovim built-ins (`gc` comments, `nvim.undotree`, 0.11+ default `[b`/`]q` mappings) over plugins.

- **Neovim plugins**: edit files in `lua/plugins/`. Each file returns a lazy.nvim spec table.
- **Shared settings**: edit `include/*.vim`. Use `if !has('nvim')` guards for vim-only settings.
- `general.vim` auto-saves on `FocusLost`/`InsertLeave` and strips trailing whitespace on write.
- lazy.nvim plugin dir: `~/.vim/lazy/`.
- Color scheme: `solarized.nvim` (Lua, neovim) / `NeoSolarized.vim` (VimScript, vim).
