source ~/.config/nvim/plugin.vim
source ~/.config/nvim/editor.vim
source ~/.config/nvim/plugins/coc.vim
source ~/.config/nvim/plugins/lightline.vim
source ~/.config/nvim/plugins/startify.vim
source ~/.config/nvim/plugins/vista.vim

" Remap leader
let mapleader = "\<Space>"
let g:maplocalleader = ','

" NAVIGATION
"set cursorcolumn
inoremap jj <ESC>

" Search Project
nnoremap <C-s> :Rg<space>
" Open git files
nnoremap <C-k> :GFiles<CR>
" Open buffers
nnoremap <C-j> :Buffers<CR>
" Buffer symbols
nnoremap <C-h> :Vista finder fzf:coc<CR>
" Terminal
nnoremap <C-l> :FloatermToggle<CR>
" Escape terminal
tnoremap <C-l> <C-\><C-n>

" Window Management
nnoremap <leader>l :vertical res -5<CR>
nnoremap <leader>h :vertical res +5<CR>
nnoremap <leader>j :res -5<CR>
nnoremap <leader>k :res +5<CR>

" Theme
set t_Co=256
if has("termguicolors")     " set true colors
	set termguicolors
endif

color dogrun
