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

if command_installed nvim; then
    _vim='nvim'
elif command_installed vim; then
    _vim='vim'
else
    printf "Error: command [vim] or [nvim] not found.\n"
    exit 1
fi

vim_rc=$HOME/.vimrc
gvim_rc=$HOME/.gvimrc
mkdir -p $HOME/.config/nvim/
nvim_rc=$HOME/.config/nvim/init.vim
backup_rand=$RANDOM

backup_file() {
    if [ -L $1 ] || [ -f $1 ]; then
        echo "There's a original file [$1] exist."
        read -p "Would you like to backup it first? [y/N] " ans

        if [ "$ans" == "y" ]; then
            echo "backup your original $1 to $1-$(date +%Y%m%d)-$backup_rand-bak"
            cp $1 $1$(date +%Y%m%d)-$backup_rand-bak
        fi

        rm -f $1
    fi
    return 0;
}

backup_file $vim_rc
backup_file $gvim_rc
backup_file $nvim_rc

cp $vim_dir/vimrc $vim_rc
ln -sfn $vim_rc $nvim_rc
cp $vim_dir/gvimrc $gvim_rc

## install plugin
$_vim -c "PlugInstall | qall" || echo "error happend when installing plugins..."

mkdir -p $HOME/.vim/.undo
ln -sfn $vim_dir/coc-settings.json $HOME/.vim/coc-settings.json
ln -sfn $vim_dir/coc-settings.json $HOME/.config/nvim/coc-settings.json

$_vim -c "CocInstall -sync coc-snippets coc-yank coc-marketplace coc-rust-analyzer coc-pyright | qall" || echo "error happend when running CocInstall"
unset _vim
