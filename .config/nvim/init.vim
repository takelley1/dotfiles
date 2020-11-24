" FEATURES #########################################################################################
    set nocompatible
    filetype indent plugin on             " Identify the filetype.
    syntax on                             " Force syntax highlighting.
    set encoding=utf-8                    " Force unicode encoding.
    set autoread                          " Auto update when a file is changed from the outside.
    set number                                   " Show line numbers.
    set numberwidth=1                            " Make line number column thinner.
    set scrolloff=999                            " Force cursor to stay in the middle of the screen.
    let g:python3_host_prog = '/usr/bin/python3' " Speed up startup.
    let g:loaded_python_provider = 0

" FORMATTING #######################################################################################
    set tabstop=4          " Indents are 4 spaces by default.
    set softtabstop=4
    set shiftwidth=4
    set expandtab          " Convert tabs to spaces.
    set noautoindent       " No automatic formatting.
    autocmd FileType * setlocal nocindent nosmartindent formatoptions-=c formatoptions-=r formatoptions-=o indentexpr=

  " Force certain filetypes to use indents of 2 spaces.
    autocmd FileType config,markdown,vim,yaml,*.md setlocal shiftwidth=2 softtabstop=2 tabstop=2
  " Don't wrap text on Markdown files.
    autocmd FileType markdown setlocal nowrap
  " No line numbers in terminal windows.
    autocmd TermOpen * setlocal nonumber

" COLORS ###########################################################################################
  " Visual mode text highlight color.
    highlight Visual cterm=bold ctermfg=10 ctermbg=16 guifg=10 guibg=7
  " Search results highlight color.
    highlight Search cterm=bold ctermfg=0 ctermbg=3 guifg=0 guibg=3

" BEHAVIOR #########################################################################################
    set noshowcmd
    set autowriteall
    set ignorecase                  " Case-insensitive search, except when using capitals.
    set smartcase
    set clipboard=unnamedplus       " Map vim copy buffer to system clipboard.
    set confirm                     " Show dialog when a command requires confirmation.
    set wildmenu                    " Better path autocompletion.
    set wildmode=longest,list,full
    set splitbelow splitright       " Splits open at the bottom and right, rather than top and left.
    set noswapfile                  " Don't use swap files since most files are in Git.

    autocmd VimEnter * cd ~         " Change to home directory on startup.
    autocmd BufLeave * silent! :wa  " Save on focus loss.
    autocmd FocusGained,BufEnter * checktime  " Automatically update file if changed from outside.
    autocmd BufEnter * if &buftype == "terminal" | :startinsert | endif " Switch to insert mode when entering terminals.

    " Disable Ex mode.
      noremap q: <Nop>
    " Screen redraws clear search results.
      noremap <C-L> :nohl<CR><C-L>

" SHORTCUTS ########################################################################################
  " Leader key easier to reach.
    let mapleader = ","
  " Easier exiting insert mode.
    inoremap jk <Esc>
    tnoremap <Esc> <C-\><C-n>
  " Faster saving.
    nnoremap <leader>w :write<CR>
  " Easily edit vimrc.
    nnoremap <leader>ev :split ~/.config/nvim/init.vim<CR>
  " Reload configuration without restarting vim (sv for 'source vim').
    nnoremap <leader>sv :source $MYVIMRC<CR>

  " Columnize selection.
    vnoremap t :!column -t<CR>
  " Turn off highlighted search results.
    nnoremap Q :nohl<CR><C-L>

  " Dotfiles (Vim-fugitive doesn't support --git-dir option)
    nnoremap da :write<CR> :!git --git-dir=$HOME/.cfg/ --work-tree=$HOME add %<CR><C-L>
    nnoremap ds :!git --git-dir=$HOME/.cfg/ --work-tree=$HOME status --untracked-files=no<CR>
    nnoremap dl :!git --git-dir=$HOME/.cfg/ --work-tree=$HOME log<CR>
    nnoremap dp :!git --git-dir=$HOME/.cfg/ --work-tree=$HOME push
    " *dot diff unstaged*
    nnoremap diu :!git --git-dir=$HOME/.cfg/ --work-tree=$HOME diff<CR>
    " *dot diff staged*
    nnoremap dis :!git --git-dir=$HOME/.cfg/ --work-tree=$HOME diff --staged<CR>
    " *dot commit file*
    nnoremap dcf :write<CR> :!git --git-dir=$HOME/.cfg/ --work-tree=$HOME commit % -m '
    " *dot commit staged*
    nnoremap dcs :!git --git-dir=$HOME/.cfg/ --work-tree=$HOME commit -m '
    nnoremap drm :!git --git-dir=$HOME/.cfg/ --work-tree=$HOME rm
    nnoremap drs :!git --git-dir=$HOME/.cfg/ --work-tree=$HOME restore

