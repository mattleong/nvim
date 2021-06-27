local galaxy = require('galaxyline');
local gls = galaxy.section
local vcs = require('galaxyline.provider_vcs')
local diag = require('galaxyline.provider_diagnostic')
local condition = require 'galaxyline.condition'
local fileinfo = require('galaxyline.provider_fileinfo')
local utils = require('nv-utils');

local colors = {
	brown = '#a9323d',
	aqua = '#5b9c9c',
	blue = '#5d8fac',
	darkBlue = '#557486',
	purple = '#6f78be',
	lightPurple = '#959acb',
	red = '#c2616b',
	beige = '#686765',
	yellow = '#8e8a6f',
	orange = '#c59f96',
	darkOrange = '#79564f',
	pink = '#9e619e',
	salmon = '#ab57ab',
	green = '#63976f',
	lightGreen = '#5aa46c',
	white = '#9ea3c0',
	bg = '#111219',
	matteBlue = '#545c8c',
}

local icons = {
	rounded_left_filled = '',
	rounded_right_filled = '',
	arrow_left_filled = '', -- e0b2
	arrow_right_filled = '', -- e0b0
	arrow_left = '', -- e0b3
	arrow_right = '', -- e0b1
	ghost = '👻',
}

local get_formatted_bracket = function(type)
	local bracket = icons.brackets[type]
	if (type == 'left') then
		bracket = '' .. bracket
	end
	return bracket
end

-- @TODO use this for brackets, duh
local DiffBracketProvider = function(type, diff_type)
	return function()
		local result = nil
		local bracket = icons[type]

		if (diff_type == 'add') then
			result = vcs.diff_add()
		elseif (diff_type == 'modified') then
			result = vcs.diff_modified()
		elseif (diff_type == 'remove') then
			result = vcs.diff_remove()
		end

		if (result ~= nil and bracket) then
			return bracket
		end

		return ''
	end
end



local get_mode = function()
	local mode_colors = {
		[110] = { 'NORMAL', colors.purple, },
		[105] = { 'INSERT', colors.blue, },
		[99] = { 'COMMAND', colors.orange, },
		[116] = { 'TERMINAL', colors.blue, },
		[118] = { 'VISUAL', colors.pink, },
		[22] = { 'V-BLOCK', colors.pink, },
		[86] = { 'V-LINE', colors.pink, },
		[82] = { 'REPLACE', colors.red, },
		[115] = { 'SELECT', colors.red, },
		[83] = { 'S-LINE', colors.red, },
	}

	local mode_data = mode_colors[vim.fn.mode():byte()]
	if mode_data ~= nil then
		return mode_data
	end
end

local function split(str, sep)
	local res = {}
	local n = 1
	for w in str:gmatch('([^' .. sep .. ']*)') do
		res[n] = res[n] or w -- only set once (so the blank after a string is ignored)
		if w == '' then
			n = n + 1
		end -- step forwards on a blank but not a string
	end
	return res
end

local check_width_and_git = function()
	return condition.hide_in_width() and condition.check_git_workspace() and condition.buffer_not_empty()
end

local is_file = function()
	return vim.bo.buftype ~= 'nofile'
end

local FilePathShortProvider = function()
	local fp = vim.fn.fnamemodify(vim.fn.expand '%', ':~:.:h')
	local tbl = split(fp, '/')
	local len = #tbl

	if len > 2 and not len == 3 and not tbl[0] == '~' then
		return '…/' .. table.concat(tbl, '/', len - 1) .. '/'
	else
		return fp .. '/'
	end
end

local LineColumnProvider = function()
	local line_column = fileinfo.line_column()
	line_column = line_column:gsub("%s+", "")
	return ' ' .. line_column
end

local PercentProvider = function()
	local line_column = fileinfo.current_line_percent()
	line_column = line_column:gsub("%s+", "")
	return '≡' .. line_column
end

local highlight = function(group, bg, fg, gui)
	vim.api.nvim_command(string.format('hi %s guibg=%s guifg=%s gui=%s', group, bg, fg, gui))
	vim.api.nvim_command(string.format('hi %sInv guibg=%s guifg=%s gui=%s', group, fg, bg, gui))
end

galaxy.short_line_list = { 'coc-explorer', 'packer' }

