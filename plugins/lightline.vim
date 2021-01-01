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

let g:lightline = {
  \ 'colorscheme': 'dogrun',
  \ 'component': {
  \   'lineinfo': '%3l:%-2c%3p%%',
  \ },
  \ 'active': {
  \   'left': [[ 'mode', ],
  \             [ 'gitbranch', 'filename', 'gitstatus', 'modified' ]],
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
  \ },
  \ 'component_expand': {
  \   'coc_status': 'ErrorStatusDiagnostic',
  \ },
  \ 'separator': { 'left': '', 'right': '' },
  \ 'subseparator': { 'left': '', 'right': '' },
  \ }