" PLUGINS ##########################################################################################
  " Increase plugin update speed.
    set updatetime=1000

  " Airline ------------------------------------------------------------------------------------
    set noshowmode
    let g:airline_theme='powerlineish'
    let g:airline#extensions#grepper#enabled = 1
    let g:airline_highlighting_cache = 1
    let g:airline#extensions#tabline#enabled = 1
    let g:airline_detect_modified = 0

  " ALE --------------------------------------------------------------------------------------------
    " Have ALE remove extra whitespace and trailing lines.
      let g:ale_fixers = {'*': ['remove_trailing_lines', 'trim_whitespace']}

      let g:ale_fix_on_save = 1  " ALE will fix files automatically when they're saved.
      let g:ale_lint_delay = 300 " Increase linting speed.

      " Bash
      let g:ale_sh_bashate_options = '--ignore "E043,E006"'
      " Python
      let g:ale_python_flake8_options = '--config ~/.config/nvim/linters/flake8.config'
      let g:ale_python_pylint_options = '--rcfile ~/.config/nvim/linters/pylintrc.config'
      " YAML
      let g:ale_yaml_yamllint_options = '--config-file ~/.config/nvim/linters/yamllint.yml'
      let g:ale_linters = {'yaml': ['yamllint']} " Don't run swaglint on YAML files.

  " Black ------------------------------------------------------------------------------------------
    " Run Black formatter before saving Python files.
      autocmd BufWritePre *.py execute ':Black'

  " Ctrl-P -----------------------------------------------------------------------------------------
    " <leader>s to start searching (s for 'search').
    " CTRL-t to open the desired file in a new tab.
    " CTRL-v to open the desired file in a new vertical split.
    let g:ctrlp_map = '<leader>s'
    let g:ctrlp_tabpage_position = 'ac'
    let g:ctrlp_working_path_mode = 'rw' " Set search path to start at first .git directory below the cwd.
    let g:ctrlp_show_hidden = 1          " Index hidden files.
    let g:ctrlp_clear_cache_on_exit = 0  " Keep cache accross reboots.
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*  " Don't index version-control dirs.
    let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
    let g:ctrlp_max_depth = 50
    let g:ctrlp_max_files = 50000

  " Fugitive -----------------------------------------------------------------------------------
      nnoremap ga :Git add %<CR><C-L>
      nnoremap gs :Git status<CR>
      nnoremap gl :Git log<CR>
      nnoremap gp :Git push<CR>
      nnoremap giu :Git diff<CR>
      nnoremap gis :Git diff --staged<CR>
      nnoremap gcf :Git commit %<CR>
      nnoremap gcs :Git commit<CR>
      nnoremap grm :Git rm
      nnoremap grs :Git restore
      " Automatically enter Insert mode when opening the commit window.
        autocmd BufWinEnter COMMIT_EDITMSG startinsert

  " GitGutter --------------------------------------------------------------------------------------
    " Make sidebar dark.
      highlight SignColumn cterm=bold ctermbg=0 guibg=0
    " Undo git changes easily.
      nnoremap gu :GitGutterUndoHunk<CR>
    " View interactive git diff.
      nnoremap gd :Gdiffsplit<CR>
    " Fix git diff colors.
      highlight DiffText ctermbg=1 ctermfg=3 guibg=1 guifg=3

  " Grepper ----------------------------------------------------------------------------------------
    " <leader>s to start grepping (g for 'grep').
    nnoremap <leader>G :Grepper -tool grep -cd ~/<CR>
    nnoremap <leader>g :Grepper -tool grep<CR>

  " MarkdownPreview --------------------------------------------------------------------------------
    " Markdown preview with mp.
      autocmd FileType markdown nnoremap mp :MarkdownPreview<CR><C-L>
      "let g:mkdp_auto_start = 1  " Automatically launch rendered markdown in browser.
      let g:mkdp_auto_close = 1   " Automatically close rendered markdown in browser.

    " Use vimb instead of Firefox since Firefox won't automatically close
    "   the rendered markdown window.
      let g:mkdp_browser = 'vimb'

  " Nerd Commenter ---------------------------------------------------------------------------------
    " <leader>cc to comment a block.
    " <leader>cu to uncomment a block.
    let g:NERDSpaceDelims = 1
    let g:NERDDefaultAlign = 'left'

  " Rnvimr -----------------------------------------------------------------------------------------
    " <leader>f to open file manager.
    nnoremap <silent> <leader>f :RnvimrToggle<CR>
    let g:rnvimr_enable_ex = 1                      " Replace NetRW.
    let g:rnvimr_enable_picker = 1                  " Hide Ranger after picking file.
    let g:rnvimr_enable_bw = 1                      " Make Neovim wipe buffers corresponding to the files deleted by Ranger.
    let g:rnvimr_border_attr = {'fg': 14, 'bg': -1} " Change the border's color.
    let g:rnvimr_ranger_cmd = 'ranger --cmd="set draw_borders both"' " Draw border with both.
    " Link CursorLine into RnvimrNormal highlight in the Floating window
    highlight link RnvimrNormal CursorLine

    " Map Rnvimr action
    let g:rnvimr_action = {
                \ '<C-e>': 'NvimEdit tabedit',
                \ '<C-l>': 'NvimEdit split',
                \ '<C-v>': 'NvimEdit vsplit',
                \ 'gw': 'JumpNvimCwd',
                \ 'yw': 'EmitRangerCwd',
                \ }
    " Customize the initial layout
    let g:rnvimr_layout = {
                \ 'relative': 'editor',
                \ 'width': float2nr(round(0.8 * &columns)),
                \ 'height': float2nr(round(0.8 * &lines)),
                \ 'col': float2nr(round(0.1 * &columns)),
                \ 'row': float2nr(round(0.1 * &lines)),
                \ 'style': 'minimal'
                \ }

  " Supertab ---------------------------------------------------------------------------------------
      let g:SuperTabDefaultCompletionType = "<c-n>"  " Autocomplete top-down instead of bottom-up.

  " Vim-Session ------------------------------------------------------------------------------------
    " Run ':SaveSession <SESSION NAME>' to save your preferred editor configuration.
    " Run ':OpenSession! <SESSION NAME>' to restore config.

  " Vim-Plug ---------------------------------------------------------------------------------------
    call plug#begin(stdpath('data') . '/plugged')
      Plug 'airblade/vim-gitgutter'
      Plug 'dense-analysis/ale'
      Plug 'tpope/vim-fugitive'
      Plug 'xolox/vim-misc', { 'on': ['SaveSession', 'OpenSession', 'OpenSession!'] }
      Plug 'xolox/vim-session', { 'on': ['SaveSession', 'OpenSession', 'OpenSession!'] }
      Plug 'ervandew/supertab'
      Plug 'vim-airline/vim-airline'
      Plug 'vim-airline/vim-airline-themes'
      Plug 'mhinz/vim-grepper', { 'on': 'Grepper' }
      Plug 'ctrlpvim/ctrlp.vim'
      Plug 'preservim/nerdcommenter'
      Plug 'kevinhwang91/rnvimr'
      Plug 'psf/black.git', { 'for': 'python' }
      Plug 'sheerun/vim-polyglot.git'
    call plug#end()

