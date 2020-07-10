set shell=/bin/bash\ -i " enable interactive shell with :shell ex command

" required
set nocompatible
filetype off

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim' " let Vundle manage Vundle, required
Plugin 'chriskempson/tomorrow-theme', {'rtp': 'vim/'}
Plugin 'scrooloose/nerdcommenter' " comment toggling
Plugin 'rking/ag.vim' " replacement for 'ack', AKA the_silver_searcher
Plugin 'kien/ctrlp.vim' " directory search
Plugin 'Valloric/YouCompleteMe' " auto-completion
Plugin 'scrooloose/nerdtree' " tree view for directory
Plugin 'airblade/vim-gitgutter' " git gutter
Plugin 'tpope/vim-surround' " delete (ds') or change (cs\"') quotes
Plugin 'tpope/vim-fugitive' " git integration (:Gblame, :Gdiff, etc.)
Plugin 'tpope/vim-rails' " informs path of Rails file structure
Plugin 'kchmck/vim-coffee-script' " coffeescript linter
Plugin 'vim-ruby/vim-ruby'
Plugin 'tpope/vim-endwise' " auto-complete 'end' in Ruby
Plugin 'nelstrom/vim-visual-star-search' " makes * and # work in visual mode
Plugin 'tpope/vim-abolish' " subversion (:Subvert/child{,ren}/adult{,s}/g) and case coercion (crs: snake_case, crm: MixedCase, crc: camelCase, cru: UPPER_CASE)
Plugin 'tpope/vim-repeat' " enable repeat for tpope plugins
Plugin 'bkad/CamelCaseMotion' " add camel-wise motions (mimic word-wise motions)
Plugin 'slim-template/vim-slim' " syntax highlighting for Slim
Plugin 'tpope/vim-haml' " syntax highlighting for Haml
Plugin 'mxw/vim-jsx' " syntax highlighting for jsx
Plugin 'christoomey/vim-conflicted' " aids in resolving git merge and rebase conflicts
Plugin 'smerrill/vcl-vim-plugin' " syntax highlighting for VCL
Plugin 'nathanaelkane/vim-indent-guides' " visually displays indent levels
Plugin 'tpope/vim-rhubarb' " enables :Gbrowse (from fugitive.vim) to open GitHub URLs

" === All Plugins must be added above this line ===
call vundle#end()

let NERDTreeShowHidden = 1
let NERDTreeRespectWildIgnore = 1
let NERDTreeQuitOnOpen = 1
let NERDTreeMinimalUI = 1
let NERDTreeAutoDeleteBuffer = 1
let g:ctrlp_show_hidden = 1
let g:ctrlp_use_caching = 0
let g:ctrlp_match_window = 'order:ttb,max:20'
let g:ctrlp_custom_ignore = '*/cassettes/*'
let g:ctrlp_switch_buffer = 'et' " If a file is already open, open it again in a new pane instead of switching to the existing pane

" source plugins and mappings
:so ~/.vim/plugins/*.vim
:so ~/.mappings.vim
:cmapclear

" required (cont.)
syntax enable
filetype plugin indent on

" enable matchit script (match opening/closing tags with %)
packadd! matchit

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
set hls
set statusline=%f%m
set splitbelow
set splitright
set guicursor+=n-v-c:blinkon0 " disable cursor blinking
set tags=./tags;              " source ctags tags file, starting in current directory and traversing up (;) until found
set stl+=%{ConflictedVersion()} " display the version name of each split (upstream/working/local) in the vim statusbar (vim-conflicted)

" Setup crosshairs
hi CursorLine   cterm=NONE ctermbg=232
set cursorline!

" vim-indent-guides custom color scheme
set ts=4 sw=4 et
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1

" automatically reload vimrc when it's saved
" au BufWritePost .vimrc so ~/.vimrc

" kill trailing whitespace
autocmd BufWritePre {*.rb,*.js,*.coffee,*.html,*.sass,*.scss,*.haml} :%s/\s\+$//e

" ignore these directories/files (for ctrl-p plugin)
set wildignore+=*/cassettes/*,*/tmp/*,*/log/*,*/artifacts/*,*/vendor/*,*/vagrant/*,*/public/*,*/doc/*,*/mock/*,*.sass-cache/*,*.so,*.swp,*.zip

" Use `ag` instead of `grep` because it is so much faster
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --ignore-dir=spec/cassettes --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0

  " Use ag instead of ack
  let g:ackprg = 'ag --vimgrep --ignore-dir=spec/cassettes'
endif
