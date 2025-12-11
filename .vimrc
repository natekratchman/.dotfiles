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
" Plugin 'Valloric/YouCompleteMe' " auto-completion (disabled - use ALE for completion instead)
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
Plugin 'dense-analysis/ale' " Asynchronous Lint Engine provides linting (e.g. Prettier) and auto-completion

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

" YCM settings (disabled with plugin)
" let g:ycm_auto_hover = '' " Disable YCM showing documentation in a popup at the cursor location after a short delay (https://github.com/ycm-core/YouCompleteMe#the-gycm_auto_hover-option)
" let g:ycm_server_python_interpreter = '/opt/homebrew/bin/python3'

" source plugins and mappings
:so ~/.vim/plugins/*.vim

let mapleader = ","

inoremap <c-c> <esc>
cnoremap <esc> <c-c>
vnoremap <esc> <c-c>

nnoremap <space> :nohls<cr>
nnoremap <BS> x
nnoremap <CR> i<CR><esc>

" trigger macro in register q
nnoremap <leader>2 @q

" essential navigation
nnoremap <C-h> :tabp<CR>
nnoremap <C-l> :tabn<CR>
noremap H ^
noremap L $
vnoremap L $h

" additional navigation
inoremap <C-h> <left>
inoremap <C-l> <right>
cnoremap <C-h> <left>
cnoremap <C-j> <down>
cnoremap <C-k> <up>
cnoremap <C-l> <right>

" camel-wise motions (CamelCaseMotion)
map <silent> <leader>w <Plug>CamelCaseMotion_w
map <silent> <leader>b <Plug>CamelCaseMotion_b
map <silent> <leader>e <Plug>CamelCaseMotion_e

" auto 'text expand' shortcuts
inoremap <c-b> binding.pry<esc>
inoremap <c-n> &nbsp;<esc>
vnoremap <c-n> s&nbsp;<esc>
inoremap <c-p> puts "#{self.class}##{__method__}"<esc>

" toggle cursor highlighting
nnoremap <leader>h :set cursorline!<cr>

" fun with registers
noremap <leader>y "ny
nnoremap <leader>yy "nyy
noremap <leader>p "np
vnoremap <leader><BS> "_d

" auto-indent entire file
nmap <leader>= gg=G``

" fast scrolling
nnoremap <C-e>  3<C-e>
nnoremap <C-y>  3<C-y>

" open directory (nerdtree)
map \ :NERDTreeToggle<CR>
" ...at current file
map \| :NERDTreeFind<CR>

" git blame (tpope/vim-fugitive)
map <leader>g :Gblame<CR>

" ALE
map <leader>d :ALEGoToDefinition<CR>
map <leader>r :ALEFindReferences<CR>

" toggle comment
map <leader>/ <plug>NERDCommenterToggle

" mimic bash behavior for <C-A> in command mode
cmap <C-a> <C-b>

" Copy current file path to system clipboard
map <leader>C :let @* = expand("%").":".line(".")<CR>:echo "Copied: ".expand("%").":".line(".")<CR>
map <leader>c :let @* = expand("%")<CR>:echo "Copied: ".expand("%")<CR>

" Plugins
" .vim/plugins/story_id.vim
autocmd FileType gitcommit nnoremap <leader>i :InsertStoryId<CR>
" .vim/plugins/promote_to_let.vim
nnoremap <leader>l :PromoteToLet<CR>
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
set hlsearch

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

" ALE config
let g:ale_fixers = { '*': ['prettier', 'remove_trailing_lines', 'trim_whitespace'] }
let g:ale_pattern_options = { '.*\.sql$': { 'ale_fixers': [] } }
let g:ale_fix_on_save = 1
let g:ale_set_balloons = 0
set noballooneval
set balloonexpr=
