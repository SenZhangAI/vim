#!/bin/bash

set -e

vim_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

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
ln -s $vim_rc $nvim_rc
cp $vim_dir/gvimrc $gvim_rc

## install plugin
vim -c "PlugInstall | qall"

mkdir -p $HOME/.vim/.undo

ln -s $vim_dir/coc-settings.json $HOME/.vim/coc-settings.json
ln -s $vim_dir/coc-settings.json $HOME/.config/nvim/coc-settings.json

read -p "Would you want to install cac-extensions ? [Y/n] " ans
if [ "$ans" != "n" ]; then
    # coc-rls for rust
    vim -c "CocInstall -sync coc-snippets coc-yank coc-rls | qall"
fi
