call plug#begin('~/.vim/plugged')

Plug 'sheerun/vim-polyglot'

Plug 'https://github.com/preservim/nerdtree.git'
Plug 'xuyuanp/nerdtree-git-plugin'

Plug 'ryanoasis/vim-devicons'

Plug 'wadackel/vim-dogrun'

Plug 'itchyny/lightline.vim'

Plug 'voldikss/vim-floaterm'

Plug 'mhinz/vim-startify'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'yuki-ycino/fzf-preview.vim'

Plug 'liuchengxu/vim-which-key', { 'on': ['WhichKey', 'WhichKey!'] }

Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'

Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()
