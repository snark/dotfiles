" Note that this vimrc goes to some effort to be something that can just
" be pasted into a random terminal and work successfully, without any plugins
" needing to be present.
"
" Neovim defaults
" {{{
if !has('nvim')
  set nocompatible                  " Disable vi compatibility
  syntax on                         " Syntax highlighting
  filetype plugin indent on         " Detect file types
  set autoindent                    " Indent at the same level of the previous line
  set autoread                      " Automatically read files changed outside of vim
  set backspace=indent,eol,start    " Sane backspace behavior--through line breaks, etc
  set complete-=i                   " Exclude files completion
  set display=lastline              " Show as much as possible of the last line
  set encoding=utf-8                " UTF-8 by default
  set history=10000                 " Maximum history record
  set hlsearch                      " Highlight search terms
  set incsearch                     " Find as you type search
  set laststatus=2                  " Always show status line
  set mouse=a                       " Automatically enable mouse usage
  set smarttab                      " Smart tab
  set ttyfast                       " Faster redrawing
  set viminfo+=!                    " Viminfo include !
  set wildmenu                      " Show list instead of just completing

  set ttymouse=xterm2
endif
" }}}

" ----- Base rules not covered by nvim defaults -----
" {{{
let mapleader = ","
set nomodeline              " Disable modeline for security reasons
set lazyredraw              " Less aggressive redrawing
" }}}

" ----- Display -----
" {{{
set number                  " Show line numbers
set hidden                  " Show hidden characters
set showcmd                 " Show command in statusline
set showmode                " Show mode in statusline
set ruler                   " Display ruler in statusline
set rulerformat=%l,%c       " ...as line,column
set cursorline              " Highlight current line
hi clear cursorline         " ...then clear it, leaving the line number highlighted
set ttyfast                 " Smoother changes
set title                   " Show file name in console title bar
set showmatch               " Highlight matching open/close characters
set list                    " Display whitespace
set listchars=tab:▸\ ,eol:¬ " Whitespace definitions
set visualbell              " Disable bell in terminal
" Preferred display font
set guifont=Bitstream\ Vera\ Sans\ Mono:h12
" }}}

" ----- Wrap -----
" {{{
set wrap                    " Activate wrapping
set textwidth=79            " Break at 80 columns
set formatoptions=qrn1      " q: allow comment formatting with `qq`
                            " r: in insert mode, add comment leader after <enter>
                            " n: recognize numbered lists
                            " 1: don't break after 1-letter word
" }}}

" ----- Tabs -----
" {{{
set expandtab               " tabs are spaces, not tabs
set tabstop=4               " N visual spaces per tab
set softtabstop=4           " N spaces inserted/removed in editing
set shiftwidth=4            " match tabstop
" }}}

" ----- Swap and Backup -----
" {{{
" Back up to .vim/, using full paths to avoid collision.
set backupdir=~/.vim/backup//,.,/tmp//
set directory=~/.vim/swp//,.,/tmp//
set undodir=~/.vim/undo//,.,/tmp//
" }}}

" ----- Search and Replace -----
" {{{
set gdefault                " Regexes use g by default (add g to disable)
set ignorecase              " Case insensitive search
set smartcase               " ... but case sensitive when uc present
" Disable search highlight with space
nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>
" }}}

" ----- Mappings -----
" {{{
" Map Y to act like D and C, i.e. to yank until EOL, rather than act as yy,
" which is the default
map Y y$
" Map semicolon onto colon
nnoremap ; :
" jj is escape--mostly useful on computers where caps lock hasn't been
" remapped but there is no physical escape key
inoremap jj <Esc>
" Move up and down by visual line, not file line
nnoremap j gj
nnoremap k gk
" }}}

" ----- Plugins -----
" {{{
if !empty(glob('~/.vim/autoload/plug.vim'))
    call plug#begin('~/.vim/plugged')
    Plug 'ciaranm/securemodelines'      " Restore our disabled modelines
    Plug 'itchyny/lightline.vim'        " Airline or powerline, written in vimscript
    Plug 'itchyny/vim-gitbranch'        " Feeds lightline branch info
    Plug 'mbbill/undotree'              " TUI undo tree visualizer
    Plug 'tpope/vim-surround'           " Adds 's' movement key
    Plug 'tpope/vim-repeat'             " Makes '.' accessible to plugin mappings
    if !empty(glob('/usr/local/opt/fzf'))
        Plug '/usr/local/opt/fzf'       " Fuzzy-finder (default Homebrew install location)
        Plug 'junegunn/fzf.vim'         " ...and its vim interface
    endif
    " Colorschemes
    Plug 'tpope/vim-vividchalk'         " Old favorite
    Plug 'NLKNguyen/papercolor-theme'   " And a couple new ones I'm trying
    Plug 'lucasprag/simpleblack'        " Current favorite
    Plug 'fenetikm/falcon'
    Plug 'sickill/vim-sunburst'
    call plug#end()
endif

" Some configuration for our plugins, assuming they've been installed
if !empty(glob('~/.vim/plugged/lightline.vim'))
    set noshowmode                      " Lightline will do this for us
    set noshowmode                      " Lightline will do this for us
    let g:lightline = {
      \ 'colorscheme': 'simpleblack',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'filename', 'gitbranch', 'readonly', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'gitbranch#name'
      \ },
      \ }
endif
if !empty(glob('~/.vim/plugged/undotree'))
    nnoremap <C-S-U> :UndotreeToggle<CR>
endif
" }}}

" ----- Leadermappings ----
" {{{
" One from Steve Losh: strip all trailing whitespace
nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>
" Turn colorcolumn on and off
nnoremap <silent> <leader>c :execute "set colorcolumn=" . (&colorcolumn == "" ? "80" : "")<CR>
" And some handy vertical split controls, also from Steve Losh
nnoremap <leader>w <C-w>v<C-w>l     " ,w opens vertical split and switches to it
nnoremap <C-h> <C-w>h               " Control-<vim navigation> to navigate split windows
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
" }}}

" ----- Colors -----
" {{{
" Note that we are putting colors *after* Plugins to allow us to load
" colorschemes via vim-plugin.
set background=dark                     " Dark background
silent! colors desert                   " Sane default on base systems
" With true black background
hi NonText ctermbg=black guibg=black
hi Normal ctermbg=black guibg=black
silent! colors simpleblack
" Suppress highlighting
hi CursorLine gui=NONE cterm=NONE guibg=NONE ctermbg=NONE
" Grey line numbers, but yellow when highlighted
hi LineNr cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE
hi CursorLineNR cterm=NONE ctermfg=yellow gui=NONE guifg=yellow
if !empty(glob('~/.vim/plugged/fzf.vim'))
" Customize fzf colors to match your color scheme
    let g:fzf_colors =
  \ { 'fg':    ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }
endif
" }}}

" ----- Miscellaneous -----
"{{{
" Fixes an issue specifically with editing crontabs on OSX:
" https://superuser.com/questions/359580/error-adding-cronjobs-in-mac-os-x-lion/907889#907889
autocmd filetype crontab setlocal nobackup nowritebackup 
" Don't display the intro message on startup
set shortmess+=I
" Improve responsiveness for use of escape key
set ttimeout
set ttimeoutlen=20
"}}}

" vim: set foldmarker={,} foldlevel=0 foldmethod=marker spell:
