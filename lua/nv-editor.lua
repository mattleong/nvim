local utils = require('nv-utils')
local cmd = vim.cmd
local indent = 4

cmd 'syntax enable'
cmd 'filetype plugin indent on'

cmd [[
	autocmd BufWritePre * :%s/\s\+$//e
]]

utils.opt('o', 'hidden', true)
utils.opt('w', 'number', true)
utils.opt('w', 'rnu', true)
utils.opt('o', 'encoding', 'utf-8')
utils.opt('b', 'autoindent', true)
utils.opt('b', 'smartindent', true)
utils.opt('b', 'tabstop', indent)
utils.opt('b', 'softtabstop', indent)
utils.opt('b', 'shiftwidth', indent)
utils.opt('o', 'backspace', 'eol,start,indent')
utils.opt('o', 'laststatus', 2)
utils.opt('o', 'cursorline', true)
utils.opt('o', 'signcolumn', 'yes')
utils.opt('o', 'scrolloff', 18)
utils.opt('o', 'completeopt', 'menuone,noinsert,noselect')
utils.opt('o', 'wildmenu', true)
utils.opt('o', 'ignorecase', true)
utils.opt('o', 'smartcase', true)
utils.opt('o', 'clipboard', 'unnamedplus')
utils.opt('o', 'timeoutlen', 500)

cmd [[
	set nowrap
	set noswapfile
	set shortmess+=c
	set list listchars=tab:❘-,trail:·,extends:»,precedes:«,nbsp:×
]]

-- perfomance
utils.opt('o', 'updatetime', 100)

-- theme
utils.opt('o', 't_Co', '256')
utils.opt('o', 'termguicolors', true)
