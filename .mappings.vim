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
nnoremap <leader>qq ZQ

" duplication
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

" tab navigation
nnoremap <C-h> :tabp<CR>
nnoremap <C-l> :tabn<CR>
nnoremap <leader>x :tabc<CR>
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

