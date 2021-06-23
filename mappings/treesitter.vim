lua <<EOF
require"nvim-treesitter.configs".setup {
	ensure_installed = {
		"typescript",
		"javascript",
		"html",
		"css",
		"bash",
		"lua",
		"json",
		"python",
		"php",
		"scss"
	}, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
	highlight = {
		enable = true,              -- false will disable the whole extension
		use_languagetree = true
	},
};
EOF
