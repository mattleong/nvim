local utils = require('nv-utils')
local cmd = vim.cmd
local indent = 4

cmd [[
	syntax enable
	filetype plugin indent on
	autocmd BufWritePre * :%s/\s\+$//e
	set viminfo^=%
]]

-- misc
utils.opt('o', 'hidden', true)
utils.opt('o', 'encoding', 'utf-8')
utils.opt('o', 'backspace', 'eol,start,indent')
utils.opt('o', 'clipboard', 'unnamedplus')
utils.opt('o', 'matchpairs', '(:),{:},[:],<:>') -- Add HTML brackets to pair matching

-- indention
utils.opt('b', 'autoindent', true)
utils.opt('b', 'smartindent', true)

-- tabs
utils.opt('b', 'tabstop', indent)
utils.opt('b', 'softtabstop', indent)
utils.opt('b', 'shiftwidth', indent)

-- search
utils.opt('o', 'wildmenu', true)
utils.opt('o', 'ignorecase', true)
utils.opt('o', 'smartcase', true)
cmd [[ set wildignore+=*/node_modules/*,*/wp-includes/*,*/wp-admin/*,*/vendor/* ]]

-- ui
utils.opt('w', 'number', true)
utils.opt('w', 'rnu', true)
utils.opt('o', 'cursorline', true)
utils.opt('o', 'signcolumn', 'yes')
utils.opt('o', 'laststatus', 2)
utils.opt('o', 'scrolloff', 18)
utils.opt('o', 'wrap', false)
utils.opt('o', 'hlsearch', false)
utils.opt('o', 'list', true)
utils.opt('o', 'listchars', 'tab:❘-,trail:·,extends:»,precedes:«,nbsp:×')
utils.opt('o', 'showmode', false)
utils.opt('o', 'lazyredraw', true) -- Don't redraw screen while running macros
utils.opt('o', 'mouse', 'a')

-- backups
utils.opt('o', 'swapfile', false)
utils.opt('o', 'backup', false)
utils.opt('o', 'writebackup', false)

-- autocomplete
utils.opt('o', 'completeopt', 'menuone,preview,noinsert,noselect')
utils.opt('o', 'shortmess', 'filnxtToOFc') -- Don't pass messages to |ins-completion-menu|.

-- perfomance
utils.opt('o', 'updatetime', 100)
utils.opt('o', 'timeoutlen', 500)
utils.opt('o', 'redrawtime', 1500)
utils.opt("o", "ttimeoutlen", 10) -- Time out on key codes

-- theme
utils.opt('o', 't_Co', '256')
utils.opt('o', 'termguicolors', true)
