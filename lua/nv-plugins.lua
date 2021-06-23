local packer = require("packer")
local use = packer.use

packer.startup(
	function()
		use "wbthomason/packer.nvim"

		-- lang stuff
		use "nvim-treesitter/nvim-treesitter"

		-- theme stuff
		-- use "wadackel/vim-dogrun"
		use {
			"wadackel/vim-dogrun",
			config = function()
				vim.cmd('color dogrun')
				vim.cmd('highlight Normal guibg=none')
			end,
		}
		use "itchyny/lightline.vim"

		-- floating terminal
		use "voldikss/vim-floaterm"

		use "mhinz/vim-startify"

		-- file management
		use "junegunn/fzf"
		use "junegunn/fzf.vim"

		-- git
		use "tpope/vim-fugitive"
		use "tpope/vim-rhubarb"

		-- autocomplete/ide
		use {"neoclide/coc.nvim", branch = "release"}

		--        use "akinsho/nvim-bufferline.lua"

		--        use "kyazdani42/nvim-web-devicons"
		--        use "nvim-telescope/telescope.nvim"
		--        use "nvim-telescope/telescope-media-files.nvim"
		--        use "nvim-lua/popup.nvim"

		-- misc
		--        use "tweekmonster/startuptime.vim"
		--        use "folke/which-key.nvim"
--		use {"lukas-reineke/indent-blankline.nvim", branch = "lua"}
	end
)
