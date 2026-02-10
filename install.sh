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

# Install Nerd Font for icons (lualine, bufferline, nvim-tree, etc.)
install_nerd_font() {
    local font_name="Hack"
    local font_check=""

    # Check if already installed
    case "$(uname -s)" in
        Darwin)
            font_check=$(find ~/Library/Fonts /Library/Fonts -iname "*HackNerd*" 2>/dev/null | head -1)
            ;;
        Linux)
            font_check=$(fc-list 2>/dev/null | grep -i "Hack.*Nerd" | head -1)
            ;;
    esac

    if [ -n "$font_check" ]; then
        echo "Hack Nerd Font already installed."
        return 0
    fi

    echo ""
    read -p "Install Hack Nerd Font for icons? [Y/n] " ans
    ans=${ans:-y}
    if [ "$ans" != "y" ] && [ "$ans" != "Y" ]; then
        echo "Skipped. Icons may show as '?' without a Nerd Font."
        echo "Set your terminal font to a Nerd Font if you install one later."
        return 0
    fi

    case "$(uname -s)" in
        Darwin)
            if command -v brew >/dev/null 2>&1; then
                echo "Installing via Homebrew..."
                brew install --cask font-hack-nerd-font
            else
                echo "Homebrew not found. Install manually: https://www.nerdfonts.com/font-downloads"
                return 1
            fi
            ;;
        Linux)
            local font_dir="$HOME/.local/share/fonts"
            local tmp_zip="/tmp/Hack-NerdFont.zip"
            echo "Downloading Hack Nerd Font..."
            mkdir -p "$font_dir"
            curl -fsSL -o "$tmp_zip" \
                "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Hack.zip"
            unzip -o -q "$tmp_zip" -d "$font_dir" "*.ttf"
            rm -f "$tmp_zip"
            if command -v fc-cache >/dev/null 2>&1; then
                fc-cache -f "$font_dir"
            fi
            echo "Hack Nerd Font installed to $font_dir"
            ;;
        *)
            echo "Unsupported OS. Install manually: https://www.nerdfonts.com/font-downloads"
            return 1
            ;;
    esac

    echo "Done. Set your terminal font to 'Hack Nerd Font Mono' to enable icons."
}

install_nerd_font

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
    if [ "$nvim_major" -eq 0 ] && [ "$nvim_minor" -lt 9 ]; then
        echo "WARNING: Neovim $nvim_version is too old. Please upgrade to 0.9+ for best experience."
        echo "  brew upgrade neovim"
        echo ""
    fi
fi

if [ "$has_vim" = true ]; then
    echo ""
    echo "=== Vim 8 Setup ==="

    # Symlink coc-settings for Vim 8
    ln -sfn $vim_dir/coc-settings.json $HOME/.vim/coc-settings.json
    ln -sfn $vim_dir/coc-settings.json $HOME/.config/nvim/coc-settings.json

    # Install vim-plug plugins
    vim -c "PlugInstall | qall" || echo "error happened when installing plugins..."

    # Install CoC extensions
    vim -c "CocInstall -sync coc-snippets coc-yank coc-marketplace coc-rust-analyzer coc-pyright coc-java | qall" \
        || echo "error happened when running CocInstall"
fi

echo ""
echo "=== Installation Complete ==="
echo "  Neovim: Open nvim, lazy.nvim will auto-install plugins on first run"
echo "  Vim 8:  Plugins installed via vim-plug + CoC"
echo ""
