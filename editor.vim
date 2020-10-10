filetype plugin indent on

" Remove trailing whitespaces
autocmd BufWritePre * :%s/\s\+$//e

" Update files written to outside of vim
set autoread

" remember info about open buffers on close
set viminfo^=%

" Encodings
set encoding=utf-8

" Line numbers
set number

" Relative line numbers
set rnu

" Indentation
set autoindent
set smartindent

" Tabs
set noexpandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set backspace=eol,start,indent
set laststatus=2

" show cursorline
set cursorline

" disabled for lightline
set noshowmode

" Show whitespace
set list listchars=tab:❘-,trail:·,extends:»,precedes:«,nbsp:×

" Ignore files
set wildignore+=*/node_modules/*,*.scssc,*/wp-includes/*,*/wp-admin/*,*/vendor/*

" Don't wrap text
set nowrap

" highlight all search matches after search is complete
set nohlsearch

" Command-line completion in an enhanced mode
set wildmenu

" ignore case when searching
set ignorecase

" override ignorecase if the search pattern contains upper case characters
set smartcase

"yank to os clipboard
set clipboard=unnamedplus

"UI
" set mouse=a

" do all work in memory, no swap file
set ruler
set hidden
set history=1000
set noswapfile
"
" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" default 1000
set timeoutlen=500

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
set signcolumn=number

