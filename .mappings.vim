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

" toggle cursor highlighting
nnoremap <leader>h :set cursorline! cursorcolumn!<cr>

" fun with registers
noremap <leader>y "ny
nnoremap <leader>yy "nyy
noremap <leader>p "np
vnoremap <leader><BS> "_d

" source (reload) current file
map <leader>rv :source <C-r>%<CR>

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

" toggle comment
map <leader>/ <plug>NERDCommenterToggle

" mimic bash behavior for <C-A> in command mode
cmap <C-a> <C-b>

" Copy current file path to system clipboard
map <leader>C :let @* = expand("%").":".line(".")<CR>:echo "Copied: ".expand("%").":".line(".")<CR>
map <leader>c :let @* = expand("%")<CR>:echo "Copied: ".expand("%")<CR>

" See .vim/plugins/story_id.vim
autocmd FileType gitcommit nnoremap <leader>i :Sid<CR>
