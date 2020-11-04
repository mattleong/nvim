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
