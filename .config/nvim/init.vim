" OPTIONS ########################################################################################## {{{

  " Determine if system is at home or at work.
  let hostname = substitute(system('hostname'), '\n', '', '')
  if hostname == "polaris" || "tethys"
    let athome = 1
    let atwork = 0
  else
    let athome = 0
    let atwork = 1
  endif

  filetype indent plugin on             " Identify the filetype, load indent and plugin files.
  syntax on                             " Force syntax highlighting.
  if athome
    if has('termguicolors')
      set termguicolors                 " Enable 24-bit color support.
    endif
  endif

  set encoding=utf-8                    " Force unicode encoding.
  set autoread                          " Auto update when a file is changed from the outside.
  set noshowmode                        " Don't show mode since it's handled by Airline.
  set noshowcmd                         " Don't show command on last line.
  set hidden                            " Hide abandoned buffers. https://stackoverflow.com/questions/26708822/why-do-vim-experts-prefer-buffers-over-tabs?rq=1
  set switchbuf=usetab,newtab           " Use tabs when switching buffers. https://stackoverflow.com/questions/102384/using-vims-tabs-like-buffers

  set ignorecase                        " Case-insensitive search, except when using capitals.
  set smartcase                         " Override ignorecase if search contains capital letters.
  set wildmenu                          " Enable path autocompletion.
  set wildmode=longest,list,full
  " Don't auto-complete these filetypes.
  set wildignore+=*/.git/*,*/.svn/*,*/__pycache__/*,*.pyc,*.jpg,*.png,*.jpeg,*.bmp,*.gif,*.tiff,*.svg,*.ico,*.mp4,*.mkv,*.avi

  set autowriteall                      " Auto-save after certain events.
  set clipboard+=unnamedplus            " Map vim copy buffer to system clipboard.
  set splitbelow splitright             " Splits open at the bottom and right by default, rather than top and left.
  set noswapfile nobackup               " Don't use backups since most files are in Git.

  if athome
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
" AUTOCOMMANDS ##################################################################################### {{{

  " Change cursor to bar when switching to insert mode.
  " Requires `set -ga terminal-overrides ',*:Ss=\E[%p1%d q:Se=\E[2 q'` in tmux config.
  let &t_SI = "\e[6 q"
  let &t_EI = "\e[2 q"
  augroup insertbar
    autocmd!
    autocmd VimEnter * silent !echo -ne "\e[2 q"
  augroup END

  " Automatically clear search results.
  augroup clearsearch
    autocmd!
    autocmd InsertEnter * let @/ = ''
  augroup END

  augroup autoupdate
    autocmd!
    " Automatically update file if changed from outside.
    autocmd FocusGained,BufEnter * checktime
    " Save on focus loss.
    autocmd BufLeave * if &readonly == 0 | silent! write | endif
    " Save after editing text.
    autocmd TextChanged,TextChangedI * if &readonly == 0 | silent! write | endif
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
  augroup vimcd
    autocmd!
    " Set working dir to current file's dir.
    autocmd BufEnter * silent! lcd %:p:h
    " Change to home directory on startup.
    autocmd VimEnter * cd ~
  augroup END

  " https://github.com/jdhao/nvim-config/blob/master/core/autocommands.vim
  " Return to last position when re-opening file.
  augroup lastpos
    autocmd!
    autocmd BufReadPost if line("'\"") > 1 && line("'\"") <= line("$") && &ft !~# 'commit' | execute "normal! g`\"zvzz" | endif
  augroup END

  " Quickly commit and push updates to notes.
  " The QuitPre event will trigger even when exiting with ZZ.
  if athome
    augroup autocommit notes
      autocmd!
      autocmd QuitPre ~/notes/unsorted.md silent :!git -C ~/notes commit -m 'Update unsorted.md' unsorted.md && git push -C ~/notes
    augroup END
  endif

  " Automatically copy changes from ansible repo to personal dotfiles.
  " Use sed to remove the 'Ansible managed' header.
  if atwork
    augroup ansiblecopy
      autocmd!
      autocmd BufWritePost ~/scripts/ansible/inventories/global_files/home/akelley/.vimrc silent :!cp -f ~/scripts/ansible/inventories/global_files/home/akelley/.vimrc ~/.config/nvim/init.vim
      autocmd BufWritePost ~/scripts/ansible/inventories/global_files/home/akelley/.bashrc silent :!sed '0,/ansible_managed/d' ~/scripts/ansible/inventories/global_files/home/akelley/.bashrc > ~/.bashrc
      autocmd BufWritePost ~/scripts/ansible/inventories/global_files/home/akelley/.tmux.conf silent :!sed '0,/ansible_managed/d' ~/scripts/ansible/inventories/global_files/home/akelley/.tmux.conf > ~/.tmux.conf
      autocmd BufWritePost ~/scripts/ansible/inventories/global_files/home/akelley/.bash_profile silent :!sed '0,/ansible_managed/d' ~/scripts/ansible/inventories/global_files/home/akelley/.bash_profile ~/.bash_profile
    augroup END
  endif

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

  augroup formatting
    autocmd!
    " Disable all auto-formatting.
    autocmd FileType * setlocal nocindent nosmartindent formatoptions-=c formatoptions-=r formatoptions-=o indentexpr=
    " Force certain filetypes to use indents of 2 spaces.
    autocmd FileType text,config,markdown,yaml,*.md,vimwiki setlocal nowrap shiftwidth=2 softtabstop=2 tabstop=2
    " Manual folding in vim files.
    autocmd FileType vim setlocal foldlevelstart=0 foldmethod=marker
  augroup END

" }}}
" SHORTCUTS ######################################################################################## {{{

  " Leader key easier to reach.
  let mapleader = ","
  " Faster saving.
  nnoremap <leader>w :write<CR><C-L>
  " Jump back and forth between files.
  noremap <BS> :e#<CR><C-L>

  " Columnize selection.
  vnoremap t :!column -t<CR>
  " Turn off highlighted search results.
  nnoremap Q :nohl<CR><C-L>

  " https://github.com/jdhao/nvim-config/blob/master/core/mappings.vim
  " Continuous visual shifting (does not exit Visual mode), `gv` means
  " to reselect previous visual area, see https://superuser.com/q/310417/736190
  "xnoremap < <gv
  "xnoremap > >gv

  " Easily edit vimrc (ve for 'vim edit').
  if athome
    nnoremap <leader>ve :edit ~/.config/nvim/init.vim<CR>
    if has('nvim') | tnoremap <leader>ve <C-\><C-n>:edit ~/.config/nvim/init.vim<CR> | endif
  elseif atwork
    nnoremap <leader>ve :edit /home/akelley/scripts/ansible/inventories/global_files/home/akelley/.vimrc<CR>
  endif
  " Reload configuration without restarting vim (vs for 'vim source').
  nnoremap <leader>vs :update <bar> :source $MYVIMRC<CR><C-L>

  " Quickly add a note while working on something else.
  function! Notes()
    silent !printf "\n\%s\n\n" "[$(date +\%Y\%m\%d)] $(date +\%A,\ \%b\ \%d\ \%H:\%M:\%S)" >> ~/notes/unsorted.md
    split ~/notes/unsorted.md
    normal! Go
  endfunction

  if athome
    nnoremap <leader>n :call Notes()<CR>
    command! Note      call Notes()

    command! Todo      edit ~/notes/personal--todo.md
    command! I3b       edit ~/.config/i3/i3blocks.conf
    command! I3cc      edit ~/.config/i3/config-shared
    command! I3ccc     edit /tmp/.i3-config
    command! I3        tabnew | cd ~/.config/i3/ | RnvimrToggle
    command! Status    tabnew | cd ~/.config/i3/scripts/status-bar/ | RnvimrToggle
    command! Bashrc    tabnew | cd ~/.config/bashrc.d | RnvimrToggle
    command! Alacritty tabnew | cd ~/.config/alacritty | RnvimrToggle

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
    " *dot commit --amend*
    nnoremap dca :!git --git-dir=$HOME/.cfg/ --work-tree=$HOME commit % -C HEAD --amend

    nnoremap drm :!git --git-dir=$HOME/.cfg/ --work-tree=$HOME rm
    nnoremap drs :!git --git-dir=$HOME/.cfg/ --work-tree=$HOME restore
  endif

" }}}
" PLUGINS ########################################################################################## {{{

  if has ('nvim')
  " Install Vim-Plug ------------------------------------------------------------------------------- {{{

    " Attempt to install vim-plug if it isn't present.
    if !filereadable($HOME . '/.local/share/nvim/site/autoload/plug.vim')
      echo "Attempting to install vim-plug!" | sleep 2
      silent !curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
              https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim')
      autocmd VimEnter * PlugInstall
    endif

  " Increase plugin update speed.
  set updatetime=500

  " }}}
  " Auto Pairs ------------------------------------------------------------------------------------- {{{

    " Only auto-pair the following characters.
    let g:AutoPairs={
    \'(':')',
    \'[':']',
    \'{':'}',
    \"`":"`",
    \'```':'```',
    \'"""':'"""',
    \"'''":"'''"
    \}

  " }}}
  " Airline ---------------------------------------------------------------------------------------- {{{
    if athome
      let g:airline_theme='palenight'
      " Use Nerd Fonts from Vim-devicons.
      let g:airline_powerline_fonts = 1
    elseif atwork
      let g:airline_theme='dark'
    endif

    let g:airline_highlighting_cache = 1

    " Disable unnecessary extensions.
    let g:airline#extensions#grepper#enabled = 0
    let g:airline#extensions#tagbar#enabled = 0
    let g:airline#extensions#po#enabled = 0
    let g:airline#extensions#netrw#enabled = 0
    let g:airline#extensions#keymap#enabled = 0
    let g:airline#extensions#fzf#enabled = 0

    " The tabline incorrectly displays terminal buffers.
    " let g:airline#extensions#tabline#show_buffers = 0      " Don't show buffers when a single tab is open.
    " let g:airline#extensions#tabline#fnamemod = ':p:t'     " Format filenames in tabline.
    " let g:airline#extensions#tabline#enabled = 1           " Replace the tabline with Airline's.
    " let g:airline#extensions#tabline#show_splits = 0       " Don't show splits in the tabline.
    " let g:airline_detect_modified = 0                      " Don't loudly mark files as modified.
    " let g:airline#extensions#tabline#show_tab_nr = 0       " Don't show tab numbers.
    " let g:airline#extensions#tabline#show_tab_count = 0    " Don't show number of tabs on top-right.
    " let g:airline#extensions#tabline#show_tab_type = 0     " Don't show tab type.
    " let g:airline#extensions#tabline#show_close_button = 0 " Don't show tab close button.

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
    augroup black
      autocmd!
      autocmd BufWritePre *.py execute ':Black'
    augroup END

  " }}}
  " Buffergator ------------------------------------------------------------------------------------ {{{

    " Keep buffer bar open after selecting a buffer.
    " let g:buffergator_autodismiss_on_select = 0
    " let g:buffergator_autoupdate = 1
    " let g:buffergator_vsplit_size = 25
    " let g:buffergator_display_regime = "basename"
    " let g:buffergator_sort_regime = "basename"
    " let g:buffergator_suppress_keymaps = 1

    " Keep buffer bar open.
    " augroup buffergator
    " autocmd!
    " autocmd VimEnter * BuffergatorOpen
    " autocmd TabNew * BuffergatorOpen
    " autocmd TabEnter * BuffergatorOpen
    " autocmd TabEnter * wincmd l
    " augroup END


  " }}}
  " COC -------------------------------------------------------------------------------------------- {{{

    if athome
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
    endif

  " }}}
  " CtrlP ------------------------------------------------------------------------------------------ {{{

    " <leader>s to start searching from home directory (s for 'search').
    " <leader>S to start searching from project directory.

    " CTRL-j and CTRL-k to navigate through results.
    " CTRL-t to open the desired file in a new tab.
    " CTRL-v to open the desired file in a new vertical split.

    if atwork
      let g:ctrlp_map = '<leader>F'
      " For some reason mapping this normally doesn't work.
      autocmd VimEnter * nnoremap <leader>f :CtrlP ~/<CR>

      let g:ctrlp_tabpage_position = 'ac'
      let g:ctrlp_working_path_mode = 'rw' " Set search path to start at first .git directory below the cwd.

      let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:15,results:15' " Change height of search window.
      let g:ctrlp_show_hidden = 1                                           " Index hidden files.
      let g:ctrlp_clear_cache_on_exit = 0                                   " Keep cache accross reboots.
      let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn|swp|cache|tmp)$'     " Don't index these filetypes in addition to Wildignore.
    endif

  " }}}
  " Devicons --------------------------------------------------------------------------------------- {{{

    if athome
      " Enable Nerd Fonts (requires AUR package).
      set guifont=Nerd\ Font\ 11

      " https://github.com/ryanoasis/vim-devicons
      " Fix issues re-sourcing Vimrc.
      if exists("g:loaded_webdevicons")
        call webdevicons#refresh()
      endif
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
    augroup commit
      autocmd!
      autocmd BufWinEnter COMMIT_EDITMSG startinsert
    augroup END

  " }}}
  " Grepper ---------------------------------------------------------------------------------------- {{{

    if athome
      " <leader>g to start grepping (g for 'grep').

      " Use `}`and `{` to jump to contexts. `o` opens the current context in the
      " last window. `<cr>` opens the current context in the last window, but closes
      " the current window first.

      nnoremap <leader>G :Grepper -tool rg -cd ~/<CR>
      nnoremap <leader>g :Grepper -tool rg<CR>

      " I have to recreate the entire rg command here if I want to add
      "  additional options since it doesn't work correctly otherwise.
      silent! let g:grepper.rg.grepprg = 'rg
        \ -H
        \ --no-heading
        \ --vimgrep
        \ --hidden
        \ -g "!**/.LfCache"
        \ -g "!**/.ansible"
        \ -g "!**/.cache"
        \ -g "!**/.cargo"
        \ -g "!**/.cfg"
        \ -g "!**/.gem"
        \ -g "!**/.local"
        \ -g "!**/.mozilla"
        \ -g "!**/.npm"
        \ -g "!**/.tmux"
        \ -g "!**/.fltk"
        \ -g "!**/.gnupg"
        \ -g "!**/.gnupg"
        \ '

      silent! let g:grepper.quickfix = 0 " Don't use the quickfix menu.
      silent! let g:grepper.side = 1     " Open results with context in a side window.
      silent! let g:grepper.stop = 1000  " Stop after this many matches.
      silent! let g:grepper.prompt_text = '$t> '

    endif
  " }}}
  " GitGutter -------------------------------------------------------------------------------------- {{{

    " Make sidebar dark.
    if athome | highlight SignColumn cterm=bold ctermbg=0 guibg=0 | endif
    " Undo git changes easily.
    nnoremap gu :GitGutterUndoHunk<CR>
    " View interactive git diff.
    nnoremap gd :Gdiffsplit<CR>
    " Fix git diff colors.
    if athome | highlight DiffText ctermbg=1 ctermfg=3 guibg=1 guifg=3 | endif

  " }}}
  " Highlighted Yank ------------------------------------------------------------------------------- {{{

    let g:highlightedyank_highlight_duration = 200
    highlight link HighlightedyankRegion Search

  " }}}
  " Indentline ------------------------------------------------------------------------------------- {{{
    let g:indentLine_char = '┊'

    " Exclude help pages and terminals.
    let g:indentLine_bufTypeExclude = ['help', 'terminal', 'markdown', 'vimwiki']
    let g:indentLine_bufNameExclude = ['term:*']

  " }}}
  " LeaderF ---------------------------------------------------------------------------------------- {{{

    if athome
      " <leader>f to start searching from home directory (f for 'find').
      " <leader>F to start searching from project directory.

      " <leader>/ to grep for a string in all open buffers.
      " <leader>b to search within open buffers.
      " <leader>m to search recently used files.

      " CTRL-j and CTRL-k to navigate through results.
      "<C-X> : open in horizontal split window.
      "<C-]> : open in vertical split window.
      "<C-T> : open in new tabpage.

      nnoremap <leader>f :LeaderfFile ~/<CR>
      nnoremap <leader>F :LeaderfFile<CR>

      nnoremap <leader>m :LeaderfMru<CR>

      nnoremap <leader>/ :LeaderfLineAll<CR>

      let g:Lf_ShowHidden = 1      " Index hidden files.
      let g:Lf_MruMaxFiles = 10000 " Index all used files in MRU list.

      "highlight Lf_hl_selection guifg=Black guibg=Black gui=Bold ctermfg=Black ctermbg=156 cterm=Bold

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
  " Markdown Preview ------------------------------------------------------------------------------- {{{

    if athome
      " Markdown preview with mp.
      augroup markdownpreview
        autocmd!
        autocmd FileType markdown nnoremap mp :MarkdownPreview<CR><C-L>
      augroup END

      "let g:mkdp_auto_start = 1  " Automatically launch rendered markdown in browser.
      let g:mkdp_auto_close = 1   " Automatically close rendered markdown in browser.

      " Use vimb since Firefox won't automatically close the rendered markdown window.
      let g:mkdp_browser = 'vimb'
    endif

  " }}}
  " NERD Commenter --------------------------------------------------------------------------------- {{{

    " <leader>cc to comment a block.
    " <leader>cu to uncomment a block.
   let g:NERDSpaceDelims = 1
   let g:NERDDefaultAlign = 'left'

  " }}}
  " Ranger ----------------------------------------------------------------------------------------- {{{

    if atwork
      " <leader>r to open file manager.
      nnoremap <silent> <leader>r :Ranger<CR>
    endif

  " }}}
  " Rnvimr ----------------------------------------------------------------------------------------- {{{

    if athome
      " <leader>r to open file manager.
      nnoremap <silent> <leader>r :RnvimrToggle<CR>

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
    endif

  " }}}
  " Tagbar ----------------------------------------------------------------------------------------- {{{

    " Launch the tagbar by default when opening files >1000 lines.
      "autocmd BufReadPost * if

    " Launch the tagbar by default when opening Python files.
      "autocmd FileType python TagbarToggle

  " }}}
  " Undotree --------------------------------------------------------------------------------------- {{{

    " <leader>u to open Vim's undo tree.
    nnoremap <leader>u :UndotreeToggle<CR>

  " }}}
  " Workspace -------------------------------------------------------------------------------------- {{{

    " Automatically close leftover hidden buffers after reloading session.
    augroup closebuffers
        autocmd!
        autocmd SessionLoadPost * CloseHiddenBuffers
    augroup END

    " Automatically create, save, and restore sessions.
    let g:workspace_autocreate = 1
    let g:workspace_session_name = $HOME . '/.vim/sessions/session.vim'
    " These options are for auto-saving individual files, but it breaks the cedit window.
    let g:workspace_autosave = 0
    let g:workspace_autosave_always = 0
    " Don't deal with persisting undo history, since it's already handled.
    let g:workspace_persist_undo_history = 0

  " }}}
  " Vim Wiki --------------------------------------------------------------------------------------- {{{

    let g:vimwiki_list = [{'path': '~/notes/', 'syntax': 'markdown', 'ext': '.md'},
                         \{'path': '~/linux-notes/', 'syntax': 'markdown', 'ext': '.md'}]

    let g:vimwiki_conceallevel = 1
    let g:vimwiki_conceal_onechar_markers = 0

    " Override some of Vimwiki's configs.
    " For some reason this only works after the BufEnter event.
    augroup conceal
      autocmd!
      " Only conceal markdown syntax in Normal mode.
      autocmd BufEnter *.md,vimwiki,markdown setlocal concealcursor=n conceallevel=1
    augroup END

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
    " augroup VimrcAuGroup
    "   autocmd!
    "   autocmd FileType vimwiki setlocal foldmethod=expr |
    "     \ setlocal foldenable | set foldexpr=VimwikiFoldLevelCustom(v:lnum)
    " augroup END

  " }}}

  " Vim-Plug --------------------------------------------------------------------------------------- {{{

    call plug#begin(stdpath('data') . '/plugged')

    " Navigation {{{

      " Search within files.
      Plug 'mhinz/vim-grepper'
      " Find and replace.
      Plug 'brooth/far.vim'

      " Filename search.
      if athome
        Plug 'Yggdroot/LeaderF', { 'do': ':LeaderfInstallCExtension' }
      elseif atwork
        Plug 'ctrlpvim/ctrlp.vim'
      endif
      "Plug 'junegunn/fzf', { 'do': { -> fzf#install()  }  }
      "Plug 'junegunn/fzf.vim'
      "Plug 'wincent/command-t'

      " File manager.
      if athome
        Plug 'kevinhwang91/rnvimr'
      elseif atwork
        Plug 'francoiscabrol/ranger.vim'
        " Dependency for ranger.vim.
        Plug 'rbgrouleff/bclose.vim'
      endif

      " Function navigation on large files.
      Plug 'preservim/tagbar'

      " Buffer management.
      "Plug 'jeetsukumaran/vim-buffergator'
      "Plug 'bling/vim-bufferline'
      "Plug 'jlanzarotta/bufexplorer'

      " Smooth scrolling.
      Plug 'psliwka/vim-smoothie'

    " }}}
    " Programming {{{

      " Git integration.
      Plug 'airblade/vim-gitgutter'
      Plug 'tpope/vim-fugitive'
      Plug 'jreybert/vimagit'

      " Code formatting.
      Plug 'psf/black', { 'for': 'python', 'branch': 'stable' }
      " Code completion.
      if athome | Plug 'neoclide/coc.nvim', { 'branch': 'release' } | endif
      " Linting engine.
      Plug 'dense-analysis/ale'
      " Better syntax highlighting.
      Plug 'sheerun/vim-polyglot'

    " }}}
    " Usability {{{

      " Session save and restore.
      Plug 'thaerkh/vim-workspace'
      "Plug 'xolox/vim-misc'
      "Plug 'xolox/vim-session'

      " Visualize and navigate Vim's undo tree.
      Plug 'mbbill/undotree'

      " Status bar.
      Plug 'vim-airline/vim-airline'
      Plug 'vim-airline/vim-airline-themes'

      " Easily comment blocks.
      Plug 'preservim/nerdcommenter'
      " Show indentation lines.
      Plug 'yggdroot/indentline'
      " Auto-create bracket and quote pairs.
      Plug 'jiangmiao/auto-pairs'

      " View man pages without leaving Neovim (:Man <COMMAND>).
      Plug 'vim-utils/vim-man'
      " Briefly highlight yanked text.
      Plug 'machakann/vim-highlightedyank'

      if athome
        " Colorschemes.
        Plug 'drewtempelmeyer/palenight.vim'
        "Plug 'morhetz/gruvbox'
        "Plug 'joshdick/onedark.vim'
        " Icons (Must be loaded after all the plugins that use it).
        Plug 'ryanoasis/vim-devicons'
        " Note management
        Plug 'vimwiki/vimwiki', { 'branch': 'dev' }
        " Render markdown.
        Plug 'iamcco/markdown-preview.nvim'

        " Terminal in a floating window.
        Plug 'voldikss/vim-floaterm'
        " LeaderF extension for Floaterm.
        Plug 'voldikss/leaderf-floaterm'
     endif

   " }}}

  call plug#end()
  " }}}

