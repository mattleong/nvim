call plug#begin('~/.vim/plugged')

Plug 'sheerun/vim-polyglot'
Plug 'https://github.com/preservim/nerdtree.git'
Plug 'aswathkk/darkscene.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
" Plug 'junegunn/fzf.vim'

Plug 'Shougo/denite.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'ryanoasis/vim-devicons'
" Plug 'ervandew/supertab'

call plug#end()
