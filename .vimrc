set shell=/bin/bash\ -i

set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
Plugin 'chriskempson/tomorrow-theme', {'rtp': 'vim/'}

Plugin 'tomtom/tcomment_vim' " comment toggling (N:gcc or V:gc)
Plugin 'rking/ag.vim' " replacement for 'ack', AKA the_silver_searcher (see below)
Plugin 'kien/ctrlp.vim' " directory search (sublime's cmd-T)
Plugin 'Valloric/YouCompleteMe' " auto-completion
Plugin 'scrooloose/nerdtree' " tree view for directory (<leader>d)
Plugin 'airblade/vim-gitgutter' " git gutter
Plugin 'tpope/vim-surround' " delete (ds') or change (cs\"') quotes
" Learn more:
Plugin 'tpope/vim-fugitive' " git integration (:Gblame, :Gdiff, etc.)
Plugin 'bling/vim-airline' " status/tabline
" Plugin 'vim-ruby/vim-ruby'
" Plugin 'tpope/vim-rails'

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
set history=200
set wildmode=longest,list

" configure status and tab lines (airline plugin)
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline_theme = 'tomorrow'
" let g:airline_theme = 'base16'

" configure nerdtree
let NERDTreeShowHidden=1

" REMAPPINGS
nnoremap <SPACE> <Nop>
nnoremap <BS> daw
let mapleader = " "

nnoremap <leader>a :Ag<space>
nnoremap <leader>t :CtrlP<CR>
nnoremap <leader>b :CtrlPBuffer<CR>

nnoremap <C-j> J

noremap H ^
noremap L $
inoremap <C-h> <LEFT>
inoremap <C-l> <RIGHT>
noremap <C-u> d0
noremap <C-k> d$
nnoremap J 20jzz
nnoremap K 20kzz

" navigate panes
nnoremap <leader>h <C-w>h
nnoremap <leader>j <C-w>j
nnoremap <leader>k <C-w>k
nnoremap <leader>l <C-w>l

" navigate buffers
nnoremap <C-h> :bp<CR>
nnoremap <C-l> :bn<CR>
nnoremap <C-w> :bd<CR>

" navigate through command history
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

" no arrow keys! Muahahahaha!
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>

" Setup crosshairs
hi CursorLine   cterm=NONE ctermbg=232
hi CursorColumn cterm=NONE ctermbg=232
set cursorline cursorcolumn

" Save your swp files to a less annoying place than the current directory.
" If you have .vim-swap in the current directory, it'll use that.
" Otherwise it saves it to ~/.vim/swap, ~/tmp or .
if isdirectory($HOME . '/.vim/swap') == 0
  :silent !mkdir -p ~/.vim/swap >/dev/null 2>&1
endif
set directory=./.vim-swap//
set directory+=~/.vim/swap//
set directory+=~/tmp//
set directory+=.

" automatically reload vimrc when it's saved
au BufWritePost .vimrc so ~/.vimrc

" kill trailing whitespace
autocmd BufWritePre {*.rb,*.js,*.coffee,*.html,*.sass,*.scss,*.haml} :%s/\s\+$//e

" ignore these directories/files (for ctrl-p plugin)
set wildignore+=*/tmp/*,*/log/*,*/artifacts/*,*/vendor/*,*/vagrant/*,*/system/*,*/public/*,*/doc/*,*/mock/*,*.sass-cache/*,*.so,*.swp,*.zip

" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif

" plugin settings
let g:ctrlp_match_window = 'order:ttb,max:20'
