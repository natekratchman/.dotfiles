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
