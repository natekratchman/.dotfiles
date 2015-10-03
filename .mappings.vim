" general keys
nnoremap <space> <nop>
nnoremap <BS> <nop>
nnoremap <CR> i<CR><esc>
nnoremap ; :
nnoremap : ;
vnoremap ; :
vnoremap : ;
inoremap <c-c> <esc>
cnoremap <esc> <c-c>
vnoremap <esc> <c-c>
let mapleader = " "

" save/exit
nnoremap <space><space> :w<CR>
nnoremap <leader>w :w<CR>
nnoremap <leader>wq ZZ
nnoremap <leader>qq :q!<CR>

" move/copy
nnoremap <leader>m V:m
nnoremap <leader>t V:t
vnoremap <leader>m :m
vnoremap <leader>t :t
nnoremap <leader>d yyp
vnoremap <leader>d :t'><CR>

" registers
noremap <leader>y "ny
nnoremap <leader>yy "nyy
noremap <leader>p "np
vnoremap <leader><BS> "_d
nnoremap <leader>2 @q

" window navigation/manipulation
nnoremap <leader>h <C-w>h
nnoremap <leader>j <C-w>j
nnoremap <leader>k <C-w>k
nnoremap <leader>l <C-w>l
nnoremap <leader>v :vs<CR><C-w>l
nnoremap <leader>s :sp<CR><C-w>j
nnoremap <leader>c :close<CR>

" buffer navigation
nnoremap <C-h> :bp!<CR>
nnoremap <C-l> :bn!<CR>
nnoremap <leader>x :bd<CR>
nnoremap <leader>b :CtrlPBuffer<CR>

" shift jumping
noremap H ^
noremap L $
vnoremap L $h

" ctrl navigation in command/insert modes
inoremap <C-h> <left>
inoremap <C-l> <right>
cnoremap <C-h> <left>
cnoremap <C-j> <down>
cnoremap <C-k> <up>
cnoremap <C-l> <right>

" no arrow keys! Muahahahaha!
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>

"""""""""""
" PLUGINS
"""""""""""
" open nerdtree directory at current file
nnoremap \ :NERDTreeFind<CR>

" Silver Searcher
nnoremap <leader>a :Ag<space>

" switch btwn production and test code (vim-rails)
nnoremap <leader>. :A<CR>

