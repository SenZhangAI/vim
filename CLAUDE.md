# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal Vim/Neovim configuration repository that provides a comprehensive setup for multiple programming languages including C/C++, Rust, Julia, Haskell, Python, Go, and Markdown. The configuration is built around modern Vim plugins and Language Server Protocol (LSP) support through CoC (Conquer of Completion).

## Installation and Setup

### Initial Setup
```bash
./install.sh
```
This script:
- Backs up existing vim configuration files
- Copies configuration files to appropriate locations (`~/.vimrc`, `~/.gvimrc`, `~/.config/nvim/init.vim`)
- Installs vim plugins using vim-plug
- Creates necessary directories (e.g., `~/.vim/.undo`)
- Installs CoC extensions: `coc-snippets`, `coc-yank`, `coc-marketplace`, `coc-rls`

### Dependencies
- Node.js and yarn (for markdown-preview plugin)
- Language servers for various languages (see Language Server Setup below)

### Language Server Setup

#### Golang
```bash
GO111MODULE=on go get golang.org/x/tools/gopls@latest
```

#### Julia
```julia
julia> using Pkg
julia> Pkg.add("LanguageServer")
julia> Pkg.add("SymbolServer") 
julia> Pkg.add("StaticLint")
```

#### Vim Syntax Checking
```bash
# Install vim syntax checker
pip3 install vim-vint

# Install efm-langserver
go get github.com/mattn/efm-langserver
```

## Architecture

### Core Configuration Structure
- `vimrc` - Main configuration file that sources `import.vim`
- `import.vim` - Central import file that loads all other configuration modules
- `bundle.vim` - Plugin management and configuration using vim-plug
- `include/` - Directory containing modular configuration files:
  - `general.vim` - General vim settings
  - `fix.vim` - Bug fixes and compatibility tweaks
  - `keymaps.vim` - Custom key mappings
  - `ignores.vim` - File ignore patterns
  - `plugins.vim` - Plugin-specific configurations

### Plugin Groups
The configuration uses a modular plugin group system defined in `g:bundle_group`:
- `basic` - Essential plugins (startify, autoformat, commentary, etc.)
- `fantasic` - Advanced features (fzf, LeaderF, which-key, etc.)
- `git` - Git integration (fugitive, gitgutter)
- `nerdtree` - File explorer
- `rainbow` - Rainbow parentheses
- `tagbar` - Code outline viewer
- `airline` - Status line
- `terminus` - Terminal integration
- `themes` - Color schemes
- `tags` - Tag management (gutentags)
- `ale` - Asynchronous Lint Engine
- `coc` - Language server support
- `repl` - REPL integration
- Language-specific groups: `cpp`, `rust`, `julia`, `python`, `golang`, `haskell`, `markdown`

### Language Server Configuration
LSP servers are configured in `coc-settings.json`:
- **C/C++**: clangd
- **Go**: gopls  
- **Rust**: ra_lsp_server (rust-analyzer)
- **Haskell**: hie-wrapper
- **Julia**: LanguageServer.jl

### Build and Compilation
The configuration includes extensive quickrun support for various languages with compiler-specific settings:
- **C**: gcc/clang with custom flags
- **C++**: g++/clang++ with C++11 standard
- Supports compile_flags.txt for project-specific compilation flags

## Key Features

### File Navigation
- **FZF integration**: `<C-p>` for file search
- **LeaderF**: Multiple search modes (files, buffers, functions, tags)
- **NERDTree**: File explorer with `<space>nn` toggle

### Code Intelligence  
- **CoC**: LSP-based completion, go-to-definition, references
- **Tags**: Automatic tag generation with gutentags
- **ALE**: Real-time linting for multiple languages

### Development Workflow
- **Git integration**: fugitive commands with space-prefixed shortcuts
- **REPL support**: Interactive development for Python, Haskell, etc.
- **Quickrun**: Execute current file with `\r`

### Language-Specific Features
- **Python**: iPython REPL integration, multiple linters (flake8, pylint)
- **C/C++**: Enhanced syntax highlighting, cppcheck integration
- **Rust**: Auto-formatting on save
- **Markdown**: Table mode, live preview support
- **Haskell**: Comprehensive syntax highlighting and indentation

## Common Development Tasks

### Running Code
- Use quickrun with default keybindings to execute current file
- Language-specific execution configured in `bundle.vim:78-144`

### Linting and Formatting
- ALE provides real-time linting for supported languages
- Autoformat plugin available for code formatting
- Language-specific linters configured in `bundle.vim:784-847`

### Navigation and Search
- Use `gd` for go-to-definition (CoC)
- Use `gr` for find references (CoC)
- Use `<C-p>` for fuzzy file search (FZF)
- Use `<leader>f` for function search (LeaderF)

This configuration prioritizes LSP-based development with comprehensive language support and modern Vim practices.