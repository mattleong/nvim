local packer = require("packer")
local use = packer.use

packer.startup(
	function()
		use "wbthomason/packer.nvim"

		-- lang stuff
		use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

		-- theme stuff
		use "itchyny/lightline.vim"
		use {
			"wadackel/vim-dogrun",
			config = function()
				vim.cmd('color dogrun')
				vim.cmd('highlight Normal guibg=none')
			end,
		}

		-- floating terminal
		use "voldikss/vim-floaterm"

		-- file management
		use {
			"junegunn/fzf",
			run = function()
				vim.fn['fzf#install'](0)
			end
		}
		use "junegunn/fzf.vim"

		-- git
		use "tpope/vim-fugitive"
		use "tpope/vim-rhubarb"

		-- autocomplete/ide
		use {"neoclide/coc.nvim", branch = "release"}
	end
)

require("nv-plugins.nv-treesitter")