" NAVIGATION #######################################################################################
  " Easier navigating soft-wrapped lines.
    nnoremap j gj
    nnoremap k gk

  " CTRL-n/p to navigate tabs.
    nnoremap <C-p> :tabprevious<CR>
    inoremap <C-p> <Esc>:tabprevious<CR>
    tnoremap <C-p> <C-\><C-n>:tabprevious<CR>

    nnoremap <C-n> :tabnext<CR>
    inoremap <C-n> <Esc>:tabnext<CR>
    tnoremap <C-n> <C-\><C-n>:tabnext<CR>

  " Jump to last active tab (a for 'alternate').
    autocmd TabLeave * let g:lasttab = tabpagenr()
    nnoremap <leader>a :exe "tabn ".g:lasttab<CR>
    tnoremap <leader>a <C-\><C-n>:exe "tabn ".g:lasttab<CR>

  " Jump to tab by number.
  " Using CTRL doesn't work here, so must use ALT.
    nnoremap <A-1> 1gt
    inoremap <A-1> <Esc>1gt<CR>
    tnoremap <A-1> <C-\><C-n>1gt<CR>
    nnoremap <A-2> 2gt
    inoremap <A-2> <Esc>2gt<CR>
    tnoremap <A-2> <C-\><C-n>2gt<CR>
    nnoremap <A-3> 3gt
    inoremap <A-3> <Esc>3gt<CR>
    tnoremap <A-3> <C-\><C-n>3gt<CR>
    nnoremap <A-4> 4gt
    inoremap <A-4> <Esc>4gt<CR>
    tnoremap <A-4> <C-\><C-n>4gt<CR>
    nnoremap <A-5> 5gt
    inoremap <A-5> <Esc>5gt<CR>
    tnoremap <A-5> <C-\><C-n>5gt<CR>
    nnoremap <A-6> 6gt
    inoremap <A-6> <Esc>6gt<CR>
    tnoremap <A-6> <C-\><C-n>6gt<CR>
    nnoremap <A-7> 7gt
    inoremap <A-7> <Esc>7gt<CR>
    tnoremap <A-7> <C-\><C-n>7gt<CR>
    nnoremap <A-8> 8gt
    inoremap <A-8> <Esc>8gt<CR>
    tnoremap <A-8> <C-\><C-n>8gt<CR>
    nnoremap <A-9> 9gt
    inoremap <A-9> <Esc>9gt<CR>
    tnoremap <A-9> <C-\><C-n>9gt<CR>

  " Create and delete tabs web-browser-style.
    nnoremap <C-t> :tabnew<CR>
    inoremap <C-t> <Esc>:tabnew<CR>
    tnoremap <C-t> <C-\><C-n>:tabnew<CR>
    nnoremap <C-w> :tabclose<CR>
    inoremap <C-w> <Esc>:tabclose<CR>
    tnoremap <C-w> <C-\><C-n>:tabclose<CR>

    nnoremap <C-s> :split<CR>
    inoremap <C-s> <Esc>:split<CR>
    tnoremap <C-s> <C-\><C-n>:split<CR>
    nnoremap <C-\> :vsplit<CR>
    inoremap <C-\> <Esc>:vsplit<CR>
    tnoremap <C-\> <C-\><C-n>:vsplit<CR>

  " CTRL-h/j/k/l to navigate splits.
    nnoremap <C-k> <C-w><Up>
    inoremap <C-k> <Esc><C-w><Up>
    tnoremap <C-k> <C-\><C-n><C-w><Up>

    nnoremap <C-j> <C-w><Down>
    inoremap <C-j> <Esc><C-w><Down>
    tnoremap <C-j> <C-\><C-n><C-w><Down>

    nnoremap <C-h> <C-w><Left>
    inoremap <C-h> <Esc><C-w><Left>
    tnoremap <C-h> <C-\><C-n><C-w><Left>

    nnoremap <C-l> <C-w><Right>
    inoremap <C-l> <Esc><C-w><Right>
    tnoremap <C-l> <C-\><C-n><C-w><Right>

  " ALT-Up/Down/Left/Right to resize splits.
    nnoremap <A-Right> :vertical resize -5<CR><C-L>
    inoremap <A-Right> <Esc>:vertical resize -5<CR><C-L>

    nnoremap <A-Left> :vertical resize +5<CR><C-L>
    inoremap <A-Left> <Esc>:vertical resize +5<CR><C-L>

    nnoremap <A-Up> :resize +2<CR><C-L>
    inoremap <A-Up> <Esc>:resize +2<CR><C-L>

    nnoremap <A-Down> :resize -2<CR><C-L>
    inoremap <A-Down> <Esc>:resize -2<CR><C-L>
