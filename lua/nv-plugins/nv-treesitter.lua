require"nvim-treesitter.configs".setup {
	ensure_installed = {
		"typescript",
		"javascript",
		"tsx",
		"html",
		"css",
		"bash",
		"lua",
		"json",
		"python",
		"php",
		"scss"
	},
	highlight = {
		enable = true,
		indent = { enable = true },
	},
};
