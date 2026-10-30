#!/bin/bash

set -e

vim_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

command_installed() {
    printf "%-48s" "Check command $1..."
    command -v $1 >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        printf "Not Installed\n"
        return 1
    else
        printf "Installed\n"
        return 0
    fi
}

# Detect available editors
has_nvim=false
has_vim=false

if command_installed nvim; then
    has_nvim=true
    nvim_version=$(nvim --version | head -1 | grep -oE '[0-9]+\.[0-9]+')
fi

if command_installed vim; then
    has_vim=true
fi

if [ "$has_nvim" = false ] && [ "$has_vim" = false ]; then
    printf "Error: command [vim] or [nvim] not found.\n"
    exit 1
fi

vim_rc=$HOME/.vimrc
gvim_rc=$HOME/.gvimrc
mkdir -p $HOME/.config/nvim/
nvim_rc=$HOME/.config/nvim/init.vim
backup_rand=$RANDOM

backup_file() {
    if [ -L "$1" ]; then
        # Symlinks are just pointers — remove without backup
        echo "Removing existing symlink [$1]"
        rm -f "$1"
    elif [ -f "$1" ]; then
        echo "There's a original file [$1] exist."
        read -p "Would you like to backup it first? [y/N] " ans

        if [ "$ans" == "y" ]; then
            echo "backup your original $1 to $1-$(date +%Y%m%d)-$backup_rand-bak"
            cp "$1" "$1-$(date +%Y%m%d)-$backup_rand-bak"
        fi

        rm -f "$1"
    fi
    return 0;
}

backup_file $vim_rc
backup_file $gvim_rc
backup_file $nvim_rc

cp $vim_dir/vimrc $vim_rc
ln -sfn $vim_rc $nvim_rc
cp $vim_dir/gvimrc $gvim_rc

mkdir -p $HOME/.vim/.undo

# 外部工具: tree-sitter CLI 编译 parser (nvim-treesitter main 分支必需), ripgrep 给 picker grep 用
install_cli_tools() {
    local cmd pkg missing=()
    for pair in "tree-sitter:tree-sitter-cli" "rg:ripgrep"; do
        cmd=${pair%%:*}
        pkg=${pair#*:}
        command_installed "$cmd" || missing+=("$pkg")
    done
    [ ${#missing[@]} -eq 0 ] && return 0

    if command -v brew >/dev/null 2>&1; then
        read -p "Install ${missing[*]} via Homebrew? [Y/n] " ans
        ans=${ans:-y}
        if [ "$ans" = "y" ] || [ "$ans" = "Y" ]; then
            brew install "${missing[@]}"
            return 0
        fi
    fi
    echo "Please install manually: ${missing[*]}"
    echo "  (tree-sitter-cli is also available via: npm install -g tree-sitter-cli / cargo install tree-sitter-cli)"
}

# Install based on editor
if [ "$has_nvim" = true ]; then
    echo ""
    echo "=== Neovim Setup ==="
    echo "Neovim detected (v$nvim_version). Using lazy.nvim + native LSP."
    echo "Plugins will auto-install on first launch of Neovim."
    echo ""

    # Check minimum version
    nvim_major=$(echo $nvim_version | cut -d. -f1)
    nvim_minor=$(echo $nvim_version | cut -d. -f2)
    if [ "$nvim_major" -eq 0 ] && [ "$nvim_minor" -lt 11 ]; then
        echo "WARNING: Neovim $nvim_version is too old. This config needs 0.11+ (vim.lsp.config, treesitter main)."
        echo "  brew upgrade neovim"
        echo ""
    fi

    install_cli_tools
fi

# Vim 路径已不装插件; 清理旧版 install.sh 留下的 CoC 软链 (目标文件已删除)
for link in $HOME/.vim/coc-settings.json $HOME/.config/nvim/coc-settings.json; do
    [ -L "$link" ] && rm -f "$link"
done

echo ""
echo "=== Installation Complete ==="
echo "  Neovim: Open nvim, lazy.nvim will auto-install plugins on first run"
echo "  Vim:    Basic settings only (include/*.vim), no plugins"
echo ""
