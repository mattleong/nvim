source ~/.config/nvim/plugin.vim
source ~/.config/nvim/editor.vim

" Remove trailing whitespaces
autocmd BufWritePre * :%s/\s\+$//e

" Remap leader
let mapleader = " "

" NAVIGATION
set cursorline
inoremap jj <ESC>

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
autocmd BufReadPost *
\ if line("'\"") >= 1 && line("'\"") <= line("$") |
\   exe "normal! g`\"" |
\ endif

augroup END

" first non-blank space char
map 0 ^
" close buffer
map <C-x> :bd<cr>
" buffer control
map <C-j> :bp<cr>
map <C-k> :bn<cr>

" FZF
nmap <C-p> :GFiles<CR>
nmap <C-l> :Buffers<CR>
nmap <leader>f :Ag<space>

"COC
nmap <leader>gd <Plug>(coc-definition)
nmap <leader>gr <Plug>(coc-references)

" use <tab> for trigger completion and navigate to next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

" vim-js
let g:javascript_plugin_ngdoc = 1

" Gitgutter

" NERDTree
let NERDTreeShowHidden = 1

"Toggle on CTRL-n
map <C-n> :NERDTreeToggle<CR>

" Theme
set t_Co=256
if has("termguicolors")     " set true colors
    set t_8f=\[[38;2;%lu;%lu;%lum
    set t_8b=\[[48;2;%lu;%lu;%lum
    set termguicolors
endif

color dogrun

let g:lightline = {
  \ 'colorscheme': 'dogrun',
  \ 'active': {
  \   'left': [ [ 'mode', 'paste' ],
  \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
  \ },
  \ 'component_function': {
  \   'gitbranch': 'FugitiveHead'
  \ },
\ }

hi Normal guifg=NONE guibg=NONE ctermbg=none



" Airline
" let g:airline_theme='darkscene'
" let g:airline_extensions = ['coc']
" let g:airline_powerline_fonts = 1
"let g:airline#extensions#tabline#enabled = 1

" DT Session
map <leader>dt :mks! ~/.config/nvim/sessions/dt.vim<CR>

" Escape terminal
tnoremap <leader><Esc> <C-\><C-n>

