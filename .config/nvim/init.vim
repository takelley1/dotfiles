"{% raw %}
" OPTIONS ##################################################################################### {{{

  filetype indent plugin on             " Identify the filetype, load indent and plugin files.
  syntax on                             " Force syntax highlighting.
  if has('termguicolors')
    set termguicolors                 " Enable 24-bit color support.
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
  set updatetime=500                    " Increase plugin update speed.

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
  
  " WSL 2-way yank support
  " https://superuser.com/a/1557751
  let g:clipboard = {
            \   'name': 'win32yank-wsl',
            \   'copy': {
            \      '+': 'win32yank.exe -i --crlf',
            \      '*': 'win32yank.exe -i --crlf',
            \    },
            \   'paste': {
            \      '+': 'win32yank.exe -o --lf',
            \      '*': 'win32yank.exe -o --lf',
            \   },
            \   'cache_enabled': 0,
            \ }

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
  autocmd mygroup InsertLeave,CursorHold,BufLeave * if &readonly ==# 0 | silent! write | endif

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

  " https://stackoverflow.com/a/14449484
  " Return to last position when re-opening file.
  autocmd mygroup BufReadPost * silent! normal! g`"zv
  
  " Automatically increase the current file's Autojump directory weight.
  " https://github.com/wting/autojump
  autocmd mygroup BufReadPost,BufWritePost * silent! :!autojump --add %:p:h

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
  autocmd mygroup CursorHold * silent! call DeleteHiddenBuffers()

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

  " Gitcommit -- used by Lazygit ------------------------------------------------------------------
    autocmd mygroup FileType gitcommit setlocal colorcolumn=80 textwidth=80 formatoptions=qt nonumber
  " Help ------------------------------------------------------------------------------------------
    autocmd mygroup FileType help setlocal nonumber
  " Markdown --------------------------------------------------------------------------------------
    autocmd mygroup FileType markdown setlocal colorcolumn=120 textwidth=80
    autocmd mygroup BufEnter *.md setlocal foldmethod=manual foldlevelstart=99 concealcursor= conceallevel=0
  " Python ----------------------------------------------------------------------------------------
    autocmd mygroup FileType python setlocal shiftwidth=4 softtabstop=4 tabstop=4 colorcolumn=100 nowrap
    autocmd mygroup BufEnter *.py setlocal foldlevelstart=0 foldmethod=indent foldnestmax=2 foldignore=""
  " Shell -----------------------------------------------------------------------------------------
    autocmd mygroup FileType sh setlocal shiftwidth=4 softtabstop=4 tabstop=4 foldlevelstart=0 foldmethod=marker colorcolumn=120 nowrap
  " TeX -------------------------------------------------------------------------------------------
    autocmd mygroup FileType tex setlocal colorcolumn=120 textwidth=120 nowrap
    autocmd mygroup BufEnter *.tex setlocal concealcursor= conceallevel=0
  " Terraform -------------------------------------------------------------------------------------
    autocmd mygroup FileType terraform setlocal foldmethod=marker foldmarker={,} nowrap
    autocmd mygroup BufEnter *.tf setlocal foldlevelstart=0
  " VimScript -------------------------------------------------------------------------------------
    autocmd mygroup FileType vim setlocal foldlevelstart=0 foldmethod=marker colorcolumn=100 nowrap
  " YAML ------------------------------------------------------------------------------------------
    autocmd mygroup FileType yaml,yaml.ansible setlocal foldlevelstart=0 foldmethod=marker colorcolumn=120 nowrap

  " Force cursor to stay in the middle of the screen.
  set scrolloff=999
  " Scrolloff is glitchy on terminals, so disable it there.
  if exists(':terminal') && exists('##TermEnter')
    autocmd mygroup TermEnter * silent setlocal scrolloff=0
    autocmd mygroup TermLeave * silent setlocal scrolloff=999
  endif

" }}}
" SHORTCUTS ################################################################################### {{{

  " Leader key easier to reach.
  let mapleader = ","
  " Faster saving.
  nnoremap <silent> <leader>w :write<CR><C-L>
  " Jump back and forth between files.
  nnoremap <silent> <BS> :e#<CR><C-L>
  " Text wrapping toggle.
  nnoremap <leader>n :set wrap!<CR><C-L>
  " Quickly add timestamp for dated notes.
  nnoremap <silent> <leader>d :r !printf "\%s" "- $(date +\%Y/\%m/\%d\ \%a\ \%H:\%M) - "<CR>

  " Use `call P('highlight')` to put the output of `highlight` in the current buffer, {{{
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
  " }}}

  " Toggle preventing horizonal or vertial resizing.
  nnoremap <leader>H :set winfixheight! <bar> set winfixheight?<CR>
  nnoremap <leader>W :set winfixwidth! <bar> set winfixwidth?<CR>

  " Columnize selection.
  vnoremap t :!column -t<CR>
  " Turn off highlighted search results.
  nnoremap <silent> Q :nohl<CR><C-L>
  " Make it easier to copy text from the terminal using the mouse.
  nnoremap <leader>c :set number! <bar> :Gitsigns toggle_signs<CR><C-L>
  " Easy turn on paste mode.
  nnoremap <leader>p :set paste!<CR>
  nnoremap <space> zA
  " Insert space.
  " nnoremap <space> i<space><ESC>
  " Insert line break.
  " nnoremap <CR> i<CR><ESC>  " This will break lazygit.

  " https://github.com/jdhao/nvim-config/blob/master/core/mappings.vim
  " Continuous visual shifting (does not exit Visual mode), `gv` means
  " to reselect previous visual area, see https://superuser.com/q/310417/736190
  "xnoremap < <gv
  "xnoremap > >gv

  " Quickly lookup docs for the word or WORD under the cursor. Especially useful for Python.
  " gK looks up the <WORD>, gk looks up the <word>.
  " nnoremap <silent> gK :call Zeal() <CR><CR>
  " nnoremap <silent> gk :!zeal "<cword>"&<CR><CR>

  " function! Zeal()
   " Strip leading characters. Anything that isn't [a-zA-Z0-9._] will get stripped from the beginning.
    " let query = substitute(expand("<cWORD>"), "^[^a-zA-Z0-9._]*", "", "")
   " Strip trailing characters. Anything that isn't [a-zA-Z0-9._] will get stripped from the end.
    " let query = substitute(query, "[^a-zA-Z0-9._].*", "", "")
    " execute '!zeal' query
  " endfunction

  " Easily edit vimrc (ve for 'vim edit').
  nnoremap <leader>ve :edit ~/.config/nvim/init.vim<CR>
  if exists(':terminal')
    tnoremap <leader>ve <C-\><C-n>:edit ~/.config/nvim/init.vim<CR>
  endif
  " Reload configuration without restarting vim (vs for 'vim source').
  nnoremap <leader>vs :update <bar> :source $MYVIMRC<CR><C-L>
  " Quickly save and quit everything to restart neovim.
  nnoremap <leader>Q :wqa!<CR>
  " Save and quit only open window.
  nnoremap <leader>q :wq!<CR>

" }}}
" PLUGINS ##################################################################################### {{{

  if has('nvim') && filereadable($HOME . '/.local/share/nvim/site/autoload/plug.vim')
  " Vim-Plug ---------------------------------------------------------------------------------- {{{

    call plug#begin(stdpath('data') . '/plugged')

      if has('nvim-0.5') " Check for lua functionality.
        " Plug 'tjdevries/colorbuddy.vim' " Colorscheme w/ Tree-sitter support.
        " Plug 'Th3Whit3Wolf/onebuddy'
        " Plug 'tanvirtin/nvim-monokai'
        " Plug 'neovim/nvim-lspconfig'
        " Plug 'nvim-lua/popup.nvim'
        " Plug 'nvim-lua/popup.nvim'    " Dependency for nvim-spectre.
        " Plug 'windwp/nvim-spectre'    " Search and replace.
        Plug 'voldikss/vim-floaterm' " Use to launch lf, a backup for when ranger is slow.
        " Plug 'nvim-telescope/telescope.nvim'
        Plug 'nvim-lua/plenary.nvim'  " Dependency for nvim-spectre, gitsigns.
        Plug 'lewis6991/gitsigns.nvim' " Lua replacement for gitgutter.
        Plug 'nvim-treesitter/nvim-treesitter' " Tree-sitter syntax highlighting.
        " Plug 'f-person/git-blame.nvim'     " Git blame on each line.
        Plug 'norcalli/nvim-colorizer.lua' " Automatically colorize color hex codes.
        " Plug 'hrsh7th/nvim-compe'          " Lua replacement for Deoplete.
        " Plug 'glepnir/indent-guides.nvim'  " Lua replacement for yggdroot/indentline.
        " Plug 'b3nj5m1n/kommentary'         " Lua replacement for nerdcommenter.
      endif

      Plug 'hashivim/vim-terraform'         " HashiCorp Terraform support.
      Plug 'preservim/nerdcommenter'        " Comment blocks.
      Plug 'kassio/neoterm'                 " REPL integration for interactive Python coding.
      " Plug 'tmhedberg/SimpylFold'  " Better folding in Python.
      " Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}  " Python code highlighting.
      Plug 'kdheepak/lazygit.nvim'
      Plug 'ntpeters/vim-better-whitespace' " Highlight and strip whitespace.
      Plug 'tpope/vim-obsession'            " Session management.
      " Plug 'tpope/vim-endwise'              " Auto-terminate conditional statements.
      Plug 'tpope/vim-surround'             " Easily surround words.
      Plug 'tpope/vim-eunuch'               " Better shell commands.
      " Plug 'tpope/vim-repeat'               " Repeat plugin actions.
      " Plug 'brooth/far.vim'                 " Find and replace.
      " Plug 'Konfekt/FastFold'               " More performant folding.
      " Plug 'tpope/vim-unimpaired'           " Navigation with square bracket keys.
      " Plug 'easymotion/vim-easymotion'      " Alternative line navigation.
      Plug 'pearofducks/ansible-vim'        " Ansible syntax.
      " Plug 'ekalinin/Dockerfile.vim'        " Dockerfile syntax.
      Plug 'gcmt/taboo.vim'                 " Rename tabs.
      " Plug 'wesQ3/vim-windowswap'           " Easily swap window splits with <leader>ww
      " Plug 'godlygeek/tabular'              " Alignment tools.
      Plug 'plasticboy/vim-markdown'        " Better markdown syntax highlighting.
      Plug 'jiangmiao/auto-pairs'           " Auto-create bracket and quote pairs.
      " Plug 'preservim/tagbar'               " Function navigation on large files.
      Plug 'mbbill/undotree'                " Visualize and navigate Vim's undo tree.
      Plug 'dense-analysis/ale'             " Linting engine.
      Plug 'machakann/vim-highlightedyank'  " Briefly highlight yanked text.
      Plug 'vim-airline/vim-airline'        " Status bar.
      Plug 'vim-airline/vim-airline-themes'
      Plug 'kevinhwang91/rnvimr'            " Ranger in a floating window.
      Plug 'drewtempelmeyer/palenight.vim' " Colorscheme.
      Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' } " Code completion.
      Plug 'deoplete-plugins/deoplete-jedi' " Deoplete Python integration.

      Plug 'lervag/vimtex', { 'for': 'tex' }                  " LaTeX helpers.
      " Run :LLPStartPreview to start preview window.
      Plug 'xuhdev/vim-latex-live-preview', { 'for': 'tex' }  " LaTeX live preview.
      Plug 'lambdalisue/suda.vim' " Edit files with sudo. This causes performance issues at work.
      Plug 'Shougo/neco-vim' " Deoplete VimScript integration.
      " Plug 'fszymanski/deoplete-emoji' " Auto-complete `:` emoji in markdown files.
      Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  } " Render markdown.

    call plug#end()
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

    let g:airline_theme='palenight'
    " Use Nerd Fonts from Vim-devicons.
    let g:airline_powerline_fonts = 1

    let g:airline#extensions#vimagit#enabled = 1
    let g:airline_highlighting_cache = 1
    let g:airline_detect_modified = 0 " Don't loudly mark files as modified.

    let g:airline_section_c = '%F' " Show full filepath.

    " Disable unnecessary extensions.
    let g:airline#extensions#grepper#enabled = 0
    let g:airline#extensions#tagbar#enabled = 0
    let g:airline#extensions#po#enabled = 0
    let g:airline#extensions#keymap#enabled = 0
    let g:airline#extensions#fzf#enabled = 0
    let g:airline#extensions#netrw#enabled = 0

  " }}}
  " ALE --------------------------------------------------------------------------------------- {{{

    " Have ALE remove extra whitespace and trailing lines.
    let g:ale_fixers = {'*': ['remove_trailing_lines', 'trim_whitespace'],
                     \ 'sh': ['remove_trailing_lines', 'shfmt', 'trim_whitespace'],
                     \ 'python': ['autoimport', 'black', 'remove_trailing_lines', 'reorder-python-imports', 'trim_whitespace'],
                     \ 'terraform': ['terraform', 'remove_trailing_lines', 'trim_whitespace'],
                     \ }

    let g:ale_linters = {'yaml': ['yamllint'],
                      \  'tex': ['texlab'],
                      \  'python': ['cspell', 'flake8', 'mypy', 'pydocstyle', 'pylint']
                      \ }

    let g:ale_fix_on_save = 1  " ALE will fix files automatically when they're saved.
    let g:ale_lint_on_insert_leave = 1 " Run linting after exiting insert mode.

    let g:ale_lint_delay = 300 " Increase linting speed.

    " Bash
    let g:ale_sh_bashate_options = '--ignore "E043,E006"'
    " Indent Bash files with 4 spaces.
    let g:ale_sh_shfmt_options = '-i 4'
    " Python
    let g:ale_python_flake8_options = '--config ~/.config/nvim/linters/flake8.config'
    " let g:ale_python_pylint_options = '--rcfile ~/.config/nvim/linters/pylintrc.config'
    " let g:ale_python_mypy_options   = '--strict --ignore-missing-imports --no-site-packages --exclude '.*test.*'

    " YAML
    let g:ale_yaml_yamllint_options = '--config-file ~/.config/nvim/linters/yamllint.yml'
    " let g:ale_ansible_ansible_lint_executable = 'ansible-lint --nocolor --parseable-severity -x yaml -c ~/.config/nvim/linters/ansible-lint.yml ' . expand('%:p')

  " }}}
  " Git-blame --------------------------------------------------------------------------------- {{{

    " Disable by default.
    let g:gitblame_enabled = 0
    nnoremap <silent> <leader>B :GitBlameToggle<CR>

  " }}}
  " Colorizer --------------------------------------------------------------------------------- {{{

   if has('nvim-0.5')
     " Enable colorizer.nvim for all filetypes.
     lua require 'colorizer'.setup()
     lua require 'colorizer'.setup(nil, { css = true; })
   endif

  " }}}
  " Deoplete ---------------------------------------------------------------------------------- {{{

    " Use TAB to cycle through deoplete completion popups.
    inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

    let g:deoplete#enable_at_startup = 1

    " Don't show the default popup window.
    set completeopt-=preview

  " }}}
  " Floaterm ---------------------------------------------------------------------------------- {{{

    " Use to launch lf, a backup for when ranger is slow.
    command! LF FloatermNew lf
    nnoremap <leader>f :LF<CR>
    let g:floaterm_opener = 'edit'
    let g:floaterm_width = 0.9
    let g:floaterm_height = 0.9

  " }}}
  " Gitsigns ---------------------------------------------------------------------------------- {{{
lua<<EOF
require('gitsigns').setup()
EOF
  " }}}
  " Highlighted Yank -------------------------------------------------------------------------- {{{

    let g:highlightedyank_highlight_duration = 180
    highlight link HighlightedyankRegion Search

  " }}}
  " LazyGit ----------------------------------------------------------------------------------- {{{

    nnoremap <silent> <leader>m :LazyGit<CR>
    let g:lazygit_floating_window_scaling_factor = 0.92

  " }}}
  " Latex Live Preview ------------------------------------------------------------------------ {{{

    " Set PDF viewer. Use GNOME's evince since Zathura crashes a lot.
    let g:livepreview_previewer = 'evince'
    " Don't refresh preview on CursorHold autocommand.
    let g:livepreview_cursorhold_recompile = 0

  " }}}
  " Markdown Preview -------------------------------------------------------------------------- {{{

    " Markdown preview with mp.
    autocmd mygroup FileType markdown nnoremap mp :MarkdownPreview<CR><C-L>

    "let g:mkdp_auto_start = 1  " Automatically launch rendered markdown in browser.
    let g:mkdp_auto_close = 1   " Automatically close rendered markdown in browser.

    " Use vimb since Firefox won't automatically close the rendered markdown window.
    let g:mkdp_browser = 'vimb'

  " }}}
  " Neoterm ----------------------------------------------------------------------------------- {{{

    " Open REPL terminal windows in a bottom split.
    let g:neoterm_default_mod = 'botright'
    " Automatically scroll to the bottom of the REPL buffer.
    let g:neoterm_autoscroll = 1

    " Send line/selection/file to a REPL in a terminal split. Useful for interactive Python coding.
    " 'e' for 'execute'.
    nnoremap <leader>ee  :TREPLSendLine<CR>
    vnoremap <leader>ee  :TREPLSendSelection<CR>
    nnoremap <leader>ef  :TREPLSendFile<CR>
    " This binding isn't used, it's only here because the default value of ',tt' conflicts with
    "   the current mapping to open a terminal in the current window.
    let g:neoterm_automap_keys = ',lt'


  " }}}
  " Neovim Remote ----------------------------------------------------------------------------- {{{

    " See https://github.com/mhinz/neovim-remote
    " if has('nvim')
    "   let $GIT_EDITOR = 'nvr -cc split --remote-wait'
    " endif

    " autocmd mygroup FileType gitcommit,gitrebase,gitconfig set bufhidden=delete

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
    let g:rnvimr_ranger_cmd = ['ranger', '--cmd="set draw_borders both"']

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
  " Taboo ------------------------------------------------------------------------------------- {{{

    set sessionoptions+=tabpages,globals  " Help taboo remember session options.
    let g:taboo_modified_tab_flag = ''    " Don't mark files as modified.

  " }}}
  " Treesitter -------------------------------------------------------------------------------- {{{

" Must source plugin file manually or it won't be loaded on startup.
  if filereadable($HOME . '/.local/share/nvim/plugged/nvim-treesitter/plugin/nvim-treesitter.vim')
    source $HOME/.local/share/nvim/plugged/nvim-treesitter/plugin/nvim-treesitter.vim

  " Enable tree-sitter highlighting.
  autocmd mygroup BufEnter * TSBufEnable highlight
  autocmd mygroup CursorHold * TSBufEnable highlight

lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  ignore_install = { "bash", "yaml" }, -- List of parsers to ignore installing
  highlight = {
    enable = true, -- false will disable the whole extension
    additional_vim_regex_highlighting = false,
    custom_captures = {},
    disable = { "bash", "yaml" },
    enable = true,
    loaded = true,
    module_path = "nvim-treesitter.highlight"
  },
}
EOF
  endif

  " }}}
  " Undotree ---------------------------------------------------------------------------------- {{{

    " <leader>u to open Vim's undo tree.
    nnoremap <leader>u :UndotreeToggle<CR>

  " }}}
  " Vim Better Whitespace --------------------------------------------------------------------- {{{

    " Don't highlight whitespace.
    " let g:better_whitespace_enabled = 0

    " Automatically strip whitespace.
    " Calling StripWhite() during "CursorHold" will sometimes cause search results to disappear.
    autocmd mygroup BufWritePre,FileWritePre,FileReadPre * call StripWhite()

    function! StripWhite()
        if &modifiable ==# 1 && &readonly ==# 0
            StripWhitespace
        endif
    endfunction

  " }}}
  " Vim Markdown ------------------------------------------------------------------------------ {{{

    let g:vim_markdown_folding_disabled = 1
    let g:vim_markdown_override_foldtext = 0

  " }}}
  " Vim Windowswap ---------------------------------------------------------------------------- {{{

    let g:windowswap_map_keys = 0
    nnoremap <silent> <leader>WW :call WindowSwap#EasyWindowSwap()<CR>

  " }}}

endif

" }}}
" COLORS ###################################################################################### {{{

  " Colors for plugins typically have to come after they're loaded by Vim-plug.

    " Change comment color from grey to turquoise.
    " Make white a bit brighter.
    let g:palenight_color_overrides = {
      \    'comment_grey': { 'gui': '#64bde9', "cterm": "59", "cterm16": "15" },
      \    'white': { 'gui': '#d3dae8', "cterm": "59", "cterm16": "15" },
      \}
    " This has to come AFTER Vim-plug, which is why it's after all the other plugins.
    " If palenight isn't present, try using a different colorscheme.
    try
        colorscheme palenight
    catch /^Vim\%((\a\+)\)\=:E185/
        colorscheme desert
    endtry

    " Make IncSearch and Search highlights the same.
    highlight IncSearch cterm=underline ctermfg=235 ctermbg=180 gui=underline guifg=#292D3E guibg=#ffcb6b
    highlight Search cterm=underline ctermfg=235 ctermbg=180 gui=underline guifg=#292D3E guibg=#ffcb6b
    " Change text selection background.
    highlight Visual gui=bold guifg=#000000 guibg=#00eee0

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

    tnoremap <silent> <C-s> <C-\><C-n>:new<CR>
    tnoremap <silent> <C-\> <C-\><C-n>:vnew<CR>

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
