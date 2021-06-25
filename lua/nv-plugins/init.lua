local packer = require("packer")
local use = packer.use
local cmd = vim.cmd

packer.startup(
	function()
		use "wbthomason/packer.nvim"

		-- lang stuff
		use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

		-- theme stuff
		use {
		  'glepnir/galaxyline.nvim',
			branch = 'main',
			-- your statusline
			config = function()
				require 'lua.nv-statusline'
			end,
			-- some optional icons
			requires = {'kyazdani42/nvim-web-devicons', opt = true},
		}

		use {
			"wadackel/vim-dogrun",
			config = function()
				vim.cmd 'color dogrun'
				vim.cmd 'highlight Normal guibg=none'
			end,
		}

		-- floating terminal
		use {
			"voldikss/vim-floaterm",
			opt = true,
			cmd = {'FloatermToggle', 'FloatermNew', 'FloatermSend'},
			config = function()
				vim.cmd 'hi FloatermNC guibg=gray'
			end,
		}

		-- file management
		use {
			"junegunn/fzf",
			run = function()
				vim.fn['fzf#install']()
			end
		}
		use "junegunn/fzf.vim"

		-- git
		use "tpope/vim-fugitive"
		use "tpope/vim-rhubarb"
		use {
			'lewis6991/gitsigns.nvim',
			requires = {
				'nvim-lua/plenary.nvim'
			},
			config = function()
				require('gitsigns').setup()
			end
		}

		-- autocomplete/ide
		use {"neoclide/coc.nvim", branch = "release"}

	end
)

require("nv-plugins.nv-treesitter")
require("nv-plugins.nv-floatterm")
cmd 'source ~/.config/nvim/lua/nv-plugins/coc.vim'
