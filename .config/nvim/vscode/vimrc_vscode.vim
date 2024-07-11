" OPTIONS #####################################################################################

filetype indent plugin on             " Identify the filetype, load indent and plugin files.

set lazyredraw                        " Don't redraw screen during macros.
set autoread                          " Auto update when a file is changed from the outside.
set noshowmode                        " Don't show mode since it's handled by Airline.
set noshowcmd                         " Don't show command on last line.
set hidden                            " Hide abandoned buffers.

set ignorecase                        " Case-insensitive search, except when using capitals.
set smartcase                         " Override ignorecase if search contains capital letters.
set wildmenu                          " Enable path autocompletion.
set wildmode=longest,list,full

set autowriteall                      " Auto-save after certain events.
set clipboard+=unnamedplus            " Map vim copy buffer to system clipboard.
set splitbelow splitright             " Splits open at the bottom and right, rather than top/left.
set noswapfile nobackup               " Don't use backups since most files are in Git.
set updatetime=1000                    " Increase plugin update speed.

" Disable Ex mode.
noremap q: <Nop>
" Screen redraws will clear search results.
noremap <C-L> :nohl<CR><C-L>
" Use cedit mode when entering command mode.
" nnoremap : :<C-f>

" FORMATTING ##################################################################################

set encoding=utf-8     " Force unicode encoding.
set number             " Show line numbers.
set numberwidth=1      " Make line number column thinner.

set tabstop=2          " A <TAB> creates 2 spaces.
set softtabstop=2
set shiftwidth=2       " Number of auto-indent spaces.
set expandtab          " Convert tabs to spaces.
set foldmethod=manual foldlevelstart=99  " Don't fold by default.

set linebreak          " Break line at predefined characters when soft-wrapping.
" Force cursor to stay in the middle of the screen.

" SHORTCUTS ###################################################################################

" Leader key easier to reach.
let mapleader = ","
" Faster saving.
nnoremap <silent> <leader>w :write<CR><C-L>
" Jump back and forth between files.
nnoremap <silent> <BS> :e#<CR><C-L>

" Toggle preventing horizonal or vertial resizing.
nnoremap <leader>H :set winfixheight! <bar> set winfixheight?<CR>
nnoremap <leader>W :set winfixwidth! <bar> set winfixwidth?<CR>

" Columnize selection.
vnoremap t :!column -t<CR>
" Turn off highlighted search results.
nnoremap <silent> Q :nohl<CR><C-L>
" Easy turn on paste mode.
nnoremap <leader>p :set paste!<CR>
nnoremap <space> zA

" Quickly save and quit everything to restart neovim.
nnoremap <leader>Q :wqa!<CR>
" Save and quit only open window.
nnoremap <leader>q :wq!<CR>

" NAVIGATION ##################################################################################

inoremap jk <Esc>
" Easier navigating soft-wrapped lines.
nnoremap j gj
nnoremap k gk
" Easier jumping to beginning and ends of lines.
nnoremap L $
nnoremap H ^

" Navigate quick-fix menus, location lists, and helpgrep results.
nnoremap <down>         :cnext<CR>
nnoremap <leader><down> :clast<CR>
nnoremap <up>           :cprevious<CR>
nnoremap <leader><up>   :cfirst<CR>
nnoremap <left>         :copen<CR>
nnoremap <right>        :clist<CR>

" CTRL-n/p to navigate tabs.
nnoremap <silent> <C-p>      :tabprevious<CR>
inoremap <silent> <C-p> <Esc>:tabprevious<CR>
nnoremap <silent> <C-n>      :tabnext<CR>
inoremap <silent> <C-n> <Esc>:tabnext<CR>

" Jump to last active tab (a for 'alternate').
autocmd mygroup TabLeave * let g:lasttab = tabpagenr()
nnoremap <silent> <leader>a :exe "tabn ".g:lasttab<CR>

" Create and delete tabs web-browser-style.
nnoremap <silent> <C-t>      :tabnew<CR>
inoremap <silent> <C-t> <Esc>:tabnew<CR>
nnoremap <silent> <C-w>      :q!<CR>
inoremap <silent> <C-w> <Esc>:q!<CR>

" Create a split with an empty file.
nnoremap <silent> <C-s>      :new<CR>
inoremap <silent> <C-s> <Esc>:new<CR>
nnoremap <silent> <C-\>      :vnew<CR>
inoremap <silent> <C-\> <Esc>:vnew<CR>

nnoremap <silent> <C-k>      :wincmd k<CR>
inoremap <silent> <C-k> <Esc>:wincmd k<CR>
nnoremap <silent> <C-j>      :wincmd j<CR>
inoremap <silent> <C-j> <Esc>:wincmd j<CR>
nnoremap <silent> <C-h>      :wincmd h<CR>
inoremap <silent> <C-h> <Esc>:wincmd h<CR>
nnoremap <silent> <C-l>      :wincmd l<CR>
inoremap <silent> <C-l> <Esc>:wincmd l<CR>

" ALT-Up/Down/Left/Right to resize splits.
nnoremap <silent> <A-Right>      :vertical resize +2<CR><C-L>
inoremap <silent> <A-Right> <Esc>:vertical resize +2<CR><C-L>

nnoremap <silent> <A-Left>      :vertical resize -2<CR><C-L>
inoremap <silent> <A-Left> <Esc>:vertical resize -2<CR><C-L>

nnoremap <silent> <A-Up>      :resize +2<CR><C-L>
inoremap <silent> <A-Up> <Esc>:resize +2<CR><C-L>

nnoremap <silent> <A-Down>      :resize -2<CR><C-L>
inoremap <silent> <A-Down> <Esc>:resize -2<CR><C-L>

" Quickly convert a terminal window to a Ranger window.
tnoremap <leader>r <C-\><C-n>:enew! <bar> RnvimrToggle<CR><C-L>

" Use VSCode's CTRL+` to toggle the terminal.

" Jump to tab by number.
" Using CTRL doesn't work here, so must use ALT.
nnoremap <silent> <A-1> 1gt
inoremap <silent> <A-1> <Esc>1gt<CR>
nnoremap <silent> <A-2> 2gt
inoremap <silent> <A-2> <Esc>2gt<CR>
nnoremap <silent> <A-3> 3gt
inoremap <silent> <A-3> <Esc>3gt<CR>
nnoremap <silent> <A-4> 4gt
inoremap <silent> <A-4> <Esc>4gt<CR>
nnoremap <silent> <A-5> 5gt
inoremap <silent> <A-5> <Esc>5gt<CR>
nnoremap <silent> <A-6> 6gt
inoremap <silent> <A-6> <Esc>6gt<CR>
nnoremap <silent> <A-7> 7gt
inoremap <silent> <A-7> <Esc>7gt<CR>
nnoremap <silent> <A-8> 8gt
inoremap <silent> <A-8> <Esc>8gt<CR>
nnoremap <silent> <A-9> 9gt
inoremap <silent> <A-9> <Esc>9gt<CR>
nnoremap <silent> <A-0> 10gt
inoremap <silent> <A-0> <Esc>10gt<CR>
nnoremap <silent> <A--> 11gt
inoremap <silent> <A--> <Esc>11gt<CR>
nnoremap <silent> <A-=> 12gt
inoremap <silent> <A-=> <Esc>12gt<CR>
