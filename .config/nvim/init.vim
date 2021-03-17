"{% raw %}
" OPTIONS ##################################################################################### {{{

  " Determine if system is at home or at work.
  let hostname = substitute(system('hostname'), '\n', '', '')
  if hostname ==# "polaris" || "tethys"
    let g:athome = 1
    let g:atwork = 0
  else
    let g:athome = 0
    let g:atwork = 1
  endif

  filetype indent plugin on             " Identify the filetype, load indent and plugin files.
  syntax on                             " Force syntax highlighting.
  if g:athome
    if has('termguicolors')
      set termguicolors                 " Enable 24-bit color support.
    endif
  endif

  set lazyredraw                        " Don't redraw screen during macros.
  set autoread                          " Auto update when a file is changed from the outside.
  set noshowmode                        " Don't show mode since it's handled by Airline.
  set noshowcmd                         " Don't show command on last line.
  set hidden                            " Hide abandoned buffers.

  set ignorecase                        " Case-insensitive search, except when using capitals.
  set smartcase                         " Override ignorecase if search contains capital letters.
  set wildmenu                          " Enable path autocompletion.
  set wildmode=longest,list,full
  " Don't auto-complete these filetypes.
  set wildignore+=*/.git/*,*/.svn/*,*/__pycache__/*,*.pyc,*.jpg,*.png,*.jpeg,*.bmp,*.gif,*.tiff,*.svg,*.ico,*.mp4,*.mkv,*.avi

  set autowriteall                      " Auto-save after certain events.
  set clipboard+=unnamedplus            " Map vim copy buffer to system clipboard.
  set splitbelow splitright             " Splits open at the bottom and right, rather than top/left.
  set noswapfile nobackup               " Don't use backups since most files are in Git.
  set updatetime=300                    " Increase plugin update speed.

  if g:athome
    let g:python3_host_prog = '/usr/bin/python3' " Speed up startup.
    let g:loaded_python_provider = 0             " Disable Python 2 provider.
  endif

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
" AUTOCOMMANDS ################################################################################ {{{

  " https://gist.github.com/romainl/6e4c15dfc4885cb4bd64688a71aa7063#protip
  augroup mygroup
    autocmd!
  augroup END

  " Change cursor to bar when switching to insert mode.
  " Requires `set -ga terminal-overrides ',*:Ss=\E[%p1%d q:Se=\E[2 q'` in tmux config if using tmux.
  let &t_SI = "\e[6 q"
  let &t_EI = "\e[2 q"
  autocmd mygroup VimEnter * silent !echo -ne "\e[2 q"

  " Clear search results when entering insert mode.
  " This can make it more difficult to do find-replace actions.
  " autocmd mygroup InsertEnter * let @/ = ''

  " Update file if changed from outside.
  autocmd mygroup FocusGained,BufEnter * if &readonly ==# 0 | silent! checktime | endif
  " Auto-save file.
  autocmd mygroup InsertLeave,BufLeave,CursorHold * if &readonly ==# 0 | silent! write | endif

  " Manage insert mode when entering terminals ------------------------------------------------ {{{
  if exists(':terminal')
    autocmd mygroup BufEnter * :call TermInsert()
    autocmd mygroup TermOpen * setlocal nonumber | startinsert
  endif
  " This function emulates tmux's scrollback functionality. Nvim will only enter insert mode if the
  "   user's cursor is on the terminal prompt. Nvim will NOT enter insert mode if the user is
  "   viewing the terminal's scrollback buffer (see comment below for an exception).
  function! TermInsert()
    if &buftype ==# "terminal"
      " Determine number of lines visible in the current terminal buffer/split.
      let b:bufheight = line("w$") - line("w0")
      let b:bufheight_adjusted = b:bufheight + 1
      " Enter insert mode if the number of total lines is equal to the line the cursor is on.
      if line("$") == line(".")
        startinsert
      " Terminal prompts start at the top of the buffer and move to the bottom as the buffer scrolls.
      " If the promt isn't at the bottom of the buffer yet, start insert mode since there's no way
      "   to reliably check whether the cursor is on the prompt.
      " The additional check using b:bufheight_adjusted allows scrolling back beyond the top of
      "   the buffer's current view.
      elseif line(".") <= b:bufheight && line("$") <= b:bufheight_adjusted
        startinsert
      endif
      setlocal nonumber
    endif
  endfunction
  " }}}

  " Switch to normal mode when entering all other buffers.
  autocmd mygroup BufEnter * if &buftype !=# "terminal" | stopinsert | endif

  " https://vim.fandom.com/wiki/Set_working_directory_to_the_current_file
  " Set working dir to current file's dir.
  autocmd mygroup BufEnter * silent! lcd %:p:h

  if g:athome
    " Change to home directory on startup.
    autocmd mygroup VimEnter * cd ~
  elseif g:atwork
    autocmd mygroup VimEnter *
      \ if isdirectory($HOME . '/scripts/ansible') | cd ~/scripts/ansible | endif
  endif

  " https://github.com/jdhao/nvim-config/blob/master/core/autocommands.vim
  " Return to last position when re-opening file.
  autocmd mygroup BufReadPost
    \ if line("'\"") > 1 && line("'\"") <= line("$") && &ft !~# 'commit' |
      \ execute "normal! g`\"zvzz" | endif

  " Quickly commit and push updates to notes.
  " The QuitPre event will trigger even when exiting with ZZ.
  if g:athome
    autocmd mygroup QuitPre ~/notes/unsorted.md
      \ silent :!git -C ~/notes commit -m 'Update unsorted.md' unsorted.md && git push -C ~/notes
  endif

  " https://stackoverflow.com/a/8459043
  function! DeleteHiddenBuffers()
    let tpbl=[]
    call map(range(1, tabpagenr('$')), 'extend(tpbl, tabpagebuflist(v:val))')
    for buf in filter(range(1, bufnr('$')), 'bufexists(v:val) && index(tpbl, v:val)==-1')
        silent! execute 'bdelete!' buf
    endfor
  endfunction

  " Automatically close leftover hidden buffers.
  " This is usually leftover terminal and ranger windows.
  " Don't trigger when in Vimagit buffers, since it will kill the buffer Magit() was called from.
  autocmd mygroup CursorHold,TabEnter *
      \ silent! if &filetype != "magit" | call DeleteHiddenBuffers() | endif

  " Auto-write files at work ------------------------------------------------------------------ {{{
  if g:atwork

    " Automatically create SSH aliases file from Ansible inventory file.
    autocmd mygroup BufWritePost
      \ ~/scripts/ansible/inventories/s3noc/hosts.yml
      \ silent :!sed '/^\s*#/d'
      \ ~/scripts/ansible/inventories/s3noc/hosts.yml
      \ | awk '/[a-zA-Z_-]*:(#.*)*$/ {FS=".";gsub(/[\t| |\:]/,"");host=tolower($1);FS=" "}
      \ /^\s*[^\#]*ansible_host/ {ip=$2;print "Host " host "\n\t HostName " ip}'
      \ | tee ~/scripts/ansible/inventories/global_files/home/akelley/.ssh/config
      \ ~/.ssh/config

    autocmd mygroup BufWritePost
      \ ~/scripts/ansible/inventories/global_files/home/akelley/.vimrc
      \ silent :!cp -f ~/scripts/ansible/inventories/global_files/home/akelley/.vimrc
      \ ~/.config/nvim/init.vim

    " Automatically copy changes from ansible repo to personal dotfiles.
    " Use sed to remove the 'Ansible managed' header.
    autocmd mygroup BufWritePost
      \ ~/scripts/ansible/inventories/global_files/home/akelley/.bashrc
      \ silent :!sed '0,/ansible_managed/d'
      \ ~/scripts/ansible/inventories/global_files/home/akelley/.bashrc
      \ > ~/.bashrc

    autocmd mygroup BufWritePost
      \ ~/scripts/ansible/inventories/global_files/home/akelley/.tmux.conf
      \ silent :!sed '0,/ansible_managed/d'
      \ ~/scripts/ansible/inventories/global_files/home/akelley/.tmux.conf
      \ > ~/.tmux.conf

    autocmd mygroup BufWritePost
      \ ~/scripts/ansible/inventories/global_files/home/akelley/.bash_profile
      \ silent :!sed '0,/ansible_managed/d'
      \ ~/scripts/ansible/inventories/global_files/home/akelley/.bash_profile
      \ ~/.bash_profile
  endif
  " }}}

" }}}
" FORMATTING ################################################################################## {{{

  set encoding=utf-8     " Force unicode encoding.
  set number             " Show line numbers.
  set numberwidth=1      " Make line number column thinner.

  set tabstop=2          " A <TAB> creates 2 spaces.
  set softtabstop=2
  set shiftwidth=2       " Number of auto-indent spaces.
  set expandtab          " Convert tabs to spaces.
  set foldmethod=manual foldlevelstart=99  " Don't fold by default.

  set linebreak          " Break line at predefined characters when soft-wrapping.
  " For some reason setting these options only works within an autocommand.
  autocmd mygroup BufEnter * setlocal formatoptions=q noautoindent nocindent nosmartindent indentexpr=

  " Gitcommit -- used by Lazygit -------------------------------------
    autocmd mygroup FileType gitcommit setlocal
      \ colorcolumn=80 textwidth=80
      \ formatoptions=qt
      \ nonumber
  " Help -------------------------------------------------------------
    autocmd mygroup FileType help setlocal
      \ nonumber
  " Markdown ---------------------------------------------------------
    autocmd mygroup FileType markdown setlocal
      \ colorcolumn=120
    autocmd mygroup BufEnter *.md setlocal
      \ foldlevelstart=-1 concealcursor= conceallevel=1
  " Python -----------------------------------------------------------
    autocmd mygroup FileType python setlocal
      \ shiftwidth=4 softtabstop=4 tabstop=4
      \ colorcolumn=100
  " Shell ------------------------------------------------------------
    autocmd mygroup FileType sh setlocal
      \ shiftwidth=4 softtabstop=4 tabstop=4
      \ foldlevelstart=0 foldmethod=marker
      \ colorcolumn=120
  " TeX --------------------------------------------------------------
    autocmd mygroup FileType tex setlocal
      \ colorcolumn=120 textwidth=120
    autocmd mygroup BufEnter *.tex setlocal
      \ concealcursor= conceallevel=0
  " VimScript --------------------------------------------------------
    autocmd mygroup FileType vim setlocal
      \ foldlevelstart=0 foldmethod=marker
      \ colorcolumn=100
  " YAML -------------------------------------------------------------
    autocmd mygroup FileType yaml,yaml.ansible setlocal
      \ colorcolumn=120

  " Force cursor to stay in the middle of the screen.
  set scrolloff=999
  " Scrolloff is glitchy on terminals, so disable it there.
  if exists(':terminal') && exists('##TermEnter')
    autocmd mygroup TermEnter * silent setlocal scrolloff=0
    autocmd mygroup TermLeave * silent setlocal scrolloff=999
  endif

  " Automatically set winfixheight and winfixwidth.
  function! SetFixWindow()
    if winwidth('$') > winheight('$')
      setlocal nowinfixwidth
      setlocal winfixheight
    elseif winwidth('$') < winheight('$')
      setlocal nowinfixheight
      setlocal winfixwidth
    endif
  endfunction
  " autocmd mygroup BufEnter * call SetFixWindow() " This doesn't seem to help with splits resizing.

" }}}
" SHORTCUTS ################################################################################### {{{

  " Leader key easier to reach.
  let mapleader = ","
  " Faster saving.
  nnoremap <silent> <leader>w :write<CR><C-L>
  " Jump back and forth between files.
  noremap <silent> <BS> :e#<CR><C-L>

  " Use `call P('highlight')` to put the output of `highlight` in the current buffer,
  "   allowing the content to be searched through.
  function! P(command)
    let opts = {
      \ 'relative': 'editor',
      \ 'style': 'minimal',
      \ 'width': float2nr(round(0.55 * &columns)),
      \ 'height': float2nr(round(0.75 * &lines)),
      \ 'col': float2nr(round(0.27 * &columns)),
      \ 'row': float2nr(round(0.05 * &lines)),
      \ }
    let float_buffer = nvim_create_buf(v:false, v:true)
    let win = nvim_open_win(float_buffer, v:true, opts)
    set filetype=floating
    put =execute(a:command)
    normal! ggdj
  endfunction
  " Mimic less's mappings.
  autocmd FileType floating nnoremap <buffer> <space> <C-d>
  autocmd FileType floating nnoremap <buffer> b       <C-u>
  autocmd FileType floating nnoremap <buffer> q       :close!<CR>
  autocmd FileType floating nnoremap <buffer> Q       :close!<CR>
  autocmd FileType floating nnoremap <buffer> <CR>    :close!<CR>
  autocmd FileType floating nnoremap <buffer> <Esc>   :close!<CR>
  autocmd FileType floating
    \ setlocal bufhidden=delete shiftwidth=3 scrolloff=999 nonumber

  " Toggle preventing horizonal or vertial resizing.
  nnoremap <leader>H :set winfixheight! <bar> set winfixheight?<CR>
  nnoremap <leader>W :set winfixwidth! <bar> set winfixwidth?<CR>

  " Columnize selection.
  vnoremap t :!column -t<CR>
  " Turn off highlighted search results.
  nnoremap <silent> Q :nohl<CR><C-L>
  " Easy turn on paste mode.
  nnoremap <leader>p :set paste!<CR>
  nnoremap <space> za
  " Insert space.
  " nnoremap <space> i<space><ESC>
  " Insert line break.
  " nnoremap <CR> i<CR><ESC>  " This will break lazygit.

  " https://github.com/jdhao/nvim-config/blob/master/core/mappings.vim
  " Continuous visual shifting (does not exit Visual mode), `gv` means
  " to reselect previous visual area, see https://superuser.com/q/310417/736190
  "xnoremap < <gv
  "xnoremap > >gv

  " Easily edit vimrc (ve for 'vim edit').
  if g:athome
    nnoremap <leader>ve :edit ~/.config/nvim/init.vim<CR>
    if exists(':terminal')
      tnoremap <leader>ve <C-\><C-n>:edit ~/.config/nvim/init.vim<CR>
    endif
  elseif g:atwork
    nnoremap <leader>ve :edit
      \ ~/scripts/ansible/inventories/global_files/home/akelley/.vimrc<CR>
  endif
  " Reload configuration without restarting vim (vs for 'vim source').
  nnoremap <leader>vs :update <bar> :source $MYVIMRC<CR><C-L>
  " Quickly save and quit everything to restart neovim.
  nnoremap <leader>Q :wqa!<CR>

  " Quickly add a note while working on something else.
  function! Notes()
    silent !printf "\n\%s\n\n" "[$(date +\%Y\%m\%d)] $(date +\%A,\ \%b\ \%d\ \%H:\%M:\%S)" >>
      \ ~/notes/unsorted.md
    split ~/notes/unsorted.md
    normal! Go
  endfunction

  if g:athome
    nnoremap <leader>n :call Notes()<CR>
    command! Note      call Notes()

    command! Todo      edit ~/notes/personal--todo.md
    command! I3b       edit ~/.config/i3/i3blocks.conf
    command! I3cc      edit ~/.config/i3/config-shared
    command! I3ccc     edit /tmp/.i3-config
    command! I3        tabnew | cd ~/.config/i3/ | RnvimrToggle
    command! Status    tabnew | cd ~/.config/i3/scripts/status-bar/ | RnvimrToggle
    command! Bashrc    tabnew | cd ~/.bashrc | RnvimrToggle
    command! Alacritty tabnew | cd ~/.config/alacritty | RnvimrToggle

  " Dotfiles (Vim-fugitive doesn't support --git-dir option)
    nnoremap da :write<CR> :!git --git-dir=$HOME/.cfg/ --work-tree=$HOME add %<CR><C-L>
    nnoremap ds :!git --git-dir=$HOME/.cfg/ --work-tree=$HOME status --untracked-files=no<CR>
    nnoremap dl :!git --git-dir=$HOME/.cfg/ --work-tree=$HOME log<CR>
    nnoremap dP :!git --git-dir=$HOME/.cfg/ --work-tree=$HOME push<CR>
    nnoremap dp :!git --git-dir=$HOME/.cfg/ --work-tree=$HOME pull<CR>
    " *dot diff unstaged*
    nnoremap diu :!git --git-dir=$HOME/.cfg/ --work-tree=$HOME diff<CR>
    " *dot diff staged*
    nnoremap dis :!git --git-dir=$HOME/.cfg/ --work-tree=$HOME diff --staged<CR>
    " *dot commit file*
    nnoremap dcf :write<CR> :!git --git-dir=$HOME/.cfg/ --work-tree=$HOME commit % -m '
    " *dot commit staged*
    nnoremap dcs :!git --git-dir=$HOME/.cfg/ --work-tree=$HOME commit -m '
    " *dot commit --amend*
    nnoremap dca :!git --git-dir=$HOME/.cfg/ --work-tree=$HOME commit % -C HEAD --amend

    nnoremap drm :!git --git-dir=$HOME/.cfg/ --work-tree=$HOME rm
    nnoremap drs :!git --git-dir=$HOME/.cfg/ --work-tree=$HOME restore
  endif

" }}}
" PLUGINS ##################################################################################### {{{

  if has('nvim')
  " Vim-Plug ---------------------------------------------------------------------------------- {{{

    call plug#begin(stdpath('data') . '/plugged')

      Plug '~/ansible-doc.vim'

      " This autocmd can replace vim-highlightedyank in 0.5
      " autocmd mygroup TextYankPost * silent! lua require'vim.highlight'.on_yank("IncSearch", 1000)

      " Plug 'tmhedberg/SimpylFold'  " Better folding in Python.
      Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}  " Python code highlighting.
      Plug 'kdheepak/lazygit.nvim', { 'branch': 'nvim-v0.4.3' }
      " Plug 'APZelos/blamer.nvim'            " Git blame
      " Plug 'f-person/git-blame.nvim'        " Git blame on each line. Requires lua
      " Plug 'kevinhwang91/nvim-bqf'        " Better quickfix window.
      Plug 'ntpeters/vim-better-whitespace' " Highlight and strip whitespace.
      Plug 'tpope/vim-obsession'            " Session management.
      Plug 'tpope/vim-endwise'              " Auto terminate conditional statements.
      Plug 'tpope/vim-surround'             " Easily surround words.
      Plug 'tpope/vim-eunuch'               " Better shell commands.
      Plug 'tpope/vim-repeat'               " Repeat plugin actions.
      Plug 'brooth/far.vim'                 " Find and replace.
      Plug 'Konfekt/FastFold'               " More performant folding.
      Plug 'tpope/vim-unimpaired'           " Navigation with square bracket keys.
      " Plug 'easymotion/vim-easymotion'    " Alternative line navigation.
      Plug 'pearofducks/ansible-vim'        " Ansible syntax.
      Plug 'ekalinin/Dockerfile.vim'        " Dockerfile syntax.
      " Plug 'vim-scripts/YankRing.vim'     " Access previously yanked text.
      Plug 'gcmt/taboo.vim'                 " Rename tabs.
      Plug 'wesQ3/vim-windowswap'           " Easily swap window splits with <leader>ww
      Plug 'godlygeek/tabular'              " Alignment tools.
      Plug 'plasticboy/vim-markdown'        " Better markdown syntax highlighting.
      Plug 'jreybert/vimagit'               " Git porcelain.
      Plug 'psf/black', { 'for': 'python', 'branch': 'stable' } " Code formatting.
      Plug 'jiangmiao/auto-pairs'           " Auto-create bracket and quote pairs.
      Plug 'yggdroot/indentline'            " Show indentation lines.
      Plug 'machakann/vim-highlightedyank'  " Briefly highlight yanked text.
      Plug 'preservim/tagbar'               " Function navigation on large files.
      " Plug 'sheerun/vim-polyglot'         " Better syntax highlighting. Causes issues in Vimagit window.
      " Plug 'psliwka/vim-smoothie'         " Smooth scrolling.
      Plug 'mbbill/undotree'                " Visualize and navigate Vim's undo tree.
      Plug 'airblade/vim-gitgutter'         " Git diffs in sidebar.
      Plug 'dense-analysis/ale'             " Linting engine.
      Plug 'tpope/vim-fugitive'             " Git wrapper.
      Plug 'mhinz/vim-grepper'              " Search within files.
      Plug 'vim-airline/vim-airline'        " Status bar.
      Plug 'vim-airline/vim-airline-themes'
      Plug 'preservim/nerdcommenter'        " Comment blocks.
      Plug 'kevinhwang91/rnvimr'             " Ranger in a floating window.

      if g:athome
        Plug 'lervag/vimtex'                   " LaTeX helpers.
        Plug 'xuhdev/vim-latex-live-preview'   " LaTeX live preview.
        Plug 'drewtempelmeyer/palenight.vim'   " Colorschemes.
        Plug 'ryanoasis/vim-devicons'          " Icons (Must be loaded after all the plugins that use it).
        Plug 'lambdalisue/suda.vim'            " Edit files with sudo. This causes performance issues at work.
        Plug 'ycm-core/YouCompleteMe', { 'do': './install.py' }                  " Code completion.
        Plug 'Yggdroot/LeaderF', { 'do': ':LeaderfInstallCExtension' }           " Fuzzy finder.
        Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  } " Render markdown.
        " Plug 'vimwiki/vimwiki', { 'branch': 'dev' } " Note management.
      elseif g:atwork
        Plug 'ctrlpvim/ctrlp.vim'              " Fuzzy finder.
      endif

    call plug#end()
  " }}}

  " Install Vim-Plug -------------------------------------------------------------------------- {{{

    " Attempt to install vim-plug if it isn't present.
    " if !filereadable($HOME . '/.local/share/nvim/site/autoload/plug.vim')
    "   echo "Attempting to install vim-plug!" | sleep 2
    "   silent !curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
    "           https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim')
    "   autocmd mygroup VimEnter * PlugInstall
    " endif

  " }}}
  " Auto Pairs -------------------------------------------------------------------------------- {{{

    " Don't auto-pair anything by default.
    let g:AutoPairs={}

    " Only activate auto-pair for the below strings and filetypes.
    autocmd mygroup FileType yaml.ansible,jinja2,sh,markdown,tex
      \ let b:AutoPairs=AutoPairsDefine
      \ ({
      \ '<br>':'<br>',
      \ '"{{':'}}"',
      \ '{{':'}}',
      \ "'{{":"}}'",
      \ '{%':'%}',
      \ "[[:":":]]",
      \ '"${':'}"',
      \ '${':'}',
      \ '"$(':')"',
      \ '$(':')',
      \ '"""':'"""',
      \ "'''":"'''"
      \ })

  " }}}
  " Airline ----------------------------------------------------------------------------------- {{{

    if g:athome
      let g:airline_theme='palenight'
      " Use Nerd Fonts from Vim-devicons.
      let g:airline_powerline_fonts = 1
    elseif g:atwork
      let g:airline_theme='dark'
    endif

    let g:airline_highlighting_cache = 1
    let g:airline_detect_modified = 0 " Don't loudly mark files as modified.

    " Disable unnecessary extensions.
    let g:airline#extensions#grepper#enabled = 0
    let g:airline#extensions#tagbar#enabled = 0
    let g:airline#extensions#po#enabled = 0
    let g:airline#extensions#netrw#enabled = 0
    let g:airline#extensions#keymap#enabled = 0
    let g:airline#extensions#fzf#enabled = 0

    " The tabline incorrectly displays terminal buffers, so disable it.
    " let g:airline#extensions#tabline#show_buffers = 0      " Don't show buffers when a single tab is open.
    " let g:airline#extensions#tabline#fnamemod = ':p:t'     " Format filenames in tabline.
    " let g:airline#extensions#tabline#enabled = 1           " Replace the tabline with Airline's.
    " let g:airline#extensions#tabline#show_splits = 0       " Don't show splits in the tabline.
    " let g:airline#extensions#tabline#show_tab_nr = 0       " Don't show tab numbers.
    " let g:airline#extensions#tabline#show_tab_count = 0    " Don't show number of tabs on top-right.
    " let g:airline#extensions#tabline#show_tab_type = 0     " Don't show tab type.
    " let g:airline#extensions#tabline#show_close_button = 0 " Don't show tab close button.

  " }}}
  " ALE --------------------------------------------------------------------------------------- {{{

    " Have ALE remove extra whitespace and trailing lines.
    let g:ale_fixers = {'*': ['remove_trailing_lines', 'trim_whitespace', 'latexindent']}

    let g:ale_fix_on_save = 1  " ALE will fix files automatically when they're saved.
    let g:ale_lint_delay = 300 " Increase linting speed.

    " Bash
    let g:ale_sh_bashate_options = '--ignore "E043,E006"'
    " Python
    let g:ale_python_flake8_options = '--config ~/.config/nvim/linters/flake8.config'
    let g:ale_python_pylint_options = '--rcfile ~/.config/nvim/linters/pylintrc.config'
    " YAML
    let g:ale_yaml_yamllint_options = '--config-file ~/.config/nvim/linters/yamllint.yml'
    let g:ale_linters = {'yaml': ['yamllint'], 'tex': ['texlab']} " Limit linting on these filetypes.
    " Ansible
    let g:ale_ansible_ansible_lint_executable = 'ansible-lint -c ~/.config/nvim/linters/ansible-lint.yml'

  " }}}
  " Ansible-doc ------------------------------------------------------------------------------- {{{

    nnoremap <leader>D :AnsibleDocFloat<CR><C-L>
    nnoremap <leader>S :AnsibleDocSplit<CR>
    nnoremap <leader>V :AnsibleDocVSplit<CR>

    let g:ansibledoc_float_opts = {
      \ 'relative': 'editor',
      \ 'width': float2nr(round(0.45 * &columns)),
      \ 'height': float2nr(round(0.75 * &lines)),
      \ 'col': float2nr(round(0.27 * &columns)),
      \ 'row': float2nr(round(0.07 * &lines)),
      \ }

  " }}}
  " Black ------------------------------------------------------------------------------------- {{{

    " Run Black formatter on Python files.
    autocmd mygroup InsertLeave,BufWritePre,BufLeave *.py execute ':Black'

  " }}}
  " CtrlP ------------------------------------------------------------------------------------- {{{

    " <leader>s to start searching from home directory (s for 'search').
    " <leader>S to start searching from project directory.

    " CTRL-j and CTRL-k to navigate through results.
    " CTRL-t to open the desired file in a new tab.
    " CTRL-v to open the desired file in a new vertical split.

    if g:atwork
      let g:ctrlp_map = '<leader>F'
      " For some reason mapping this normally doesn't work.
      autocmd mygroup VimEnter * nnoremap <leader>f :CtrlP ~/<CR>

      let g:ctrlp_tabpage_position = 'ac'
      let g:ctrlp_working_path_mode = 'rw' " Set search path to start at first .git directory below the cwd.

      " Change height of search window.
      let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:15,results:15'
      " Index hidden files.
      let g:ctrlp_show_hidden = 1
      " Keep cache accross reboots.
      let g:ctrlp_clear_cache_on_exit = 0
      " Don't index these filetypes in addition to Wildignore.
      let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn|swp|cache|tmp)$'
    endif

  " }}}
  " Devicons ---------------------------------------------------------------------------------- {{{

    if g:athome
      " Enable Nerd Fonts (requires AUR package).
      set guifont=Nerd\ Font\ 11

      " https://github.com/ryanoasis/vim-devicons
      " Fix issues re-sourcing Vimrc.
      if exists("g:loaded_webdevicons")
        call webdevicons#refresh()
      endif
    endif

  " }}}
  " Fugitive ---------------------------------------------------------------------------------- {{{

    nnoremap ga :Git add %<CR>
    nnoremap gs :Git status<CR>
    nnoremap gl :Git log<CR>
    nnoremap gP :Git push<CR>
    nnoremap gp :Git pull<CR>
    nnoremap giu :Git diff<CR>
    nnoremap gis :Git diff --staged<CR>
    nnoremap gcf :Git add % <bar> Git commit %<CR>
    nnoremap gcs :Git commit<CR>
    nnoremap grm :Git rm
    nnoremap grs :Git restore

    " Automatically enter Insert mode when opening the commit window.
    autocmd mygroup BufWinEnter COMMIT_EDITMSG startinsert

    " Change the inline-diff-expand from '=' to 'l' in the :Git window.
    if filereadable($HOME . '/.local/share/nvim/plugged/vim-fugitive/autoload/fugitive.vim')
      autocmd mygroup VimEnter *
        \ silent
        \ :!sed -i -e "s/.*call s:Map('n', \"=\".*/call s:Map('n', \"l\", \":<C-U>execute <SID>StageInline('toggle',line('.'),v:count)<CR>\", '<silent>')/"
                 \ -e "s/.*call s:Map('x', \"=\".*/call s:Map('x', \"l\", \":<C-U>execute <SID>StageInline('toggle',line('.'),v:count)<CR>\", '<silent>')/"
        \ ~/.local/share/nvim/plugged/vim-fugitive/autoload/fugitive.vim
    endif

  " }}}
  " Grepper ----------------------------------------------------------------------------------- {{{

    " <leader>g to start grepping (g for 'grep').

    " Use `}`and `{` to jump to contexts. `o` opens the current context in the
    " last window. `<cr>` opens the current context in the last window, but closes
    " the current window first.

    " For some reason this plugin doesn't load correctly, so we must source it
    "   manually here.
    source $HOME/.local/share/nvim/plugged/vim-grepper/plugin/grepper.vim

    nnoremap <leader>G :Grepper -tool rg -cd ~/<CR>
    nnoremap <leader>g :Grepper -tool rg<CR>

    if exists(':terminal')
      tnoremap <leader>G <C-\><C-n>:Grepper -tool rg -cd ~/<CR>
      tnoremap <leader>g <C-\><C-n>:Grepper -tool rg<CR>
    endif

    let g:grepper.prompt_text = '$t> ' " Show bare prompt.
    let g:grepper.stop = 3000

    " Set options for ripgrep.
    let g:grepper.rg.grepprg = 'rg
      \ --with-filename
      \ --no-heading
      \ --vimgrep
      \ --hidden
      \ --max-filesize 10M
      \ --one-file-system
      \ --smart-case
      \ -g "!**/Downloads"
      \ -g "!**/.cfg"
      \ -g "!**/.fltk"
      \ -g "!**/.git" -g "!**/.svn" -g "!**/.hg"
      \ -g "!**/.gem" -g "!**/.vpython*" -g "!**/.npm" -g "!**/.cargo"
      \ -g "!**/.gnupg" -g "!**/.local" -g "!**/.cache"
      \ -g "!**/.mozilla" -g "!**/.tmux" -g "!**/.LfCache" -g "!**/.ansible"
      \ -g "!*.avi" -g "!*.aac" -g "!*.m4a" -g "!*.mkv" -g "!*.mp*"
      \ -g "!*.crt" -g "!*.der" -g "!*.cer*"
      \ -g "!*.doc*" -g "!*.odt" -g "!*.pdf"
      \ -g "!*.gpg" -g "!*.key"
      \ -g "!*.ico" -g "!*.jp*g" -g "!*.gif" -g "!*.png" -g "!*.tiff" -g "!*.svg"
      \ -g "!*.ko" -g "!*.so"
      \ -g "!*.lock" -g "!*.swp"
      \ -g "!*.py1*" -g "!*.pyc"
      \ -g "!*.sdv" -g "!*.shada"
      \ -g "!*.sql*" -g "!*.db*" -g "!*.pick*"
      \ -g "!*.tar*" -g "!*.tgz" -g "!*.*zip*" -g "!*.gz*" -g "!*.7z"
      \ -g "!*.vdi" -g "!*.vhd" -g "!*.vmd*" -g "!*.iso"
      \ -g "!*.web*" -g "!*.bmp"
      \ -g "!*.bau"
      \ -g "!*.crate"
      \ -g "!*.dat"
      \ -g "!*.dic*"
      \ -g "!*.exc"
      \ -g "!*.fmt"
      \ -g "!*.kbx*"
      \ -g "!*.localstorage*"
      \ -g "!*.msg"
      \ -g "!*.pack"
      \ -g "!*.stat*"
      \ -g "!*.thm"
      \ -g "!*.whl"
      \ '

  " }}}
  " GitGutter --------------------------------------------------------------------------------- {{{

    " Enable GitGutter markings for dotfiles repo.
    autocmd mygroup BufEnter,InsertLeave ~/.*
      \ let g:gitgutter_git_args = "--git-dir=$HOME/.cfg --work-tree=$HOME"
    autocmd mygroup BufLeave ~/.* let g:gitgutter_git_args = ''

    if g:athome
      " Make sidebar dark.
      highlight SignColumn cterm=bold ctermbg=0 guibg=0
      " Fix git diff colors.
      highlight DiffText ctermbg=1 ctermfg=3 guibg=1 guifg=3
    endif

    " Undo git changes easily.
    nnoremap gu :GitGutterUndoHunk<CR>
    " View interactive git diff.
    nnoremap gd :Gdiffsplit<CR>
    " Jump between hunks.
    nnoremap gn :GitGutterNextHunk<CR>
    nnoremap gN :GitGutterPrevHunk<CR>

  " }}}
  " Highlighted Yank -------------------------------------------------------------------------- {{{

    let g:highlightedyank_highlight_duration = 200
    highlight link HighlightedyankRegion Search

  " }}}
  " Indentline -------------------------------------------------------------------------------- {{{

    let g:indentLine_char = '┊'

    " Exclude help pages and terminals.
    let g:indentLine_bufTypeExclude = ['help', 'terminal']
    let g:indentLine_fileTypeExclude = ['markdown', 'vimwiki', 'help']
    let g:indentLine_bufNameExclude = ['term:*', '*.md']

  " }}}
  " LazyGit ----------------------------------------------------------------------------------- {{{

    nnoremap <silent> <leader>l :LazyGit<CR>
    nnoremap <silent> <leader>m :LazyGit<CR>
    let g:lazygit_floating_window_scaling_factor = 0.92

  " }}}
  " Latex Live Preview ------------------------------------------------------------------------ {{{

    " Set PDF viewer. Use GNOME's evince since Zathura crashes a lot.
    let g:livepreview_previewer = 'evince'
    " Don't refresh preview on CursorHold autocommand.
    let g:livepreview_cursorhold_recompile = 0

  " }}}
  " LeaderF ----------------------------------------------------------------------------------- {{{

    if g:athome
      " <leader>f to start searching from home directory (f for 'find').
      " <leader>F to start searching from project directory.

      " <leader>/ to grep for a string in all open buffers.
      " <leader>b to search within open buffers.
      " <leader>R to search recently used files.

      " CTRL-j, CTRL-k : navigate through results.
      " CTRL-x : open in horizontal split window.
      " CTRL-] : open in vertical split window.
      " CTRL-T : open in new tabpage.

      nnoremap <leader>f :LeaderfFile ~/<CR>
      nnoremap <leader>F :LeaderfFile<CR>
      nnoremap <leader>R :LeaderfMru<CR>
      nnoremap <leader>/ :LeaderfLineAll<CR>

      if exists(':terminal')
        tnoremap <leader>f <C-\><C-n>:LeaderfFile ~/<CR>
        tnoremap <leader>F <C-\><C-n>:LeaderfFile<CR>
        tnoremap <leader>R <C-\><C-n>:LeaderfMru<CR>
        tnoremap <leader>/ <C-\><C-n>:LeaderfLineAll<CR>
      endif

      let g:Lf_ShowHidden = 1      " Index hidden files.
      let g:Lf_MruMaxFiles = 10000 " Index all used files in MRU list.
      let g:Lf_CacheDirectory = ($HOME . '/.cache')

      " Don't index the following dirs/files.
      let g:Lf_WildIgnore = {
        \ 'dir':
        \ ['.svn','.git','.hg','.cfg',
        \ '.*cache*','_*cache','.swp','.LfCache','.swt',
        \ '.gnupg','.pylint.d','ansible*',
        \ '.cargo','.fltk','.icon*','.password*',
        \ '.vim/undo','.mozilla','__*__'],
        \
        \ 'file':
        \ ['*.sw?','~$*',
        \ '*.pyc','*.py1*','*.stat*',
        \ '*.gpg','*.kbx*','*.key','*.c?rt','*.cer','*.der','*.pem',
        \ '*.so','*.msg','*.lock','*.*db*','*.*sql*','*.localstorage*','*.shada','*.pack','*.crate',
        \ '*.vdi','*.vmd*','*.dat','*.vhd','*.iso',
        \ '*.pdf','*.odt','*.doc*','*.bau','*.dic','*.exc','*.fmt','*.thm','*.sdv',
        \ '*.7z','*.*zip','*.tar.*','*.tar*','*.*gz','*.pick*','*.whl',
        \ '*.jp?g','*.png','*.bmp','*.gif','*.tif*','*.svg','*.ico','*.web*',
        \ '*.mp?','*.m4a','*.aac',
        \ '*.mkv','*.avi']
        \ }

      " Automatically preview the following results.
      let g:Lf_PreviewResult = {
        \ 'File': 0,
        \ 'Buffer': 0,
        \ 'Mru': 0,
        \ 'Tag': 1,
        \ 'BufTag': 1,
        \ 'Function': 1,
        \ 'Line': 1,
        \ 'Colorscheme': 1,
        \ 'Rg': 1,
        \ 'Gtags': 1
        \ }
    endif

  " }}}
  " Markdown Preview -------------------------------------------------------------------------- {{{

    if g:athome
      " Markdown preview with mp.
      autocmd mygroup FileType markdown nnoremap mp :MarkdownPreview<CR><C-L>

      "let g:mkdp_auto_start = 1  " Automatically launch rendered markdown in browser.
      let g:mkdp_auto_close = 1   " Automatically close rendered markdown in browser.

      " Use vimb since Firefox won't automatically close the rendered markdown window.
      let g:mkdp_browser = 'vimb'
    endif

  " }}}
  " Neovim Remote ----------------------------------------------------------------------------- {{{

    " See https://github.com/mhinz/neovim-remote
    if has('nvim')
      let $GIT_EDITOR = 'nvr -cc split --remote-wait'
    endif

    autocmd mygroup FileType gitcommit,gitrebase,gitconfig set bufhidden=delete

  " }}}
  " NERD Commenter ---------------------------------------------------------------------------- {{{

    " <leader>cc to comment a block.
    " <leader>cu to uncomment a block.
    let g:NERDSpaceDelims = 1
    let g:NERDDefaultAlign = 'left'

  " }}}
  " Rnvimr ------------------------------------------------------------------------------------ {{{

    nnoremap <silent> <leader>r :RnvimrToggle<CR>

    let g:rnvimr_enable_ex = 1                      " Replace NetRW.
    let g:rnvimr_enable_picker = 1                  " Hide Ranger after picking file.
    let g:rnvimr_enable_bw = 1                      " Make Neovim wipe buffers corresponding to the files deleted by Ranger.
    let g:rnvimr_border_attr = {'fg': 12, 'bg': -1} " Set border color.
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

    " Set floating initial size relative to 95% of parent window size.
    let g:rnvimr_layout = {
      \ 'relative': 'editor',
      \ 'width': float2nr(round(0.95 * &columns)),
      \ 'height': float2nr(round(0.95 * &lines)),
      \ 'col': float2nr(round(0.025 * &columns)),
      \ 'row': float2nr(round(0.05 * &lines)),
      \ 'style': 'minimal'
      \ }

  " }}}
  " Suda -------------------------------------------------------------------------------------- {{{

    " Automatically open write-protected files with sudo.
    " let g:suda_smart_edit = 1

  " }}}
  " Taboo ------------------------------------------------------------------------------------- {{{

    set sessionoptions+=tabpages,globals  " Help taboo remember session options.
    let g:taboo_modified_tab_flag = ''    " Don't mark files as modified.

  " }}}
  " Tagbar ------------------------------------------------------------------------------------ {{{

    " Launch the tagbar by default when opening files >1000 lines.
    "autocmd mygroup BufReadPost * if

    " Launch the tagbar by default when opening Python files.
    "autocmd mygroup FileType python TagbarToggle

  " }}}
  " Undotree ---------------------------------------------------------------------------------- {{{

    " <leader>u to open Vim's undo tree.
    nnoremap <leader>u :UndotreeToggle<CR>

  " }}}
  " Vim Better Whitespace --------------------------------------------------------------------- {{{

    " Don't highlight whitespace.
    let g:better_whitespace_enabled = 0

    " Automatically strip whitespace.
    autocmd mygroup InsertLeave,CursorHold * call StripWhite()
    function! StripWhite()
        if &filetype !=# 'magit' && &modifiable ==# 1 && &readonly ==# 0
            StripWhitespace
        endif
    endfunction

  " }}}
  " Vimagit ----------------------------------------------------------------------------------- {{{

    " Vimagit is used for managing dotfiles, Lazygit is for everything else.

    " Open Vimagit in the same window.
    nnoremap <leader>M :MagitOnly<CR>

    let g:magit_show_magit_mapping='M'
    let g:magit_git_cmd="git --git-dir=$HOME/.cfg/ --work-tree=$HOME"
    let g:magit_scrolloff=999

    " Open Vimagit for the current repo. If Vimagit can't find a repo, use the dotfiles repo.
    " See also https://stackoverflow.com/questions/5441697/how-can-i-get-last-echoed-message-in-vimscript
    " function! Vimagit(split)
    "   let g:magit_git_cmd="git"                          " Ensure variable is set to default value.
    "   redir => g:messages                                " Begin capturing output of messages.
    "   if a:split == 1
    "     silent! Magit                                    " Try opening Magit for the current repo.
    "   else
    "     silent! MagitOnly
    "   endif
    "   redir END                                          " End capturing output.
    "   let g:lastmsg=get(split(g:messages, "\n"), -5, "") " Send output to var.
    "   if g:lastmsg ==# "magit can not find any git repository" " If var matches error, use dotfiles instead.
    "     let g:magit_git_cmd="git --git-dir=$HOME/.cfg/ --work-tree=$HOME"
    "     if a:split == 1
    "       silent! Magit                                  " Try opening Magit for the current repo.
    "     else
    "       silent! MagitOnly
    "     endif
    "   endif
    "   stopinsert
    " endfunction

  " }}}
  " Vim Markdown ------------------------------------------------------------------------------ {{{

    let g:vim_markdown_folding_disabled = 1
    let g:vim_markdown_override_foldtext = 0

  " }}}
  " Vim Wiki ---------------------------------------------------------------------------------- {{{

    " let g:vimwiki_list = [{'path': '~/notes/', 'syntax': 'markdown', 'ext': '.md'},
    "                      \{'path': '~/linux-notes/', 'syntax': 'markdown', 'ext': '.md'}]

    " let g:vimwiki_conceallevel = 1
    " let g:vimwiki_conceal_onechar_markers = 0

    " <leader>ww is used by Vim-Windowswap, so remap it here.
    " nmap <Leader>wx <Plug>VimwikiIndex

    " Override some of Vimwiki's configs.
    " For some reason this only works after the BufEnter event.
    " Only conceal markdown syntax in Normal mode.
    " autocmd mygroup BufEnter *.md,vimwiki,markdown setlocal concealcursor=n conceallevel=1

    " Uncomment to enable automatic Markdown folding.
    " let g:vimwiki_folding = 'custom'
    " function! VimwikiFoldLevelCustom(lnum)
    "   let pounds = strlen(matchstr(getline(a:lnum), '^#\+'))
    "   if (pounds)
    "     return '>' . pounds  " start a fold level
    "   endif
    "   if getline(a:lnum) =~? '\v^\s*$'
    "     if (strlen(matchstr(getline(a:lnum + 1), '^#\+')))
    "       return '-1' " don't fold last blank line before header
    "     endif
    "   endif
    "   return '=' " return previous fold level
    " endfunction
    " autocmd mygroup FileType vimwiki setlocal foldmethod=expr |
    "   \ setlocal foldenable | set foldexpr=VimwikiFoldLevelCustom(v:lnum)

  " }}}
  " Vim Windowswap ---------------------------------------------------------------------------- {{{

    let g:windowswap_map_keys = 0
    nnoremap <silent> <leader>WW :call WindowSwap#EasyWindowSwap()<CR>

  " }}}
  " YouCompleteMe ----------------------------------------------------------------------------- {{{

    " Additional language servers for YCM. Install with npm and pacman.
    let g:ycm_language_server = [
      \   { 'name': 'vim',
      \     'filetypes': [ 'vim' ],
      \     'cmdline': [ expand('/usr/bin/vim-language-server' ), '--stdio' ]
      \   },
      \   {
      \     'name': 'bash',
      \     'cmdline': [ 'node', expand('/usr/bin/bash-language-server' ), 'start' ],
      \     'filetypes': [ 'sh', 'bash' ],
      \   },
      \   {
      \     'name': 'texlab',
      \     'cmdline': [ '/usr/bin/texlab' ],
      \     'filetypes': [ 'tex' ],
      \   },
      \ ]

      let g:ycm_collect_identifiers_from_comments_and_strings = 1
      let g:ycm_complete_in_comments = 1  " Allow auto-completion within comments
      let g:ycm_max_num_candidates = 25   " Limit number of completion options given.
      let g:ycm_autoclose_preview_window_after_completion = 1

  " }}}

endif

" }}}
" COLORS ###################################################################################### {{{

  " Colors for plugins typically have to come after they're loaded by Vim-plug.

  if g:athome

    " Change comment color from grey to turquoise.
    " Make white a bit brighter.
    let g:palenight_color_overrides = {
      \    'comment_grey': { 'gui': '#64bde9', "cterm": "59", "cterm16": "15" },
      \    'white': { 'gui': '#d3dae8', "cterm": "59", "cterm16": "15" },
      \}
    " This has to come AFTER Vim-plug, which is why it's after all the other plugins.
    colorscheme palenight

    " Make IncSearch and Search highlights the same.
    highlight IncSearch ctermfg=235 ctermbg=180 guifg=#292D3E guibg=#ffcb6b
    " Make selected LeaderF results more visible.
    highlight Lf_hl_cursorline guifg=#c3e88d gui=Bold ctermfg=226 ctermbg=0 cterm=Bold

  elseif g:atwork

    colorscheme peachpuff

    " Color for folded blocks of text.
    highlight Folded cterm=bold ctermfg=5 ctermbg=8 guifg=5 guibg=8
    " Visual mode text highlight color.
    highlight Visual ctermfg=2 ctermbg=8 guifg=2 guibg=8
    " Search results highlight color.
    highlight Search ctermfg=8 ctermbg=3 guifg=8 guibg=3
    highlight IncSearch ctermfg=8 ctermbg=3 guifg=8 guibg=3

  endif

  " Tabline.
  "highlight TabLine guibg=#333747 gui=None
  highlight TabLineFill guibg=#333747 gui=None
  highlight TabLineSel guifg=#292d3f guibg=#939ede gui=Bold

  highlight ColorColumn guibg=#293051


" }}}
" NAVIGATION ################################################################################## {{{

  " Easier exiting insert mode.
  inoremap jk <Esc>
  if exists(':terminal')
    tnoremap fd <C-\><C-n>
  endif
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
  nnoremap <silent> <C-s>      :cd ~/ <bar> new<CR>
  inoremap <silent> <C-s> <Esc>:cd ~/ <bar> new<CR>
  nnoremap <silent> <C-\>      :cd ~/ <bar> vnew<CR>
  inoremap <silent> <C-\> <Esc>:cd ~/ <bar> vnew<CR>

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

  " Terminal-related shortcuts.
  if exists(':terminal')

    " Quickly convert a terminal window to a Ranger window.
    tnoremap <leader>r <C-\><C-n>:enew! <bar> RnvimrToggle<CR><C-L>

    nnoremap <silent> <leader>t            :terminal<CR>
    tnoremap <silent> <leader>t  <C-\><C-n>:terminal<CR>
    nnoremap <silent> <leader>tt           :terminal<CR>
    tnoremap <silent> <leader>tt <C-\><C-n>:terminal<CR>

    nnoremap <silent> <leader>tn           :tabnew <bar> terminal<CR>
    tnoremap <silent> <leader>tn <C-\><C-n>:tabnew <bar> terminal<CR>
    nnoremap <silent> <leader>ts           :split  <bar> set winfixheight <bar> terminal<CR>
    tnoremap <silent> <leader>ts <C-\><C-n>:split  <bar> set winfixheight <bar> terminal<CR>
    nnoremap <silent> <leader>tv           :vsplit <bar> set winfixwidth <bar> terminal<CR>
    tnoremap <silent> <leader>tv <C-\><C-n>:vsplit <bar> set winfixwidth <bar> terminal<CR>

    tnoremap <silent> <C-n> <C-\><C-n>:tabnext<CR>
    tnoremap <silent> <C-p> <C-\><C-n>:tabprevious<CR>
    tnoremap <leader>a <C-\><C-n>:exe "tabn ".g:lasttab<CR>

    tnoremap <silent> <C-t> <C-\><C-n>:tabnew<CR>
    tnoremap <silent> <C-w> <C-\><C-n>:quit!<CR>
    tnoremap <silent> ZZ    <C-\><C-n>:quit!<CR>

    tnoremap <silent> <C-k> <C-\><C-n>:wincmd k<CR>
    tnoremap <silent> <C-j> <C-\><C-n>:wincmd j<CR>
    tnoremap <silent> <C-h> <C-\><C-n>:wincmd h<CR>
    tnoremap <silent> <C-l> <C-\><C-n>:wincmd l<CR>

    tnoremap <silent> <C-s> <C-\><C-n>:cd ~/ <bar> new<CR>
    tnoremap <silent> <C-\> <C-\><C-n>:cd ~/ <bar> vnew<CR>

    tnoremap <silent> <A-1> <C-\><C-n>1gt<CR>
    tnoremap <silent> <A-2> <C-\><C-n>2gt<CR>
    tnoremap <silent> <A-3> <C-\><C-n>3gt<CR>
    tnoremap <silent> <A-4> <C-\><C-n>4gt<CR>
    tnoremap <silent> <A-5> <C-\><C-n>5gt<CR>
    tnoremap <silent> <A-6> <C-\><C-n>6gt<CR>
    tnoremap <silent> <A-7> <C-\><C-n>7gt<CR>
    tnoremap <silent> <A-8> <C-\><C-n>8gt<CR>
    tnoremap <silent> <A-9> <C-\><C-n>9gt<CR>
    tnoremap <silent> <A-0> <C-\><C-n>10gt<CR>
    tnoremap <silent> <A--> <C-\><C-n>11gt<CR>
    tnoremap <silent> <A-=> <C-\><C-n>12gt<CR>

    tnoremap <silent> <A-Left>  <C-\><C-n>:vertical resize -2<CR><C-L>
    tnoremap <silent> <A-Right> <C-\><C-n>:vertical resize +2<CR><C-L>
    tnoremap <silent> <A-Up>    <C-\><C-n>:resize +2<CR><C-L>
    tnoremap <silent> <A-Down>  <C-\><C-n>:resize -2<CR><C-L>
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
  nnoremap <silent> <A-0> 10gt
  inoremap <silent> <A-0> <Esc>10gt<CR>
  nnoremap <silent> <A--> 11gt
  inoremap <silent> <A--> <Esc>11gt<CR>
  nnoremap <silent> <A-=> 12gt
  inoremap <silent> <A-=> <Esc>12gt<CR>

" }}}
"{% endraw %}
