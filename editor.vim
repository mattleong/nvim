filetype plugin indent on

" Update files written to outside of vim
set autoread

" remember info about open buffers on close
set viminfo^=%

" Encodings
set encoding=utf-8

" Line numbers
set number

" userelative line numbers
" set rnu

" Indentation
set autoindent
set smartindent

" Tabs
set noexpandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set tabstop=4
set backspace=eol,start,indent
set laststatus=2

" disabled for lightline
set noshowmode

" Show whitespace
set list

" Ignore files
set wildignore+=*/node_modules/*,*.scssc,*/wp-includes/*,*/wp-admin/*,*/vendor/*

" Don't wrap text
set nowrap

" highlight all search matches after search is complete
set hlsearch

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
set noswapfile
set ruler
set hidden
set history=1000

