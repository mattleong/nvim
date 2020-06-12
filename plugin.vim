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

Plug 'liuchengxu/vim-clap', { 'do': ':Clap install-binary' }

Plug 'yuki-ycino/fzf-preview.vim'

Plug 'psliwka/vim-smoothie'

Plug 'tpope/vim-fugitive'

Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()
