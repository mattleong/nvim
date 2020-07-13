call plug#begin('~/.vim/plugged')

Plug 'sheerun/vim-polyglot'

Plug 'wadackel/vim-dogrun'

Plug 'itchyny/lightline.vim'

Plug 'voldikss/vim-floaterm'

Plug 'mhinz/vim-startify'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

Plug 'liuchengxu/vim-which-key', { 'on': ['WhichKey', 'WhichKey!'] }

Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'

Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()
