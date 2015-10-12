set shell=/bin/bash\ -i " enable interactive shell with :shell ex command

" required
set nocompatible
filetype off

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim' " let Vundle manage Vundle, required
Plugin 'chriskempson/tomorrow-theme', {'rtp': 'vim/'}
Plugin 'tomtom/tcomment_vim' " comment toggling (N:gcc or V:gc)
Plugin 'rking/ag.vim' " replacement for 'ack', AKA the_silver_searcher
Plugin 'kien/ctrlp.vim' " directory search (sublime's cmd-T)
Plugin 'Valloric/YouCompleteMe' " auto-completion
Plugin 'scrooloose/nerdtree' " tree view for directory (<leader>d)
Plugin 'airblade/vim-gitgutter' " git gutter
Plugin 'tpope/vim-surround' " delete (ds') or change (cs\"') quotes
Plugin 'tpope/vim-fugitive' " git integration (:Gblame, :Gdiff, etc.)
" Plugin 'bling/vim-airline' " status/tabline
Plugin 'tpope/vim-rails' " informs path of Rails file structure
Plugin 'kchmck/vim-coffee-script' " coffeescript linter
Plugin 'vim-ruby/vim-ruby'
Plugin 'tpope/vim-endwise' " auto-complete 'end' in Ruby
Plugin 'nelstrom/vim-visual-star-search' " makes * and # work in visual mode

" === All Plugins must be added above this line ===
call vundle#end()

" Scripts
runtime macros/matchit.vim

" Configure plugins
" let g:airline#extensions#tabline#enabled = 1
" let g:airline#extensions#tabline#left_sep = ' '
" let g:airline#extensions#tabline#left_alt_sep = '|'
" let g:airline_theme = 'tomorrow'
let NERDTreeShowHidden = 1
let NERDTreeRespectWildIgnore = 1
let NERDTreeQuitOnOpen = 1
let NERDTreeMinimalUI = 1
let NERDTreeAutoDeleteBuffer = 1
let g:ctrlp_show_hidden = 1
let g:ctrlp_use_caching = 0
let g:ctrlp_match_window = 'order:ttb,max:20'
let g:ctrlp_custom_ignore = '*/cassettes/*'

" source mappings
:so ~/.mappings.vim

" required (cont.)
syntax enable
filetype plugin indent on

" Color scheme
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
set tabstop=2
set softtabstop=2
set shiftwidth=2             " normal mode indentation commands use 2 spaces
set smartcase                " case-sensitive search if any caps
set history=10000
set wildmode=longest,list
set incsearch
set scrolloff=5
set backspace=indent,eol,start
set showcmd                  " display incomplete commands
set nobackup                 " don't make backups at all (incl. 3 below)
set nowritebackup
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set cmdheight=1
set winwidth=79
set modifiable

" Setup crosshairs
hi CursorLine   cterm=NONE ctermbg=232
hi CursorColumn cterm=NONE ctermbg=232
set cursorline cursorcolumn

" automatically reload vimrc when it's saved
" au BufWritePost .vimrc so ~/.vimrc

" kill trailing whitespace
autocmd BufWritePre {*.rb,*.js,*.coffee,*.html,*.sass,*.scss,*.haml} :%s/\s\+$//e

" ignore these directories/files (for ctrl-p plugin)
set wildignore+=*/cassettes/*,*/tmp/*,*/log/*,*/artifacts/*,*/vendor/*,*/vagrant/*,*/system/*,*/public/*,*/doc/*,*/mock/*,*.sass-cache/*,*.so,*.swp,*.zip

" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif

