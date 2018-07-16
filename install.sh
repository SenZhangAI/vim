#!/bin/bash

# set vim dir
vim_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

vim_rc=~/.vimrc
gvim_rc=~/.gvimrc
mkdir -p ~/.config/nvim/
nvim_rc=~/.config/nvim/init.vim
backup_rand=$RANDOM

backup_file() {
  if [ -L $1 ] || [ -f $1 ]; then
    echo "There's a original file:[$1]exist."
    read -p "Would you like to backup it first? [y/n] " ans

    if [ "$ans" == "y" ]; then
      echo "backup your original $1 to $1-$(date +%Y%m%d)-$backup_rand-bak"
      mv $1 $1$(date +%Y%m%d)-$backup_rand-bak
      return 1;
    fi
  fi
  return 0;
}

backup_file $vim_rc
backup_file $gvim_rc
backup_file $nvim_rc

# linking to .rc
## linking to .vimrc
ln -s $vim_dir/vimrc $vim_rc 2>/dev/null

## linking to .gvimrc
ln -s $vim_dir/vimrc $nvim_rc 2>/dev/null

## linking to .gvimrc
ln -s $vim_dir/gvimrc $gvim_rc 2>/dev/null

## install plugin
vim +PlugInstall +qall