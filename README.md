## Description

My (neo)vim config files, Only support neovim and vim 8+

Inspired by [skywind-vimrc](https://github.com/skywind3000/vim)

## Install

1. Make sure you install [node](https://nodejs.org/en/) and [yarn](https://github.com/yarnpkg/yarn) first if you want to use [markdown-preview](https://github.com/iamcco/markdown-preview.nvim).
2. Install vim plugins by following script
```sh
 ./install.sh
```

## Others

### COC

[coc.nvim](https://github.com/neoclide/coc.nvim) is awesome!!!

#### coc-marketplace

Use [coc-marketplace](https://github.com/fannheyward/coc-marketplace), you can search many useful extensions

`:CocList marketplace` list all available extensions
`:CocList marketplace python` to search extension that name contains python

#### Debug language server

See <https://github.com/neoclide/coc.nvim/wiki/Debug-language-server#using-output-channel>

#### coc LSP Server

LSP server table <https://langserver.org/#implementations-server>

Config example <https://github.com/neoclide/coc.nvim/wiki/Language-servers>

#### Golang support

Install golang LSP server see <https://github.com/golang/go/wiki/gopls>

```sh
$ GO111MODULE=on go get golang.org/x/tools/gopls@latest
```

#### Julia support
julia coc support see <https://github.com/neoclide/coc.nvim/wiki/Language-servers#julia>

```julia
julia> using Pkg
julia> Pkg.add("LanguageServer")
julia> Pkg.add("SymbolServer")
julia> Pkg.add("StaticLint")
```

#### vim support

syntax checker for vim，see <https://github.com/mattn/efm-langserver>

```sh
# install vim syntax checker see https://github.com/Kuniwak/vint
$ pip3 install vim-vint

# install lsp for vim
$ go get github.com/mattn/efm-langserver
```

Configure efm-langserver

<https://github.com/mattn/efm-langserver#example-for-configyaml>

## Reference

[skywind-vimrc](https://github.com/skywind3000/vim)

[如何在 Linux 下利用 Vim 搭建 C/C++ 开发环境?](https://www.zhihu.com/question/47691414)

[Vim有哪些曾经有名但是现在过时插件](https://www.zhihu.com/question/31934850)

[一些vim小技巧](http://senzhangai.github.io/tools/vim-tips)
