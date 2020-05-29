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
map <C-l> :bn<cr>

" FZF
nmap <C-p> :GFiles<CR>
nmap <C-k> :Buffers<CR>
nmap <leader>f :Ag<space>

"COC
" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" tab / shift + tab
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" use <tab> for trigger completion and navigate to next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()


let g:lightline = {
  \ 'colorscheme': 'dogrun',
  \ 'active': {
  \   'left': [ [ 'mode', 'paste' ],
  \             [ 'gitbranch', 'readonly', 'filename', 'modified'] ],
  \   'right': [['lineinfo'], ['percent'], ['cocstatus', 'fileencoding', 'filetype']]
  \ },
  \ 'component_function': {
  \   'gitbranch': 'FugitiveHead',
  \   'cocstatus': 'coc#status'
  \ },
  \ }

" Use auocmd to force lightline update.
autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()

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