gls.left = {
	{
		Ghost = {
			provider = {
				function() return '  ' .. icons.ghost end,
			},
			highlight = 'GalaxyViMode',
		},
	},
	{
		ViMode = {
			provider = function()
				local label, mode_color = unpack(get_mode())

				highlight('GalaxyViMode', mode_color, colors.bg, 'bold')
				highlight('GalaxyViModeInv', colors.bg, mode_color, 'bold')
				highlight('GalaxyViModeNested', colors.lightPurple, mode_color, 'bold')

				return '  ' .. label .. ' '
			end,
			highlight = { colors.bg, colors.bg, 'bold' },
			separator = icons.arrow_right_filled,
			separator_highlight = 'GalaxyViModeNested',
		},
	},
	{
		GitRoot = {
			provider = utils.get_git_root,
			condition = condition.buffer_not_empty,
			icon = '  ',
			highlight = { colors.bg, colors.lightPurple },
			separator = icons.arrow_right .. ' ',
			separator_highlight = { colors.bg, colors.lightPurple }
		},
	},
	{
		FileIcon = {
			provider = 'FileIcon',
			condition = condition.buffer_not_empty,
			highlight = {
				colors.bg,
				colors.lightPurple,
			},
		},
	},
	{
		FilePath = {
			provider = FilePathShortProvider,
			condition = condition.buffer_not_empty,
			highlight = { colors.bg, colors.lightPurple },
		},
	},
	{
		FileName = {
			provider = 'FileName',
			condition = condition.buffer_not_empty,
			highlight = { colors.bg, colors.lightPurple },
			separator = icons.arrow_right_filled,
			separator_highlight = { colors.lightPurple, colors.bg }
		},
	},
	{
		Whitespace = {
			provider = function() return ' ' end,
			highlight = { colors.bg, colors.bg },
		}
	},
	{
		GitIcon = {
			provider = function() return '  ' end,
			condition = condition.check_git_workspace,
			highlight = { colors.pink, colors.bg },
		}
	},
	{
		GitBranch = {
			provider = function()
				local vcs = require('galaxyline.provider_vcs')
				local branch_name = vcs.get_git_branch()
				if (not branch_name) then
					return ''
				end
				if (string.len(branch_name) > 28) then
					return string.sub(branch_name, 1, 25).."..."
				end
				return branch_name .. " "
			end,
			condition = condition.check_git_workspace,
			highlight = { colors.white, colors.bg },
		}
	},
	{
		DiffAddLeftBracket = {
			provider = DiffBracketProvider('arrow_right_filled', 'add'),
			condition = check_width_and_git,
			highlight = { colors.bg, colors.green },
		}
	},
	{
		DiffAdd = {
			provider = 'DiffAdd',
			icon = '   ',
			condition = check_width_and_git,
			highlight = { colors.bg, colors.green },
		},
	},
	{
		DiffAddRightBracket = {
			provider = DiffBracketProvider('arrow_right_filled', 'add'),
			condition = check_width_and_git,
			highlight = { colors.green, colors.bg },
		}
	},
	{
		DiffModifiedLeftBracket = {
			provider = DiffBracketProvider('arrow_right_filled', 'modified'),
			condition = check_width_and_git,
			highlight = { colors.bg, colors.orange },
		}
	},
	{
		DiffModified = {
			provider = 'DiffModified',
			condition = check_width_and_git,
			icon = '   ',
			highlight = { colors.bg, colors.orange }, -- test
		},
	},
	{
		DiffModifiedRightBracket = {
			provider = DiffBracketProvider('arrow_right_filled', 'modified'),
			condition = check_width_and_git,
			highlight = { colors.orange, colors.bg },
		}
	},
	{
		DiffRemoveLeftBracket = {
			provider = DiffBracketProvider('arrow_right_filled', 'remove'),
			condition = check_width_and_git,
			highlight = { colors.bg, colors.red },
		}
	},
	{
		DiffRemove = {
			provider = 'DiffRemove',
			condition = check_width_and_git,
			icon = '   ',
			highlight = { colors.bg, colors.red },
		},
	},
	{
		DiffRemoveRightBracket = {
			provider = DiffBracketProvider('arrow_right_filled', 'remove'),
			condition = check_width_and_git,
			highlight = { colors.red, colors.bg },
		}
	},
}

local DiagnosticProvider = function(type, diag_type)
	return function()
		local result = nil
		local icon = icons[type]
		if (diag_type == 'warn') then
			result = diag.get_diagnostic_warn()
		end

		if (result ~= nil) then
			return ''
		end

		return result
	end
end

gls.right = {
	{
		DiagnosticInfo = {
			provider = 'DiagnosticInfo',
			icon = '  ',
			highlight = { colors.blue, colors.bg },
			condition = check_width_and_git,
		}
	},
	{
		Whitespace = {
			provider = function() return ' ' end,
		}
	},
	{
		DiagnosticWarn = {
			provider = 'DiagnosticWarn',
			icon = '  ',
			highlight = { colors.orange, colors.bg },
			condition = check_width_and_git,
		}
	},
	{
		Whitespace = {
			provider = function() return ' ' end,
		}
	},
	{
		DiagnosticError = {
			provider = 'DiagnosticError',
			icon = '  ',
			highlight = { colors.red, colors.bg },
			condition = check_width_and_git,
		}
	},
	{
		LineColumn = {
			provider = {
				LineColumnProvider,
				function() return ' ' end,
			},
			highlight = 'GalaxyViMode',
			separator = icons.arrow_left_filled,
			separator_highlight = 'GalaxyViModeInv',
		}
	},
	{
		PerCent = {
			provider = {
				PercentProvider,
				function() return ' ' end,
			},
			highlight = 'GalaxyViMode',
			separator = icons.arrow_left .. ' ',
			separator_highlight = 'GalaxyViMode',
		},
	},
}

gls.short_line_left = {
	{
		FileIconShort = {
			provider = {
				function() return '  ' end,
				'FileIcon',
			},
			condition = condition.buffer_not_empty,
			highlight = {
				require('galaxyline.provider_fileinfo').get_file_icon,
				colors.bg,
			},
		},
	},
	{
		FilePathShort = {
			provider = FilePathShortProvider,
			condition = function()
				return is_file() and check_width_and_git()
			end,
			highlight = { colors.white, colors.bg },
		},
	},
	{
		FileNameShort = {
			provider = 'FileName',
			condition = condition.buffer_not_empty,
			highlight = { colors.white, colors.bg },
		},
	},
	{
		GitRootShort = {
			provider = utils.get_git_root,
			condition = condition.buffer_not_empty,
			icon = ' ',
			highlight = { colors.white, colors.bg },
		},
	},
}

