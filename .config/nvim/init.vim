runtime! archlinux.vim

" remap jk to ESC for easier exiting insert mode 
inoremap jk <ESC>

filetype plugin on

" force syntax highlighting
syntax on

" force default encoding
set encoding=utf-8

" map vim copy buffer to system clipboard
set clipboard=unnamedplus

" show relative line numbers for easy jumping around using #j and #k keys
"set relativenumber
"set rnu

" make line number column thinner
"set numberwidth=1

" force cursor to stay in the middle of the screen
set so=999
