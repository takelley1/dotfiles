" FEATURES ################################################################

  " Identify the filetype.
    filetype indent plugin on
  " Force syntax highlighting.
    syntax on
  " Force unicode encoding.
    set encoding=utf-8
    set nocompatible

" FORMATTING ##############################################################

  " Convert tabs to spaces.
    set tabstop=4
    set softtabstop=4
    set shiftwidth=4

    set expandtab
    set smarttab
    set smartindent

  " Force certain filetypes to use indents of 2 spaces.
    autocmd FileType yaml setlocal shiftwidth=2 softtabstop=2 tabstop=2
    autocmd FileType vim setlocal shiftwidth=2 softtabstop=2 tabstop=2

  " Show line numbers.
    set number
  " Make line number column thinner.
    set numberwidth=1
  " Force cursor to stay in the middle of the screen.
    set so=999

" BEHAVIOR ################################################################

  " Case-insensitive search, except when using capitals.
    set ignorecase
    set smartcase

  " Map vim copy buffer to system clipboard.
    set clipboard=unnamedplus

  " Show dialog when a comman requires confirmation.
    set confirm

  " Disables automatic commenting and indenting on newline.
    autocmd FileType * setlocal
      \ formatoptions-=c
      \ formatoptions-=r
      \ formatoptions-=o
      \ indentexpr=
      \ noautoindent
      \ nocindent
      \ nosmartindent

  " Better path autocompletion.
    set wildmenu
    set wildmode=longest,list,full

  " Splits open at the bottom and right, rather than top and left.
    set splitbelow splitright

  " Keep loaded plugins up to date.
    autocmd VimLeave * execute ":UpdateRemotePlugins"

  " Run xrdb whenever Xdefaults or Xresources is updated.
    autocmd BufWritePost *Xresources,*Xdefaults !xrdb %

" KEYBINDINGS #############################################################

  " Remap jk to ESC for easier exiting insert mode.
    inoremap jk <ESC>

  " Columnize selection.
    vnoremap t :!column -t<CR>

  " Disable Ex mode.
    map q: <Nop>
  " Remap Q to :nohl to turn off highlighted search results.
    nnoremap Q :nohl<CR><C-L>
  " Also trigger screen redraws to clear search restuls.
    nnoremap <C-L> :nohl<CR><C-L>

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
