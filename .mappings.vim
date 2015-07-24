nnoremap <space> <nop>
nnoremap <BS> daw
let mapleader = " "

nnoremap <leader>a :Ag<space>

" more fun than :w
nnoremap WW :w<CR>

" move/copy
nnoremap <leader>m V:m
nnoremap <leader>t V:t
vnoremap <leader>m :m
vnoremap <leader>t :t
nnoremap <leader>d yyp
vnoremap <leader>d :t'><CR>

" window navigation/manipulation
nnoremap <leader>h <C-w>h
nnoremap <leader>j <C-w>j
nnoremap <leader>k <C-w>k
nnoremap <leader>l <C-w>l
nnoremap <leader>v :vs<CR><C-w>l
nnoremap <leader>s :sp<CR><C-w>j
nnoremap <leader>c :close<CR>

" buffer navigation
nnoremap <C-h> :bp<CR>
nnoremap <C-l> :bn<CR>
nnoremap <leader>w :bd<CR>
nnoremap <leader>b :CtrlPBuffer<CR>

" shift jumping
nnoremap H ^
nnoremap L $
vnoremap L $h
nnoremap J 20jzz
nnoremap K 20kzz

" ctrl navigation in command/insert modes
inoremap <C-h> <left>
inoremap <C-l> <right>
cnoremap <C-h> <left>
cnoremap <C-j> <down>
cnoremap <C-k> <up>
cnoremap <C-l> <right>

" destructive (bash) shortcuts
noremap <C-u> d0
noremap <C-k> d$
noremap <C-d> <del>
noremap <C-j> J

" no arrow keys! Muahahahaha!
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
" ...actually, <up> launches ex history
nnoremap <up> :<up>

