" FEATURES ################################################################

  " Identify the filetype.
    filetype indent plugin on
  " Force syntax highlighting.
    syntax on
  " Force unicode encoding.
    set encoding=utf-8
    set nocompatible
  " Auto update when a file is changed from the outside.
    set autoread
    autocmd FocusGained,BufEnter * checktime

" FORMATTING ##############################################################

  " Indents are 4 spaces by default.
    set tabstop=4
    set softtabstop=4
    set shiftwidth=4
  " Convert tabs to spaces.
    set expandtab
  " No automatic formatting.
    set noautoindent
    set nocindent
    set nosmartindent
    set formatoptions-=c
    set formatoptions-=r
    set formatoptions-=o
    set indentexpr=

  " Force certain filetypes to use indents of 2 spaces.
    autocmd FileType config,markdown,vim,yaml setlocal shiftwidth=2 softtabstop=2 tabstop=2
  " Don't wrap text on Markdown files.
    autocmd FileType markdown setlocal nowrap

  " Show line numbers.
    set number
  " Make line number column thinner.
    set numberwidth=1
  " Force cursor to stay in the middle of the screen.
    set scrolloff=999
    set sidescrolloff=999

" BEHAVIOR ################################################################

  " Case-insensitive search, except when using capitals.
    set ignorecase
    set smartcase

  " Map vim copy buffer to system clipboard.
    set clipboard=unnamedplus

  " Show dialog when a comman requires confirmation.
    set confirm

  " Better path autocompletion.
    set wildmenu
    set wildmode=longest,list,full

  " Splits open at the bottom and right, rather than top and left.
    set splitbelow splitright

  " Keep loaded plugins up to date.
    autocmd VimLeave * execute ":UpdateRemotePlugins"

  " Don't use swap files since most files are in Git.
    set noswapfile

  " Allow moving the cursor over blank areas.
    set virtualedit=all

  " Disable Ex mode.
    noremap q: <Nop>
  " Screen redraws clear search restuls.
    noremap <C-L> :nohl<CR><C-L>

" KEYBINDINGS #############################################################

  " Leader key easier to reach.
    let mapleader = ","
  " Easier exiting insert mode.
    inoremap jk <Esc>
  " Easier navigating soft-wrapped lines.
    nnoremap j gj
    nnoremap k gk
  " Faster saving.
    nnoremap <leader>w :write<CR>
    cnoremap w<CR> <Nop>
  " Reload configuration without restarting vim (*source vim*).
    nnoremap <leader>sv :source $MYVIMRC<CR>

  " :W to save the file with sudo, useful for handling the permission-denied error.
    command! W execute 'w !sudo tee % >/dev/null' <bar> edit!

  " Columnize selection.
    vnoremap t :!column -t<CR>
  " Turn off highlighted search results.
    nnoremap Q :nohl<CR><C-L>

  " Git mappings:
    " Vim-Fugitive
      nnoremap ga :write<CR> :Git add %<CR>
      nnoremap gs :Git status<CR>
      nnoremap gl :Git log<CR>
      nnoremap gp :Git push<CR>
      nnoremap giu :Git diff<CR>
      nnoremap gis :Git diff --staged<CR>
      nnoremap gcf :write<CR> :Git commit %<CR>
      nnoremap gcs :Git commit<CR>
      nnoremap grm :Git rm
      nnoremap grs :Git restore
      " Automatically enter Insert mode when opening the commit window.
        autocmd BufWinEnter COMMIT_EDITMSG startinsert

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

  " Tab and split navigation similar to Tmux, except using ALT instead of CTRL.
    nnoremap <M-p> :tabprevious<CR>
    inoremap <M-p> <Esc>:tabprevious<CR>
    nnoremap <M-n> :tabnext<CR>
    inoremap <M-n> <Esc>:tabnext<CR>
    nnoremap <M-c> :tabnew<CR>
    inoremap <M-c> <Esc>:tabnew<CR>
    nnoremap <M-e> :tabclose<CR>
    inoremap <M-e> <Esc>:tabclose<CR>

    nnoremap <M-s> :split<CR>
    inoremap <M-s> <Esc>:split<CR>
    nnoremap <M-k> <C-w><Up>
    inoremap <M-k> <Esc><C-w><Up>
    nnoremap <M-j> <C-w><Down>
    inoremap <M-j> <Esc><C-w><Down>

" PLUGINS #################################################################

  " Load all plugins now.
    packloadall
  " Load all of the helptags now, after plugins have been loaded.
  " All messages and errors will be ignored.
    silent! helptags ALL
  " Reduce plugin update time.
    set updatetime=200

  " ALE ---------------------------------------------------------------------

    " Have ALE remove extra whitespace and trailing lines.
      let g:ale_fixers = {'*': ['remove_trailing_lines', 'trim_whitespace']}

    " ALE will fix files automatically when they're saved.
      let g:ale_fix_on_save = 1

    " Increase linting speed.
      let g:ale_lint_delay = 300

      " Bash
      let g:ale_sh_bashate_options = '--max-line-length 120 --ignore E043'

      " Python
      let g:ale_python_flake8_options = '--config ~/.config/nvim/linters/flake8.config'
      let g:ale_python_pylint_options = '--rcfile ~/.config/nvim/linters/pylintrc.config'

      " YAML
      let g:ale_yaml_yamllint_options = '--config-file ~/.config/nvim/linters/yamllint.yml'
      " Don't run swaglint on YAML files.
      let g:ale_linters = {'yaml': ['yamllint']}

  " BLACK -------------------------------------------------------------------

    " Run Black formatter on saving Python files.
      autocmd BufWritePre *.py execute ':Black'

  " LIGHTLINE ---------------------------------------------------------------

    " Integrates with vim-fugitive to show branch name.
    let g:lightline = {
          \ 'colorscheme': 'one',
          \ 'active': {
          \   'left': [ [ 'mode', 'paste' ],
          \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
          \ },
          \ 'component_function': {
          \   'filename': 'LightlineFilename',
          \   'gitbranch': 'FugitiveHead'
          \ },
          \ }

    " Show the full path of the open file.
      function! LightlineFilename()
        return expand('%F')
      endfunction

    " Don't show the mode in the command line since lightline takes care of it.
    set noshowmode

  " MARKDOWN-PREVIEW --------------------------------------------------------

    " Automatically launch rendered markdown in browser.
      let g:mkdp_auto_start = 1

    " Automatically close rendered markdown in browser.
      let g:mkdp_auto_close = 1

    " Use vimb instead of Firefox since Firefox won't automatically close
    "   the rendered markdown window.
      let g:mkdp_browser = 'vimb'
