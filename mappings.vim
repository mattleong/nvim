source ~/.config/nvim/mappings/coc.vim
source ~/.config/nvim/mappings/lightline.vim
source ~/.config/nvim/mappings/startify.vim
source ~/.config/nvim/mappings/floatterm.vim
source ~/.config/nvim/mappings/treesitter.vim

" Remap leader
let mapleader = "\<Space>"
let g:maplocalleader = ','

" Search Project
nnoremap <C-s> :Rg<space>
" Open git files
nnoremap <C-k> :Buffers<CR>
" Open buffers
nnoremap <C-j> :GFiles<CR>
" Terminal
nnoremap <C-l> :FloatermToggle<CR>
" Escape terminal
tnoremap <C-l> <C-\><C-n>
tnoremap <C-w>l <C-\><C-n> :FloatermNext <CR>
tnoremap <C-w>h <C-\><C-n> :FloatermPrev <CR>
tnoremap <C-n> <C-\><C-n> :FloatermNew <CR>

" Window Management
nnoremap <leader>t :tabnew <CR>
nnoremap <leader>h :tabp <CR>
nnoremap <leader>l :tabn <CR>
