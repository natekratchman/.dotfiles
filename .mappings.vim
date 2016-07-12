let mapleader = ","

inoremap <c-c> <esc>
cnoremap <esc> <c-c>
vnoremap <esc> <c-c>

nnoremap <space> :nohls<cr>
nnoremap <BS> <nop>
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

" toggle cursor highlighting
nnoremap <leader>h :set cursorline! cursorcolumn!<cr>

" fun with registers
noremap <leader>y "ny
nnoremap <leader>yy "nyy
noremap <leader>p "np
vnoremap <leader><BS> "_d

" open .vimrc file in new tab (think <D-,> to open Preferences, but with Shift)
map <D-<> :tabedit ~/.vimrc<CR>

" reload .vimrc
map <leader>rv  :source ~/.vimrc<CR>

" auto-indent entire file
nmap <leader>= gg=G``

" fast scrolling
nnoremap <C-e>  3<C-e>
nnoremap <C-y>  3<C-y>

" open directory
map \ :NERDTreeToggle<CR>
" open directory at current file (nerdtree)
map \| :NERDTreeFind<CR>

" toggle comment (tcomment_vim)
nmap <leader>/ gcc

" git blame
map <leader>g :Gblame<CR>

" toggle comment
map <leader>/ <plug>NERDCommenterToggle

" mimic bash behavior for <C-A> in command mode
cmap <C-a> <C-b>

" Copy current file path to system clipboard
map <leader>C :let @* = expand("%").":".line(".")<CR>:echo "Copied: ".expand("%").":".line(".")<CR>
map <silent> <D-C> :let @* = expand("%")<CR>:echo "Copied: ".expand("%")<CR>
