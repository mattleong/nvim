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
	darkBlue = '#557486',
	purple = '#5e3e5e',
	lightPurple = '#959acb',
	beige = '#686765',
	yellow = '#a8a384',
	darkOrange = '#79564f',
	pink = '#9e619e',
	salmon = '#ab57ab',
	green = '#63976f',
	lightGreen = '#5aa46c',
	white = '#9ea3c0',
	bg = '#111219',
	bluee = '#545c8c',
	matteBlue = '#494f8b',
	info = '#5d8fac',
	error = '#c2616b',
	warn = '#c59f96',
}

local icons = {
	rounded_left_filled = '',
	rounded_right_filled = '',
	arrow_left_filled = '', -- e0b2
	arrow_right_filled = '', -- e0b0
	arrow_left = '', -- e0b3
	arrow_right = '', -- e0b1
	ghost = '',
	warn = '',
	info = '',
	error = '',
}

local get_mode = function()
	local mode_colors = {
		[110] = { 'NORMAL', colors.matteBlue, colors.lightPurple },
		[105] = { 'INSERT', colors.purple, colors.pink },
		[99] = { 'COMMAND', colors.beige, colors.yellow },
		[116] = { 'TERMINAL', colors.aqua, colors.info },
		[118] = { 'VISUAL', colors.purple, colors.info, },
		[22] = { 'V-BLOCK', colors.purple, colors.info, },
		[86] = { 'V-LINE', colors.purple, colors.info, },
		[82] = { 'REPLACE', colors.brown, colors.error, },
		[115] = { 'SELECT', colors.brown, colors.error, },
		[83] = { 'S-LINE', colors.brown, colors.error, },
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

local highlight = function(group, bg, fg, gui)
	vim.api.nvim_command(string.format('hi %s guibg=%s guifg=%s gui=%s', group, bg, fg, gui))
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
	return '☰' .. line_column
end

local BracketProvider = function(icon_type, callback)
	return function()
		local result = callback()
		local icon = icons[icon_type]

		if (icon == nil) then
			icon = icon_type
		end

		if (result ~= nil and result ~= '') then
			return icon
		end

		return ''
	end
end

galaxy.short_line_list = { 'coc-explorer', 'packer' }

gls.left = {
	{
		GhostLeftBracket = {
			provider = function()
				return icons.rounded_left_filled
			end,
			highlight = 'GalaxyBracketNestedInv'
		}
	},
	{
		Ghost = {
			provider = {
				function()
					local label, mode_color, mode_nested = unpack(get_mode())
					highlight('GalaxyGhost', mode_nested, mode_color, 'bold')
					return icons.ghost .. ' '
				end,
			},
			highlight = 'GalaxyGhost',
		},
	},
	{
		ViModeLeftBracket = {
			provider = function()
				local label, mode_color, mode_nested = unpack(get_mode())
				highlight('GalaxyViModeLeftBracket', mode_color, mode_nested, 'bold')
				return icons.arrow_right_filled
			end,
			highlight = 'GalaxyViModeLeftBracket',
		},
	},
	{
		ViMode = {
			provider = function()
				local label, mode_color, mode_nested = unpack(get_mode())

				highlight('GalaxyViMode', mode_color, colors.bg, 'bold')
				highlight('GalaxyViModeInv', mode_nested, mode_color, 'bold')
				highlight('GalaxyViModeNested', mode_nested, colors.bg, 'bold')
				highlight('GalaxyViModeNestedInv', colors.bg, mode_nested, 'bold')
				highlight('GalaxyBracket', colors.bg, mode_color, 'bold')
				highlight('GalaxyBracketNested', mode_nested, colors.bg, 'bold')
				highlight('GalaxyBracketNestedInv', colors.bg, mode_nested, 'bold')

				return '  ' .. label .. ' '
			end,
			highlight = { colors.bg, colors.bg, 'bold' },
			separator = icons.arrow_right_filled,
			separator_highlight = 'GalaxyViModeInv',
		},
	},
	{
		GitRoot = {
			provider = utils.get_git_root,
			condition = condition.buffer_not_empty,
			icon = '  ',
			highlight = 'GalaxyViModeNested',
			separator = icons.arrow_right .. ' ',
			separator_highlight = 'GalaxyViModeNested',
		},
	},
	{
		FileIcon = {
			provider = 'FileIcon',
			condition = condition.buffer_not_empty,
			highlight = 'GalaxyViModeNested',
		},
	},
	{
		FilePath = {
			provider = FilePathShortProvider,
			condition = condition.buffer_not_empty,
			highlight = 'GalaxyViModeNested',
		},
	},
	{
		FileName = {
			provider = 'FileName',
			condition = condition.buffer_not_empty,
			highlight = 'GalaxyViModeNested',
			separator = icons.arrow_right_filled,
			separator_highlight = 'GalaxyViModeNestedInv',
		},
	},
	{
		DiffAdd = {
			provider = 'DiffAdd',
			icon = '  ',
			condition = check_width_and_git,
			highlight = { colors.green, colors.bg },
		},
	},
	{
		DiffModified = {
			provider = 'DiffModified',
			condition = check_width_and_git,
			icon = '  ',
			highlight = { colors.warn, colors.bg },
		},
	},
	{
		DiffRemove = {
			provider = 'DiffRemove',
			condition = check_width_and_git,
			icon = '  ',
			highlight = { colors.error, colors.bg },
		},
	},
}
-- order ltr
-- info, warn error

gls.right = {
	{
		DiagnosticErrorLeftBracket = {
			provider = BracketProvider('rounded_left_filled', diag.get_diagnostic_error),
			highlight = 'DiagnosticErrorInv',
		}
	},
	{
		DiagnosticError = {
			provider = function()
				local label, mode_color, mode_nested = unpack(get_mode())
				local error_result = diag.get_diagnostic_error()
				highlight('DiagnosticError', colors.error, colors.bg, 'bold')
				highlight('DiagnosticErrorInv', colors.bg, colors.error, 'bold')

				if (error_result ~= '' and error_result ~= nil) then
					return error_result
				end
			end,
			icon = icons.error .. ' ',
			highlight = 'DiagnosticError',
			condition = check_width_and_git,
		}
	},
	{
		DiagnosticErrorRightBracket = {
			provider = {
				BracketProvider('rounded_right_filled', diag.get_diagnostic_error),
				BracketProvider(' ', diag.get_diagnostic_error),
			},
			highlight = 'DiagnosticErrorInv',
		}
	},
	{
		DiagnosticWarnLeftBracket = {
			provider = BracketProvider('rounded_left_filled', diag.get_diagnostic_warn),
			highlight = 'DiagnosticWarnInv',
		}
	},
	{
		DiagnosticWarn = {
			provider = function()
				local warn_result = diag.get_diagnostic_warn()
				highlight('DiagnosticWarn', colors.warn, colors.bg, 'bold')
				highlight('DiagnosticWarnInv', colors.bg, colors.warn, 'bold')

				if (warn_result ~= '' and warn_result ~= nil) then
					return warn_result
				end
			end,
			highlight = 'DiagnosticWarn',
			icon = icons.warn .. ' ',
			condition = check_width_and_git,
		}
	},
	{
		DiagnosticWarnRightBracket = {
			provider = {
				BracketProvider('rounded_right_filled', diag.get_diagnostic_warn),
				BracketProvider(' ', diag.get_diagnostic_warn),
			},
			highlight = 'DiagnosticWarnInv',
		}
	},
	{
		DiagnosticInfoLeftBracket = {
			provider = BracketProvider('rounded_left_filled', diag.get_diagnostic_info),
			highlight = 'DiagnosticInfoInv',
		}
	},
	{
		DiagnosticInfo = {
			provider = function()
				local info_result = diag.get_diagnostic_info()
				highlight('DiagnosticInfo', colors.info, colors.bg, 'bold')
				highlight('DiagnosticInfoInv', colors.bg, colors.info, 'bold')

				if (info_result ~= '' and info_result ~= nil) then
					return info_result
				end
			end,
			icon = icons.info .. ' ',
			highlight = 'DiagnosticInfo',
			condition = check_width_and_git,
		}
	},
	{
		DiagnosticInfoRightBracket = {
			provider = {
				BracketProvider('rounded_right_filled', diag.get_diagnostic_info),
				BracketProvider(' ', diag.get_diagnostic_info),
			},
			highlight = 'DiagnosticInfoInv',
		}
	},
	{
		GitBranchRightBracket = {
			provider = function()
				return icons.arrow_left_filled
			end,
			condition = condition.hide_in_width,
			highlight = 'GalaxyViModeNestedInv',
		}
	},
	{
		GitIcon = {
			provider = function() return '  ' end,
			condition = condition.check_git_workspace,
			highlight = 'GalaxyViModeNested',
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
					return string.sub(branch_name, 1, 25)..'...'
				end
				return branch_name .. ' '
			end,
			condition = condition.check_git_workspace,
			highlight = 'GalaxyViModeNested',
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
	{
		PercentRightBracket = {
			provider = function()
				local label, mode_color, mode_nested = unpack(get_mode())
				return icons.rounded_right_filled
			end,
			highlight = 'GalaxyBracket',
		},
	},
}

gls.short_line_left = {
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
			condition = condition.buffer_not_empty,
			highlight = { colors.white, colors.bg },
		},
	},
}

