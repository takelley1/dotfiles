" OPTIONS ########################################################################################## {{{

    filetype indent plugin on             " Identify the filetype.
    syntax on                             " Force syntax highlighting.
    if has('termguicolors')
        set termguicolors                 " Enable 24-bit color support.
    endif

  " Change cursor to bar when switching to insert mode.
  " Requires `set -ga terminal-overrides ',*:Ss=\E[%p1%d q:Se=\E[2 q'` in tmux config.
    let &t_SI = "\e[6 q"
    let &t_EI = "\e[2 q"
    augroup insertbar
        autocmd!
        autocmd VimEnter * silent !echo -ne "\e[2 q"
    augroup END

    set encoding=utf-8                    " Force unicode encoding.
    set autoread                          " Auto update when a file is changed from the outside.
    set noshowmode                        " Don't show mode since it's handled by Airline.
    set noshowcmd                         " Don't show command on last line.

    set ignorecase                        " Case-insensitive search, except when using capitals.
    set smartcase                         " Override ignorecase if search contains capital letters.
    set wildmenu                          " Enable path autocompletion.
    set wildmode=longest,list,full
  " Don't auto-complete these filetypes.
    set wildignore+=*/.git/*,*/.svn/*,*/__pycache__/*,*.pyc,*.jpg,*.png,*.jpeg,*.bmp,*.gif,*.tiff,*.svg,*.ico,*.mp4,*.mkv,*.avi

    set autowriteall                      " Auto-save after certain events.
    set clipboard=unnamedplus             " Map vim copy buffer to system clipboard.
    set confirm                           " Require confirmation before doing certain destructive things.
    set splitbelow splitright             " Splits open at the bottom and right by default, rather than top and left.
    set noswapfile nobackup               " Don't use backups since most files are in Git.

    let g:python3_host_prog = '/usr/bin/python3' " Speed up startup.
    let g:loaded_python_provider = 0             " Disable Python 2 provider.

  " Disable Ex mode.
    noremap q: <Nop>
  " Screen redraws will clear search results.
    noremap <C-L> :nohl<CR><C-L>
  " Use cedit mode when entering command mode.
    nnoremap : :<C-f>

  " Persistent undo https://sidneyliebrand.io/blog/vim-tip-persistent-undo
    if has('persistent_undo')
        let target_path = expand('~/.vim/undo/')
        if !isdirectory(target_path)
            call system('mkdir -p ' . target_path)
        endif
        let &undodir = target_path
        set undofile
    endif

" }}}
" AUTOCOMMANDS ##################################################################################### {{{

  " Change to home directory on startup.
    augroup homecd
        autocmd!
        autocmd VimEnter * cd ~
    augroup END

    augroup autoupdate
        autocmd!
        " Automatically update file if changed from outside.
        autocmd FocusGained,BufEnter * checktime
        " Save on focus loss.
        autocmd BufLeave * silent! :wa
    augroup END

  " Switch to insert mode when entering or creating terminals.
    if has ('nvim')
        augroup termsettings
            autocmd!
            autocmd BufEnter * if &buftype == "terminal" | startinsert | endif
            autocmd TermOpen * setlocal nonumber | startinsert
        augroup END
    endif

  " https://vim.fandom.com/wiki/Set_working_directory_to_the_current_file
  " Set working dir to current file's dir.
    augroup filecd
        autocmd!
        autocmd BufEnter * silent! lcd %:p:h
    augroup END

  " https://github.com/jdhao/nvim-config/blob/master/core/autocommands.vim
  " Return to last position when re-opening file.
    augroup lastpos
        autocmd!
        autocmd BufReadPost if line("'\"") > 1 && line("'\"") <= line("$") && &ft !~# 'commit' | execute "normal! g`\"zvzz" | endif
    augroup END

" }}}
" FORMATTING ####################################################################################### {{{

    set number             " Show line numbers.
    set numberwidth=1      " Make line number column thinner.
    set scrolloff=999      " Force cursor to stay in the middle of the screen.

  " Indents are 4 spaces by default.
    set tabstop=4          " A <TAB> creates 4 spaces.
    set softtabstop=4
    set shiftwidth=4       " Number of auto-indent spaces.
    set expandtab          " Convert tabs to spaces.
    set noautoindent       " No automatic indenting.

    set linebreak          " Break line at predefined characters when soft-wrapping.
    set showbreak=↪        " Character to show before the lines that have been soft-wrapped.

  " Disable all auto-formatting.
    autocmd FileType * setlocal nocindent nosmartindent formatoptions-=c formatoptions-=r formatoptions-=o indentexpr=

  " Force certain filetypes to use indents of 2 spaces.
    autocmd FileType text,config,markdown,vim,yaml,*.md setlocal shiftwidth=2 softtabstop=2 tabstop=2

  " Don't wrap text on Markdown files.
    autocmd FileType markdown,*.md setlocal nowrap
  " Manual folding in vim files.
    autocmd FileType vim setlocal foldlevelstart=0 foldmethod=marker

" }}}
" SHORTCUTS ######################################################################################## {{{

  " Leader key easier to reach.
    let mapleader = ","

  " Faster saving.
    nnoremap <leader>w :write<CR><C-L>

  " Easily edit vimrc (ve for 'vim edit').
    nnoremap <leader>ve :split ~/.config/nvim/init.vim<CR>
  " Reload configuration without restarting vim (vs for 'vim source').
    nnoremap <leader>vs :update <bar> :source $MYVIMRC<CR><C-L>

  " Jump back and forth between files.
    nnoremap <BS> <C-^>

  " Columnize selection.
    vnoremap t :!column -t<CR>
  " Turn off highlighted search results.
    nnoremap Q :nohl<CR><C-L>

  " https://github.com/jdhao/nvim-config/blob/master/core/mappings.vim
  " Continuous visual shifting (does not exit Visual mode), `gv` means
  " to reselect previous visual area, see https://superuser.com/q/310417/736190
    xnoremap < <gv
    xnoremap > >gv

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

" }}}
" PLUGINS ########################################################################################## {{{

if has ('nvim')

  " Atttempt to install vim-plug if it isn't present.
    let target_path = expand('~/.local/share/nvim/site/autoload/plug.vim')
    if !filereadable(target_path)
        echo "Attempting to install vim-plug!"
        sleep 2
        call system('curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
                    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim')
    endif

  " Increase plugin update speed.
    set updatetime=500

  " Airline ---------------------------------------------------------------------------------------- {{{

    let g:airline_theme='palenight'
    let g:airline_highlighting_cache = 1

    " Disable unnecessary extensions.
      let g:airline#extensions#tagbar#enabled = 0
      let g:airline#extensions#po#enabled = 0
      let g:airline#extensions#netrw#enabled = 0
      let g:airline#extensions#keymap#enabled = 0
      let g:airline#extensions#fzf#enabled = 0

    let g:airline_powerline_fonts = 1                      " Use Nerd Fonts from Vim-devicons.

    let g:airline#extensions#tabline#enabled = 1
    let g:airline#extensions#tabline#fnamemod = ':p:t'     " Format filenames in tabline.

    let g:airline#extensions#tabline#enabled = 1           " Replace the tabline with Airline's.
    let g:airline#extensions#tabline#show_splits = 0       " Don't show splits in the tabline.
    let g:airline_detect_modified = 0                      " Don't loudly mark files as modified.
    let g:airline#extensions#tabline#show_tab_nr = 0       " Don't show tab numbers.
    let g:airline#extensions#tabline#show_tab_count = 0    " Don't show number of tabs on top-right.
    let g:airline#extensions#tabline#show_tab_type = 0     " Don't show tab type.
    let g:airline#extensions#tabline#show_close_button = 0 " Don't show tab close button.

  " }}}
  " ALE -------------------------------------------------------------------------------------------- {{{

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

  " }}}
  " Black ------------------------------------------------------------------------------------------ {{{

    " Run Black formatter before saving Python files.
      autocmd BufWritePre *.py execute ':Black'

  " }}}
  " COC -------------------------------------------------------------------------------------------- {{{

    " These configs are from https://github.com/neoclide/coc.nvim

    " Use K to show documentation in preview window.
      nnoremap <silent> K :call <SID>show_documentation()<CR>

    function! s:show_documentation()
        if(index(['vim','help'], &filetype) >= 0)
            execute 'h '.expand('<cword>')
        elseif (coc#rpc#ready())
            call CocActionAsync('doHover')
        else
            execute '!' . &keywordprg . " " . expand('<cword>')
        endif
    endfunction

    " Use TAB to trigger auto-complete.
      inoremap <silent><expr> <TAB>
            \ pumvisible() ? "\<C-n>" :
            \ <SID>check_back_space() ? "\<TAB>" :
            \ coc#refresh()
      inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

    function! s:check_back_space() abort
        let col = col('.') - 1
        return !col || getline('.')[col - 1]  =~# '\s'
    endfunction

  " }}}
  " CtrlP ------------------------------------------------------------------------------------------ {{{

    " CURRENTLY USING LEADERF INSTEAD OF CTRLP

    " <leader>s to start searching from home directory (s for 'search').
    " <leader>S to start searching from project directory.

    " CTRL-j and CTRL-k to navigate through results.
    " CTRL-t to open the desired file in a new tab.
    " CTRL-v to open the desired file in a new vertical split.

    "let g:ctrlp_map = '<leader>S'
    "nnoremap <leader>s :CtrlP ~<CR>

    let g:ctrlp_tabpage_position = 'ac'
    let g:ctrlp_working_path_mode = 'rw' " Set search path to start at first .git directory below the cwd.

    let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:15,results:15' " Change height of search window.
    let g:ctrlp_show_hidden = 1                                           " Index hidden files.
    let g:ctrlp_clear_cache_on_exit = 0                                   " Keep cache accross reboots.
    let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn|swp|cache|tmp)$'     " Don't index these filetypes in addition to Wildignore.

  " }}}
  " Devicons --------------------------------------------------------------------------------------- {{{

    " Enable Nerd Fonts (requires AUR package).
      set guifont=Nerd\ Font\ 11

    " https://github.com/ryanoasis/vim-devicons
    " Fix issues re-sourcing Vimrc.
      if exists("g:loaded_webdevicons")
        call webdevicons#refresh()
      endif

  " }}}
  " Fugitive --------------------------------------------------------------------------------------- {{{

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

  " }}}
  " GitGutter -------------------------------------------------------------------------------------- {{{

    " Make sidebar dark.
      highlight SignColumn cterm=bold ctermbg=0 guibg=0
    " Undo git changes easily.
      nnoremap gu :GitGutterUndoHunk<CR>
    " View interactive git diff.
      nnoremap gd :Gdiffsplit<CR>
    " Fix git diff colors.
      highlight DiffText ctermbg=1 ctermfg=3 guibg=1 guifg=3

  " }}}
  " Grepper ---------------------------------------------------------------------------------------- {{{

    " <leader>g to start grepping (g for 'grep').
    nnoremap <leader>G :Grepper -tool grep -cd ~/<CR>
    nnoremap <leader>g :Grepper -tool grep<CR>

  " }}}
  " Highlighted Yank ------------------------------------------------------------------------------- {{{

    let g:highlightedyank_highlight_duration = 200
    highlight link HighlightedyankRegion Search

  " }}}
  " LeaderF ---------------------------------------------------------------------------------------- {{{

    " <leader>s to start searching from home directory (s for 'search').
    " <leader>S to start searching from project directory.

    " CTRL-j and CTRL-k to navigate through results.
    "<C-X> : open in horizontal split window.
    "<C-]> : open in vertical split window.
    "<C-T> : open in new tabpage.

    nnoremap <leader>s :LeaderfFile ~/<CR>
    nnoremap <leader>S :LeaderfFile <CR>

    let g:Lf_ShowHidden = 1                        " Index hidden files.
    let g:Lf_PopupHeight = float2nr(&lines * 0.5)  " Set popup height low to allow for preview window.
    let g:Lf_PopupWidth = &columns * 0.8
    let g:Lf_WindowPosition = 'popup'              " Enable popup window.
    let g:Lf_PopupColorscheme = 'one'
    let g:Lf_PreviewCode = 1                       " Enable preview window.
    let g:Lf_PreviewInPopup = 1                    " Enable preview window in popup window.
    let g:Lf_PopupPreviewPosition = 'bottom'       " Place preview window below search results.
    let g:Lf_PopupPosition = [1, 0]                " Place popup window at top of screen.

    " Don't index the following dirs/files.
    let g:Lf_WildIgnore = {
            \ 'dir': ['.svn','.git','.hg','.cfg',
                    \ '.*cache','_*cache','.swp','.LfCache','.swt',
                    \ '.gnupg','.pylint.d','ansible-local-*',
                    \ '.cargo','.fltk','.icons','.password-store',
                    \ '.vim/undo','.mozilla','__pychache__'],
            \
            \ 'file': ['*.sw?','~$*',
                     \ '*.pyc','*.py1*','*.stats',
                     \ '*.gpg','*.kbx*','*.key','*.crt','*.*cert*','*.cer','*.der',
                     \ '*.so','*.msg','*.lock','*.*db*','*.*sql*','*.localstorage*','*.shada','*.pack','*.crate',
                     \ '*.vdi','*.vmdx','*.vmdk','*.dat','*.vhd','*.iso',
                     \ '*.pdf','*.odt','*.doc*','*.bau','*.dic','*.exc','*.fmt','*.thm','*.sdv',
                     \ '*.7z','*.*zip','*.tar.*','*.tar','*.tgz','*.gz','*.pick*','*.whl',
                     \ '*.jpg','*.png','*.jpeg','*.bmp','*.gif','*.tiff','*.svg','*.ico','*.webp',
                     \ '*.mp3','*.m4a','*.aac',
                     \ '*.mp4','*.mkv','*.avi']
            \}

    " Automatically preview the following results.
    let g:Lf_PreviewResult = {
            \ 'File': 1,
            \ 'Buffer': 1,
            \ 'Mru': 1,
            \ 'Tag': 1,
            \ 'BufTag': 1,
            \ 'Function': 1,
            \ 'Line': 1,
            \ 'Colorscheme': 0,
            \ 'Rg': 0,
            \ 'Gtags': 0
            \}

  " }}}
  " Markdown Preview ------------------------------------------------------------------------------- {{{

    " Markdown preview with mp.
      autocmd FileType markdown nnoremap mp :MarkdownPreview<CR><C-L>

      "let g:mkdp_auto_start = 1  " Automatically launch rendered markdown in browser.
      let g:mkdp_auto_close = 1   " Automatically close rendered markdown in browser.

    " Use vimb since Firefox won't automatically close the rendered markdown window.
      let g:mkdp_browser = 'vimb'

  " }}}
  " NERD Commenter --------------------------------------------------------------------------------- {{{

    " <leader>cc to comment a block.
    " <leader>cu to uncomment a block.
    let g:NERDSpaceDelims = 1
    let g:NERDDefaultAlign = 'left'

  " }}}
  " Rnvimr ----------------------------------------------------------------------------------------- {{{

    " <leader>f to open file manager.
    nnoremap <silent> <leader>f :RnvimrToggle<CR>

    let g:rnvimr_enable_ex = 1                      " Replace NetRW.
    let g:rnvimr_enable_picker = 1                  " Hide Ranger after picking file.
    let g:rnvimr_enable_bw = 1                      " Make Neovim wipe buffers corresponding to the files deleted by Ranger.
    let g:rnvimr_border_attr = {'fg': 14, 'bg': -1} " Set border color.
    let g:rnvimr_ranger_cmd = 'ranger --cmd="set draw_borders both"'

    " Link CursorLine into RnvimrNormal highlight in the Floating window
    highlight link RnvimrNormal CursorLine

    " Map Rnvimr actions.
    " CTRL-e to open file in new tab.
    " CTRL-l and CTRL-v to open file in new split or vsplit.
    let g:rnvimr_action = {
                \ '<C-e>': 'NvimEdit tabedit',
                \ '<C-l>': 'NvimEdit split',
                \ '<C-v>': 'NvimEdit vsplit',
                \ 'gw': 'JumpNvimCwd',
                \ 'yw': 'EmitRangerCwd',
                \ }

    " Set floating initial size relative to 90% of parent window size.
      let g:rnvimr_layout = {
                  \ 'relative': 'editor',
                  \ 'width': float2nr(round(0.9 * &columns)),
                  \ 'height': float2nr(round(0.9 * &lines)),
                  \ 'col': float2nr(round(0.05 * &columns)),
                  \ 'row': float2nr(round(0.05 * &lines)),
                  \ 'style': 'minimal'
                  \ }

  " }}}
  " Session ---------------------------------------------------------------------------------------- {{{

    " Run ':SaveSession <SESSION NAME>' to save your preferred editor configuration.
    " Run ':OpenSession! <SESSION NAME>' to restore config.

  " }}}
  " Tagbar ----------------------------------------------------------------------------------------- {{{

    " Launch the tagbar by default when opening Python files.
      autocmd FileType python TagbarToggle

  " }}}
  " Undotree --------------------------------------------------------------------------------------- {{{

    " <leader>u to open Vim's undo tree.
    nnoremap <leader>u :UndotreeToggle<CR>

  " }}}
  " Vim-Plug --------------------------------------------------------------------------------------- {{{

  call plug#begin(stdpath('data') . '/plugged')

    " Navigation -----------------------------------------------------
        " Search within files.
          Plug 'mhinz/vim-grepper', { 'on': 'Grepper' }
        " Filename search.
          Plug 'Yggdroot/LeaderF'
          "Plug 'ctrlpvim/ctrlp.vim'
          "Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
          "Plug 'junegunn/fzf.vim'
          "Plug 'wincent/command-t'
        " Embedded floating Ranger window.
          Plug 'kevinhwang91/rnvimr'
        " Smooth scrolling.
          Plug 'psliwka/vim-smoothie'

    " Programming ----------------------------------------------------
        " Git integration.
          Plug 'airblade/vim-gitgutter'
          Plug 'tpope/vim-fugitive'
        " Python code formatter.
          Plug 'psf/black', { 'for': 'python', 'branch': 'stable' }
        " Better syntax highlighting.
          Plug 'sheerun/vim-polyglot'
        " Function navigation on large files.
          Plug 'preservim/tagbar'
        " Code completion.
          Plug 'neoclide/coc.nvim', { 'branch': 'release' }
        " Linting engine.
          Plug 'dense-analysis/ale'
        " Auto-create bracket and quote pairs.
          "Plug 'jiangmiao/auto-pairs'
        " Show indentation lines.
          Plug 'yggdroot/indentline'

    " Usability ------------------------------------------------------
        " Colorschemes.
          Plug 'drewtempelmeyer/palenight.vim'
          "Plug 'morhetz/gruvbox'
          "Plug 'joshdick/onedark.vim'

        " Session save and restore.
          Plug 'xolox/vim-misc', { 'on': ['SaveSession', 'OpenSession', 'OpenSession!'] }
          Plug 'xolox/vim-session', { 'on': ['SaveSession', 'OpenSession', 'OpenSession!'] }
        " Status bar.
          Plug 'vim-airline/vim-airline'
          Plug 'vim-airline/vim-airline-themes'
        " Easily comment blocks.
          Plug 'preservim/nerdcommenter'
          Plug 'iamcco/markdown-preview.nvim', { 'for': 'markdown' }
        " Visualize and navigate Vim's undo tree.
          Plug 'mbbill/undotree'
        " Auto-save file after period if inactivity.
          Plug '907th/vim-auto-save'
        " Briefly highlight yanked text.
          Plug 'machakann/vim-highlightedyank'
        " Icons (Must be loaded after all the plugins that use it).
          Plug 'ryanoasis/vim-devicons'


  call plug#end()
" }}}
  " Colors ----------------------------------------------------------------------------------------- {{{

    " Change comment color from grey to turquoise.
    " Make white a bit brighter.
    let g:palenight_color_overrides = {
    \    'comment_grey': { 'gui': '#7ad3ff', "cterm": "59", "cterm16": "15" },
    \    'white': { 'gui': '#d3dae8', "cterm": "59", "cterm16": "15" },
    \}
    " This has to come AFTER Vim-plug, which is why it's after all the other plugins.
    colorscheme palenight

  " }}}

endif

" }}}
" NAVIGATION ####################################################################################### {{{

  " Easier exiting insert mode.
    inoremap jk <Esc>
    if has('nvim') | tnoremap <C-x> <C-\><C-n> | endif

  " Easier navigating soft-wrapped lines.
    nnoremap j gj
    nnoremap k gk

  " Quickly open a terminal tab or split.
    nnoremap <leader>t :tabnew <bar> terminal<CR>
    nnoremap <leader>tn :tabnew <bar> terminal<CR>
    nnoremap <leader>tt :tabnew <bar> terminal<CR>
    nnoremap <leader>ts :split <bar> terminal<CR>
    nnoremap <leader>tv :vsplit <bar> terminal<CR>

  " CTRL-n/p to navigate tabs.
    nnoremap <silent> <C-p> :tabprevious<CR>
    inoremap <silent> <C-p> <Esc>:tabprevious<CR>
    nnoremap <silent> <C-n> :tabnext<CR>
    inoremap <silent> <C-n> <Esc>:tabnext<CR>

  " Jump to last active tab (a for 'alternate').
    autocmd TabLeave * let g:lasttab = tabpagenr()
    nnoremap <leader>a :exe "tabn ".g:lasttab<CR>

  " Create and delete tabs web-browser-style.
  " Open Ranger on new splits and tabs by default.
    nnoremap <C-t> :tabnew<CR>
    inoremap <C-t> <Esc>:tabnew<CR>
    nnoremap <C-w> :tabclose<CR>
    inoremap <C-w> <Esc>:tabclose<CR>

  " https://breuer.dev/blog/top-neovim-plugins.html
  " If a split exists, navigate to it. Otherwise, create a split.
    function! WinMove(key)
        let t:curwin = winnr()
        exec "wincmd ".a:key
        if (t:curwin == winnr())
            if (match(a:key,'[jk]'))
                vsplit
            else
                split
            endif
            exec "wincmd ".a:key
        endif
    endfunction

  " CTRL-h/j/k/l to navigate and create splits.
    nnoremap <silent> <C-k> :call WinMove('k')<CR>
    inoremap <silent> <C-k> :call WinMove('k')<CR>

    nnoremap <silent> <C-j> :call WinMove('j')<CR>
    inoremap <silent> <C-j> :call WinMove('j')<CR>

    nnoremap <silent> <C-h> :call WinMove('h')<CR>
    inoremap <silent> <C-h> :call WinMove('h')<CR>

    nnoremap <silent> <C-l> :call WinMove('l')<CR>
    inoremap <silent> <C-l> :call WinMove('l')<CR>

  " ALT-Up/Down/Left/Right to resize splits.
    nnoremap <A-Right> :vertical resize -5<CR><C-L>
    inoremap <A-Right> <Esc>:vertical resize -5<CR><C-L>

    nnoremap <A-Left> :vertical resize +5<CR><C-L>
    inoremap <A-Left> <Esc>:vertical resize +5<CR><C-L>

    nnoremap <A-Up> :resize +2<CR><C-L>
    inoremap <A-Up> <Esc>:resize +2<CR><C-L>

    nnoremap <A-Down> :resize -2<CR><C-L>
    inoremap <A-Down> <Esc>:resize -2<CR><C-L>

  " Same shortcuts but from within a terminal.
    if has('nvim')
        tnoremap <C-n> <C-\><C-n>:tabnext<CR>
        tnoremap <C-p> <C-\><C-n>:tabprevious<CR>
        tnoremap <leader>a <C-\><C-n>:exe "tabn ".g:lasttab<CR>

        tnoremap <silent> <C-t> <C-\><C-n>:tabnew<CR>
        tnoremap <silent> <C-w> <C-\><C-n>:tabclose<CR>

        tnoremap <silent> <C-k> <C-\><C-n>:call WinMove('k')<CR>
        tnoremap <silent> <C-j> <C-\><C-n>:call WinMove('j')<CR>
        tnoremap <silent> <C-h> <C-\><C-n>:call WinMove('h')<CR>
        tnoremap <silent> <C-l> <C-\><C-n>:call WinMove('l')<CR>

        tnoremap <silent> <A-1> <C-\><C-n>1gt<CR>
        tnoremap <silent> <A-2> <C-\><C-n>2gt<CR>
        tnoremap <silent> <A-3> <C-\><C-n>3gt<CR>
        tnoremap <silent> <A-4> <C-\><C-n>4gt<CR>
        tnoremap <silent> <A-5> <C-\><C-n>5gt<CR>
        tnoremap <silent> <A-6> <C-\><C-n>6gt<CR>
        tnoremap <silent> <A-7> <C-\><C-n>7gt<CR>
        tnoremap <silent> <A-8> <C-\><C-n>8gt<CR>
        tnoremap <silent> <A-9> <C-\><C-n>9gt<CR>

        tnoremap <A-Left> <C-\><C-n>:vertical resize -5<CR><C-L>
        tnoremap <A-Right> <C-\><C-n>:vertical resize +5<CR><C-L>
        tnoremap <A-Up> <C-\><C-n>:resize +2<CR><C-L>
        tnoremap <A-Down> <C-\><C-n>:resize -2<CR><C-L>
    endif

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

" }}}
