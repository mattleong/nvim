require("nv-mappings.nv-floatterm")

local utils = require('nv-utils')
local g = vim.g

g.mapleader = ' '

-- editor
utils.map('n', '<C-s>', ':Rg<space>', { noremap = true })
utils.map('n', '<C-k>', ':Buffers<CR>', { noremap = true })
utils.map('n', '<C-j>', ':GFiles<CR>', { noremap = true })