endif

" }}}
" COLORS ########################################################################################### {{{

  " Colors for plugins typically have to come after they're loaded by Vim-plug.

  if athome

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

  elseif atwork

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

" }}}
" NAVIGATION ####################################################################################### {{{

  " Easier exiting insert mode.
  inoremap jk <Esc>
  if has('nvim') | tnoremap fd <C-\><C-n> | endif
  " Easier navigating soft-wrapped lines.
  nnoremap j gj
  nnoremap k gk
  " Easier jumping to beginning and ends of lines.
  nnoremap L $
  nnoremap H ^
  " Navigate quick-fix menus and helpgrep results.
  " <leader>n is for opening notes, which is more common.
  nnoremap <leader>N :cnext<CR>
  nnoremap <leader>P :cprevious<CR>

  " CTRL-n/p to navigate tabs.
  nnoremap <silent> <C-p> :tabprevious<CR>
  inoremap <silent> <C-p> <Esc>:tabprevious<CR>
  nnoremap <silent> <C-n> :tabnext<CR>
  inoremap <silent> <C-n> <Esc>:tabnext<CR>

  " Jump to last active tab (a for 'alternate').
  augroup tableave
    autocmd!
    autocmd TabLeave * let g:lasttab = tabpagenr()
  augroup END
  nnoremap <leader>a :exe "tabn ".g:lasttab<CR>

  " Create and delete tabs web-browser-style.
  nnoremap <C-t> :tabnew<CR>
  inoremap <C-t> <Esc>:tabnew<CR>
  nnoremap <silent> <C-w> :q!<CR>
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
  nnoremap <A-Right> :vertical resize -5<CR><C-L>
  inoremap <A-Right> <Esc>:vertical resize -5<CR><C-L>

  nnoremap <A-Left> :vertical resize +5<CR><C-L>
  inoremap <A-Left> <Esc>:vertical resize +5<CR><C-L>

  nnoremap <A-Up> :resize +2<CR><C-L>
  inoremap <A-Up> <Esc>:resize +2<CR><C-L>

  nnoremap <A-Down> :resize -2<CR><C-L>
  inoremap <A-Down> <Esc>:resize -2<CR><C-L>

  " Terminal-related shortcuts.
  if has('nvim')
    nnoremap <silent> <leader>t           :terminal<CR>
    tnoremap <silent> <leader>t <C-\><C-n>:terminal<CR>
    nnoremap <silent> <leader>tt           :terminal<CR>
    tnoremap <silent> <leader>tt <C-\><C-n>:terminal<CR>

    nnoremap <silent> <leader>tf           :FloatermToggle<CR>
    tnoremap <silent> <leader>tf <C-\><C-n>:FloatermToggle<CR>

    nnoremap <silent> <leader>tn           :tabnew <bar> terminal<CR>
    tnoremap <silent> <leader>tn <C-\><C-n>:tabnew <bar> terminal<CR>
    nnoremap <silent> <leader>ts           :split <bar> terminal<CR>
    tnoremap <silent> <leader>ts <C-\><C-n>:split <bar> terminal<CR>
    nnoremap <silent> <leader>tv           :vsplit <bar> terminal<CR>
    tnoremap <silent> <leader>tv <C-\><C-n>:vsplit <bar> terminal<CR>

    tnoremap <silent> ZZ <C-\><C-n>:q!<CR>

    tnoremap <silent> <C-n> <C-\><C-n>:tabnext<CR>
    tnoremap <silent> <C-p> <C-\><C-n>:tabprevious<CR>

    tnoremap <silent> <C-t> <C-\><C-n>:enew<CR>
    tnoremap <silent> <C-w> <C-\><C-n>:q!<CR>
    tnoremap <leader>a <C-\><C-n>:exe "tabn ".g:lasttab<CR>

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

  " Tabline function from https://vim.fandom.com/wiki/Show_tab_number_in_your_tab_line
  if exists("+showtabline")
    function MyTabLine()
      let s = ''
      let t = tabpagenr()
      let i = 1
      while i <= tabpagenr('$')
        let buflist = tabpagebuflist(i)
        let winnr = tabpagewinnr(i)
        let s .= '%' . i . 'T'
        let s .= (i == t ? '%1*' : '%2*')
        let s .= ' '
        "let s .= i . ')'
        let s .= ' %*'
        let s .= (i == t ? '%#TabLineSel#' : '%#TabLine#')
        let file = bufname(buflist[winnr - 1])
        let file = fnamemodify(file, ':p:t')
        if file == ''
          let file = '[No Name]'
        endif
        let s .= file
        let i = i + 1
      endwhile
      let s .= '%T%#TabLineFill#%='
      let s .= (tabpagenr('$') > 1 ? '%999XX' : 'X')
      return s
    endfunction
    set stal=2
    set tabline=%!MyTabLine()
  endif

