local cmd = vim.cmd
local opt = vim.opt
local indent = 4

cmd [[
	syntax enable
	filetype plugin indent on
	autocmd BufWritePre * :%s/\s\+$//e
]]

-- misc
opt.hidden = true
opt.encoding = 'utf-8'
opt.backspace = 'eol,start,indent'
opt.clipboard = 'unnamedplus'
opt.matchpairs = {'(:)','{:}','[:]','<:>'}

-- indention
opt.autoindent = true
opt.smartindent = true

-- tabs
opt.tabstop = indent
opt.softtabstop = indent
opt.shiftwidth = indent

-- -- search
opt.wildmenu = true
opt.ignorecase = true
opt.smartcase = true
opt.wildignore = opt.wildignore + {'*/node_modules/*','*/wp-includes/*','*/wp-admin/*','*/vendor/*'}

-- ui
opt.number = true
opt.rnu = true
opt.cursorline = true
opt.signcolumn = 'yes'
opt.laststatus = 2
opt.scrolloff = 18
opt.wrap = false
opt.hlsearch = false
opt.list = true
opt.listchars = {
	tab = '❘-',
	trail = '·',
	extends = '»',
	precedes = '«',
	nbsp = '×'
}
opt.showmode = false
opt.lazyredraw = true
opt.mouse = 'a'

-- backups
opt.swapfile = false
opt.backup = false
opt.writebackup = false

-- autocomplete
opt.completeopt = {'menuone','preview','noinsert','noselect'}
opt.shortmess = opt.shortmess + 'c'

-- perfomance
opt.updatetime = 100
opt.timeoutlen = 500
opt.redrawtime = 1500
opt.ttimeoutlen = 10

 -- theme
opt.termguicolors = true
