source ~/.config/nvim/plugin.vim
source ~/.config/nvim/editor.vim

" whichkey
autocmd! User vim-which-key call which_key#register('<Space>', 'g:which_key_map')
let g:which_key_map =  {}

" Remap leader
let mapleader = "\<Space>"
let g:maplocalleader = ','

" NAVIGATION
set cursorline
"set cursorcolumn
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

" Startify
let g:startify_session_dir = '~/.config/nvim/sessions/'
let g:startify_lists = [
  \ { 'type': 'sessions',  'header': ['   Sessions']       },
  \ { 'type': 'files',     'header': ['   MRU']            },
  \ { 'type': 'dir',       'header': ['   Current Dir '. getcwd()] },
  \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
  \ { 'type': 'commands',  'header': ['   Commands']       },
  \ ]

let g:startify_bookmarks = [
	\ {'n': '~/.config/nvim/init.vim'},
	\ {'z': '~/.zsh/.zshrc'},
	\ ]

let g:startify_session_persistence = 1
let g:startify_change_to_vcs_root = 1
let g:startify_fortune_use_unicode = 1

map <C-n> :Lexplore <bar> :vertical resize 30 <CR>

nnoremap <C-p> :GFiles<CR>
nnoremap <C-k> :Buffers<CR>

" Escape terminal
tnoremap <C-\><C-\> <C-\><C-n>

"COC
" Use `[g` and `]g` to navigate diagnostics
map <silent> [g <Plug>(coc-diagnostic-prev)
map <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
map <silent> gd <Plug>(coc-definition)
map <silent> gt <Plug>(coc-type-definition)
map <silent> gi <Plug>(coc-implementation)
map <silent> gr <Plug>(coc-references)
map <silent> gn <Plug>(coc-rename)

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

function! GitStatus()
  let [a,m,r] = GitGutterGetHunkSummary()
  return printf('+%d ~%d -%d', a, m, r)
endfunction

let g:lightline = {
  \ 'colorscheme': 'dogrun',
  \ 'active': {
  \   'left': [ [ 'mode', 'paste' ],
  \             [ 'gitbranch', 'readonly', 'filename', 'gitdir'] ],
  \   'right': [['lineinfo'], ['percent'], ['fileencoding', 'filetype', 'cocstatus', 'modified' ]]
  \ },
  \ 'component_function': {
  \   'gitbranch': 'FugitiveHead',
  \   'cocstatus': 'coc#status',
  \   'gitdir': 'GitStatus'
  \ },
  \ }

" Use auocmd to force lightline update.
autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()

" Theme
set t_Co=256
if has("termguicolors")     " set true colors
	set termguicolors
endif

color dogrun

" allow transparency
" hi Normal     ctermbg=NONE guibg=NONE
" hi LineNr     ctermbg=NONE guibg=NONE
" hi SignColumn ctermbg=NONE guibg=NONE

" Vim Whichkey
let g:which_key_map.d = { 'name' : 'which_key_ignore' }
let g:which_key_map.h = { 'name' : 'which_key_ignore' }
let g:which_key_map.r = { 'name' : 'which_key_ignore' }
let g:which_key_map.q = 'quickfix'

" Floatterm
nnoremap <silent><leader>t :FloatermToggle<CR>
let g:which_key_map.t = 'terminal'

nnoremap <leader>sp :Rg<space>
let g:which_key_map.s = {
	\ 'name' : '+search',
	\ 'p' : 'project grep',
	\ }

let g:which_key_map.e = {
	\ 'name' : 'reload',
	\ 'r' : [':e!', 'reload nvim'],
	\ 'u' : [':source ~/.config/nvim/init.vim', 'source nvim'],
	\ }

let g:which_key_map.f = {
	\ 'name' : '+file',
	\ 's' : [':w', 'save'],
	\ 'x' : [':wqa!', 'save + close all'],
	\ 'q' : [':q', 'quit'],
	\ }

let g:which_key_map.w = {
      \ 'name' : '+window' ,
      \ 'J' : [':resize +5'  , 'expand window below']   ,
      \ 'L' : ['<C-W>5>'    , 'expand window right']   ,
      \ 'K' : [':resize -5'  , 'expand window up']      ,
      \ }
nnoremap <silent> <leader> :<c-u>WhichKey '<Space>'<CR>
vnoremap <silent> <leader> :<c-u>WhichKeyVisual '<Space>'<CR>

let g:which_key_hspace = 1
let g:which_key_use_floating_win = 1
let g:which_key_floating_relative_win = 1
let g:which_key_floating_opts = { 'width': '100', 'row': '1' }
let g:which_key_sort_horizontal = 1
