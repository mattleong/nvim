call plug#begin('~/.vim/plugged')

Plug 'sheerun/vim-polyglot'

Plug 'https://github.com/preservim/nerdtree.git'
Plug 'xuyuanp/nerdtree-git-plugin'

Plug 'ryanoasis/vim-devicons'

Plug 'wadackel/vim-dogrun'

Plug 'itchyny/lightline.vim'

" Plug 'vim-airline/vim-airline'
" Plug 'vim-airline/vim-airline-themes'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

Plug 'tpope/vim-fugitive'

Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()
