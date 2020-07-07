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
" close buffer
map <C-x> :bd<cr>
" buffer control
map <C-j> :bp<cr>
map <C-l> :bn<cr>

" Startify
let g:startify_session_dir = '~/.config/nvim/sessions/'

nnoremap <C-p> :FzfPreviewGitFiles<CR>
nnoremap <C-k> :FzfPreviewBuffers<CR>

" why doesn't that work?
" let g:fzf_preview_filelist_postprocess_command = 'xargs -d "\n" ls -U --color' " Use exa

" Floatterm
nnoremap <silent><leader>t :FloatermToggle<CR>
"COC
" Use `[g` and `]g` to navigate diagnostics
map <silent> [g <Plug>(coc-diagnostic-prev)
map <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
map <silent> gd <Plug>(coc-definition)
map <silent> gt <Plug>(coc-type-definition)
map <silent> gi <Plug>(coc-implementation)
map <silent> gr <Plug>(coc-references)
map <leader>rn <Plug>(coc-rename)

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
  \   'right': [['lineinfo'], ['percent'], ['cocstatus', 'modified', 'fileencoding', 'filetype']]
  \ },
  \ 'component_function': {
  \   'gitbranch': 'FugitiveHead',
  \   'cocstatus': 'coc#status',
  \   'gitdir': 'GitStatus'
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
	set termguicolors
endif

color dogrun

" allow transparency
" hi Normal     ctermbg=NONE guibg=NONE
" hi LineNr     ctermbg=NONE guibg=NONE
" hi SignColumn ctermbg=NONE guibg=NONE

" DT Session
map <leader>dt :mks! ~/.config/nvim/sessions/dt.vim<CR>

" Escape terminal
tnoremap <leader><Esc> <C-\><C-n>

" Vim Whichkey
let g:which_key_map.d = { 'name' : 'which_key_ignore' }
let g:which_key_map.h = { 'name' : 'which_key_ignore' }
let g:which_key_map.r = { 'name' : 'which_key_ignore' }
let g:which_key_map.q = 'quickfix'
let g:which_key_map.t = 'terminal'

nnoremap <leader>sp :FzfPreviewProjectGrep<space>
let g:which_key_map.s = {
	\ 'name' : '+search',
	\ 'p' : 'project grep',
	\ }

let g:which_key_map.e = {
	\ 'name' : 'reload',
	\ 'r' : [':e!', 'reload nvim'],
	\ 'u' : [':source ~/.config/nvim/init.vim', 'source nvim'],
	\ }

let g:which_key_map.p = {
	\ 'name' : '+project',
	\ 'r' : ['FzfPreviewMruFiles', 'recently used'],
	\ 'w' : ['FzfPreviewMrwFiles', 'recently written'],
	\ 'd' : ['FzfPreviewDirectoryFiles', 'directory'],
	\ 'g' : ['FzfPreviewGitFiles', 'git files'],
	\ }

let g:which_key_map.g = {
	\ 'name' : '+git',
	\ 's' : ['FzfPreviewGitStatus', 'status'],
	\ 'd' : ['Git diff', 'diff'],
	\ 'b' : ['Gblame', 'blame'],
	\ 'o' : ['Gbrowse', 'open in browser'],
	\ }

let g:which_key_map.f = {
	\ 'name' : '+file',
	\ 's' : ['w', 'save'],
	\ 'x' : ['wq', 'save + close'],
	\ 'q' : ['q', 'quit'],
	\ }

let g:which_key_map.b = {
      \ 'name' : '+buffer' ,
      \ 'd' : [':bd'        , 'delete buffer']   ,
      \ 'f' : [':bfirst'    , 'first buffer']    ,
      \ 'h' : [':Startify'  , 'home buffer']     ,
      \ 'l' : [':blast'     , 'last buffer']     ,
      \ 'n' : [':bnext'     , 'next buffer']     ,
      \ 'p' : [':bprevious' , 'previous buffer'] ,
      \ '?' : [':FzfPreviewBuffers', 'preview buffers']      ,
      \ 'a' : [':FzfPreviewAllBuffers', 'preview all buffers']      ,
      \ }

let g:which_key_map.m = {
      \ 'name' : '+bookmark' ,
      \ 't' : [':CocCommand bookmark.toggle'        , 'create/delete bookmark']   ,
      \ 'a' : [':CocCommand bookmark.annotate'        , 'create annotated bookmark']   ,
      \ 'n' : [':CocCommand bookmark.next'        , 'next bookmark']   ,
      \ 'p' : [':CocCommand bookmark.prev'        , 'prev bookmark']   ,
      \ 'c' : [':CocCommand bookmark.clearForCurrentFile'        , 'clear bookmarks in file']   ,
      \ 'C' : [':CocCommand bookmark.clearForAllFiles'        , 'clear all bookmarks']   ,
      \ 'l' : [':CocList bookmark'        , 'list bookmarks']   ,
      \ }

let g:which_key_map.c = {
	\ 'name' : '+code',
	\ 'r' : ['<Plug>(coc-rename)'     , 'rename']      ,
	\ 'g' : {
		\ 'name': '+goto',
		\ 'd' : ['<Plug>(coc-definition)'     , 'definition']      ,
		\ 't' : ['<Plug>(coc-type-definition)' , 'type-definition'] ,
		\ 'i' : ['<Plug>(coc-implementation)' , 'implementation']  ,
		\ 'r' : ['<Plug>(coc-references)' , 'references']  ,
		\ },
	\ }

let g:which_key_map.w = {
      \ 'name' : '+window' ,
      \ 'w' : ['<C-W>w'     , 'other window']          ,
      \ 'd' : ['<C-W>c'     , 'delete window']         ,
      \ 's' : ['<C-W>s'     , 'split below']    ,
      \ 'v' : ['<C-W>v'     , 'split right']    ,
      \ 'h' : ['<C-W>h'     , 'window left']           ,
      \ 'j' : ['<C-W>j'     , 'window below']          ,
      \ 'l' : ['<C-W>l'     , 'window right']          ,
      \ 'k' : ['<C-W>k'     , 'window up']             ,
      \ 'H' : ['<C-W>5<'    , 'expand window left']    ,
      \ 'J' : [':resize +5'  , 'expand window below']   ,
      \ 'L' : ['<C-W>5>'    , 'expand window right']   ,
      \ 'K' : [':resize -5'  , 'expand window up']      ,
      \ '=' : ['<C-W>='     , 'balance window']        ,
      \ '?' : [':Windows'    , 'fzf-window']            ,
      \ }
nnoremap <silent> <leader> :<c-u>WhichKey '<Space>'<CR>
vnoremap <silent> <leader> :<c-u>WhichKeyVisual '<Space>'<CR>

let g:which_key_hspace = 1
let g:which_key_use_floating_win = 1
let g:which_key_floating_relative_win = 1
let g:which_key_floating_opts = { 'width': '100', 'row': '1' }
let g:which_key_sort_horizontal = 1

