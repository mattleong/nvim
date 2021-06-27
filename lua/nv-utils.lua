local M = { }

local scopes = {o = vim.o, b = vim.bo, w = vim.wo}

local function get_basename(file)
	return file:match '^.+/(.+)$'
end

function M.map(mode, lhs, rhs, opts)
	local options = {noremap = true}
	if opts then options = vim.tbl_extend('force', options, opts) end
	vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

function M.get_git_root()
	local git_dir = require('galaxyline.provider_vcs').get_git_dir()
	if not git_dir then
		return 'not a git dir '
	end

	local git_root = git_dir:gsub('/.git/?$', '')
	return get_basename(git_root) .. ' '
end

return M