" }}}

" UNUSED FUNCTIONS ################################################################################# {{{

"  " If a split exists, navigate to it. Otherwise, create a split.
"  " Currently not used, since I kept unintentionally splitting windows.
"  " https://breuer.dev/blog/top-neovim-plugins.html
"  function! WinMove(key)
"    let t:curwin = winnr()
"    exec "wincmd ".a:key
"    if (t:curwin == winnr())
"      if (match(a:key,'[jk]'))
"        vsplit
"      else
"        split
"      endif
"      exec "wincmd ".a:key
"    endif
"  endfunction

"  " CTRL-h/j/k/l to navigate and create splits.
"  nnoremap <silent> <C-k>      :call WinMove('k')<CR>
"  inoremap <silent> <C-k> <Esc>:call WinMove('k')<CR>

"  nnoremap <silent> <C-j>      :call WinMove('j')<CR>
"  inoremap <silent> <C-j> <Esc>:call WinMove('j')<CR>

"  nnoremap <silent> <C-h>      :call WinMove('h')<CR>
"  inoremap <silent> <C-h> <Esc>:call WinMove('h')<CR>

"  nnoremap <silent> <C-l>      :call WinMove('l')<CR>
"  inoremap <silent> <C-l> <Esc>:call WinMove('l')<CR>

"  tnoremap <silent> <C-k> <C-\><C-n>:call WinMove('k')<CR>
"  tnoremap <silent> <C-j> <C-\><C-n>:call WinMove('j')<CR>
"  tnoremap <silent> <C-h> <C-\><C-n>:call WinMove('h')<CR>
"  tnoremap <silent> <C-l> <C-\><C-n>:call WinMove('l')<CR>

"  }}}
