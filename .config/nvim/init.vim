runtime! archlinux.vim

" identify the filetype
  filetype plugin on
" force syntax highlighting
  syntax on
" force unicode encoding
  set encoding=utf-8

" remap jk to ESC for easier exiting insert mode 
  inoremap jk <ESC>
" map vim copy buffer to system clipboard
  set clipboard=unnamedplus

" show relative line numbers for easy jumping around using #j and #k keys
 "set relativenumber
 "set rnu
" make line number column thinner
 "set numberwidth=1
" force cursor to stay in the middle of the screen
  set so=999

" disables automatic commenting on newline
  autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" force path autocompletion
  set wildmode=longest,list,full

" splits open at the bottom and right, rather than top and left
	set splitbelow splitright
  
" renew bash and ranger configs with new material
	autocmd BufWritePost files,directories !shortcuts
" run xrdb whenever Xdefaults or Xresources are updated
	autocmd BufWritePost *Xresources,*Xdefaults !xrdb %
" update binds when sxhkdrc is updated
	autocmd BufWritePost *sxhkdrc !pkill -USR1 sxhkd
