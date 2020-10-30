source ~/.config/nvim/plugin.vim
source ~/.config/nvim/editor.vim

" Remap leader
let mapleader = "\<Space>"
let g:maplocalleader = ','

" NAVIGATION
"set cursorcolumn
inoremap jj <ESC>

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

function! s:getchar()
  let c = getchar()
  if c =~ '^\d\+$'
    let c = nr2char(c)
  endif
  return c
endfunction

" Custom quit session prompt
function! QuitSession()
  echo 'Are you sure you want to quit session? y/n'
  let c = s:getchar()
  if c == 'y'
    SClose
  endif
endfunction

nnoremap <C-q> :call QuitSession()<cr>

let g:startify_session_before_save = [
    \ 'echo "Cleaning up before saving.."',
	\ 'silent! :Vista!',
    \ 'silent! call MaybeCloseCocExplorer()',
    \ ]

let g:ascii = [
      \ '        __',
      \ '.--.--.|__|.--------.',
      \ '|  |  ||  ||        |',
      \ ' \___/ |__||__|__|__|',
      \ ''
      \]
let g:startify_custom_header = g:ascii + startify#fortune#boxed()
let g:startify_change_to_vcs_root = 1
let g:startify_session_persistence = 1
let g:startify_fortune_use_unicode = 1

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

"Vista
let g:vista_icon_indent = ["╰─▸ ", "├─▸ "]
" Ensure you have installed some decent font to show these pretty symbols, then you can enable icon for the kind.
let g:vista_default_executive = 'coc'
let g:vista_fzf_preview = ['right:50%']
let g:vista#renderer#enable_icon = 1

" The default icons can't be suitable for all the filetypes, you can extend it as you wish.
let g:vista#renderer#icons = {
\   "function": "\uf794",
\   "variable": "\uf71b",
\  }

" Window Management
nnoremap <leader>l :vertical res -5<CR>
nnoremap <leader>h :vertical res +5<CR>
nnoremap <leader>j :res -5<CR>
nnoremap <leader>k :res +5<CR>

"COC
" close coc explorer if open
function! MaybeCloseCocExplorer()
  let opened = CocAction('runCommand', 'explorer.getNodeInfo', 'closest') is v:null
  if opened == 0
	  :CocCommand explorer
  endif
endfunction

"coc-explorer
nnoremap <C-n> :CocCommand explorer<CR>

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gt <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> gn <Plug>(coc-rename)

" tab / shift + tab
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

autocmd CursorHold * silent call CocActionAsync('highlight')

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
  if a == 0 && m == 0 && r == 0
    return ''
  endif
  return printf('+%d ~%d -%d', a, m, r)
endfunction

function! LightlineReadonly()
  return &readonly ? '' : ''
endfunction

function! LightlineFugitive()
  if exists('*FugitiveHead')
    let branch = FugitiveHead()
    return branch !=# '' ? ' '.branch : ''
  endif
  return ''
endfunction

function! ErrorStatusDiagnostic() abort
  let info = get(b:, 'coc_diagnostic_info', {})
  if empty(info) | return '' | endif
  let msgs = []
  if get(info, 'error', 0)
    call add(msgs, printf('%d✗', info['error']))
  endif
  if get(info, 'warning', 0)
    call add(msgs, printf('%d▲', info['warning']))
  endif
  if empty(msgs)
    return ''
  endif
  return join(msgs, ' ') . get(g:, 'coc_status', '')
endfunction

function! NearestMethodOrFunction() abort
  return get(b:, 'vista_nearest_method_or_function', '')
endfunction

" By default vista.vim never run if you don't call it explicitly.
"
" If you want to show the nearest function in your statusline automatically,
" you can add the following line to your vimrc
autocmd VimEnter * call vista#RunForNearestMethodOrFunction()

let g:lightline = {
  \ 'colorscheme': 'iceberg',
  \ 'component': {
  \   'lineinfo': '%3l:%-2c%3p%%',
  \ },
  \ 'active': {
  \   'left': [[ 'mode', ],
  \             [ 'gitbranch', 'filename', 'nearestFn', 'gitstatus', 'modified' ]],
  \   'right': [[ 'lineinfo', 'filetype' ], ['coc_status'], [ 'readonly' ]],
  \ },
  \ 'inactive': {
  \   'left': [[ 'gitbranch', 'filename', 'coc_status' ]],
  \   'right': [[ 'modified', 'gitstatus',  'filetype', 'lineinfo']],
  \ },
  \ 'component_function': {
  \   'gitbranch': 'LightlineFugitive',
  \   'cocstatus': 'coc#status',
  \   'gitstatus': 'GitStatus',
  \   'readonly': 'LightlineReadonly',
  \   'nearestFn': 'NearestMethodOrFunction',
  \ },
  \ 'component_expand': {
  \   'coc_status': 'ErrorStatusDiagnostic',
  \ },
  \ 'separator': { 'left': '', 'right': '' },
  \ 'subseparator': { 'left': '', 'right': '' },
  \ }

" Use auocmd to force lightline update.
autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()

" Theme
set t_Co=256
if has("termguicolors")     " set true colors
	set termguicolors
endif

color iceberg
