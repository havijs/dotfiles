set number
set encoding=UTF-8
set clipboard+=unnamedplus
set backspace=indent,eol,start
set ignorecase
let mapleader=";"
let g:indentLine_setColors = 0


let g:indentLine_char = '┊'

map <leader>f : GFiles<CR>

map <leader>n : bn<CR>
map <leader>p : bp<CR>
map <leader>q : bd<CR>

filetype plugin indent on
" show existing tab with 4 spaces width
set tabstop=4
" when indenting with '>', use 4 spaces width
set shiftwidth=4
" On pressing tab, insert 4 spaces
set expandtab


autocmd FileType javascript setlocal shiftwidth=2 tabstop=2
autocmd FileType typescript setlocal shiftwidth=2 tabstop=2
autocmd FileType javascript setlocal shiftwidth=2 tabstop=2
autocmd FileType typescriptreact setlocal shiftwidth=2 tabstop=2
