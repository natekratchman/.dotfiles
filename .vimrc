set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

Plugin 'tpope/vim-fugitive'
Plugin 'chriskempson/tomorrow-theme', {'rtp': 'vim/'}
Plugin 'tomtom/tcomment_vim'
Plugin 'rking/ag.vim'
Plugin 'kien/ctrlp.vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" Color scheme
syntax enable
colorscheme Tomorrow-Night

set autoindent
set autoread                 " reload files when changed on disk, i.e. via `git checkout`
set clipboard=unnamed 
set encoding=utf-8
set expandtab                " expand tabs to spaces
set ignorecase               " case-insensitive search
set list
set listchars=tab:▸\ ,trail:·
set number
set shiftwidth=2             " normal mode indentation commands use 2 spaces
set smartcase                " case-sensitive search if any caps

let mapleader = ","

nnoremap <leader>a :Ag<space>
nnoremap <leader>t :CtrlP<CR>
nnoremap <leader>b :CtrlPBuffer<CR>

" Setup crosshairs
hi CursorLine   cterm=NONE ctermbg=232
hi CursorColumn cterm=NONE ctermbg=232
set cursorline cursorcolumn

" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects
  " .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif

" plugin settings
let g:ctrlp_match_window = 'order:ttb,max:20'
