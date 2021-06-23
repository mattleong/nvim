local utils = require('nv-utils')

utils.map('n', '<C-l>', ':FloatermToggle<CR>', { noremap = true })
utils.map('t', '<C-l>', [[<C-\><C-n>]], { noremap = true })
