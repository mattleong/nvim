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
	ghost = '',
	warn = '',
	info = '',
	error = '',
}

local get_mode = function()
	local mode_colors = {
		[110] = { 'NORMAL', colors.purple, colors.lightPurple },
		[105] = { 'INSERT', colors.matteBlue, colors.blue },
		[99] = { 'COMMAND', colors.pink, colors.salmon},
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

local highlight = function(group, bg, fg, gui)
	vim.api.nvim_command(string.format('hi %s guibg=%s guifg=%s gui=%s', group, bg, fg, gui))
	vim.api.nvim_command(string.format('hi %sInv guibg=%s guifg=%s gui=%s', group, fg, bg, gui))
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

		if (result ~= nil and result ~= '') then
			return icons[icon_type]
		end

		return ''
	end
end

galaxy.short_line_list = { 'coc-explorer', 'packer' }

gls.left = {
	{
		Ghost = {
			provider = {
				function()
					local label, mode_color, mode_nested = unpack(get_mode())
					highlight('GalaxyGhost', colors.bg, mode_color, 'bold')
					return '  ' .. icons.ghost .. ' '
				end,
			},
			highlight = 'GalaxyGhost',
		},
	},
	{
		ViModeLeftBracket = {
			provider = function()
				local label, mode_color, mode_nested = unpack(get_mode())
				highlight('GalaxyViModeBracket', colors.bg, mode_color, 'bold')
				return icons.rounded_left_filled
			end,
			highlight = 'GalaxyViModeBracket',
		},
	},
	{
		ViMode = {
			provider = function()
				local label, mode_color, mode_nested = unpack(get_mode())

				if (mode_nested == nil) then
					mode_nested = colors.lightPurple
				end

				highlight('GalaxyViMode', mode_color, colors.bg, 'bold')
				highlight('GalaxyViModeInv', mode_nested, mode_color, 'bold')
				highlight('GalaxyViModeNested', mode_nested, colors.bg, 'bold')
				highlight('GalaxyViModeNestedInv', colors.bg, mode_nested, 'bold')

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
		DiffAddRightBracket = {
			provider = BracketProvider('arrow_right', vcs.diff_add),
			condition = check_width_and_git,
			highlight = 'GalaxyDiffAdd',
		}
	},
	{
		DiffAdd = {
			provider = 'DiffAdd',
			icon = '   ',
			condition = check_width_and_git,
			highlight = { colors.green, colors.bg },
		},
	},
	{
		DiffModifiedRightBracket = {
			provider = BracketProvider('arrow_right', vcs.diff_modified),
			condition = check_width_and_git,
			highlight = 'GalaxyDiffModified',
		}
	},
	{
		DiffModified = {
			provider = 'DiffModified',
			condition = check_width_and_git,
			icon = '   ',
			highlight = { colors.orange, colors.bg },
		},
	},
	{
		DiffRemoveRightBracket = {
			provider = BracketProvider('arrow_right', vcs.diff_remove),
			condition = check_width_and_git,
			highlight = 'GalaxyDiffRemove',
		}
	},
	{
		DiffRemove = {
			provider = 'DiffRemove',
			condition = check_width_and_git,
			icon = '   ',
			highlight = { colors.red, colors.bg },
		},
	},
}

gls.right = {
	{
		DiagnosticInfoLeftBracket = {
			provider = BracketProvider('rounded_left_filled', diag.get_diagnostic_info),
			highlight = 'NVDiagnosticInfoInv',
		}
	},
	{
		DiagnosticInfo = {
			provider = function()
				highlight('NVDiagnosticInfo', colors.blue, colors.bg, 'bold')
				highlight('NVDiagnosticInfoInv', colors.bg, colors.blue,  'bold')
				local result = diag.get_diagnostic_info()
				if (result ~= nil) then
					return result
				end

				return ''
			end,
			icon = icons.info .. ' ',
			highlight = 'NVDiagnosticInfo',
			condition = check_width_and_git,
		}
	},
	{
		DiagnosticInfoRightBracket = {
			provider = BracketProvider('rounded_right_filled', diag.get_diagnostic_info),
			highlight = 'NVDiagnosticInfoInv',
		}
	},
	{
		Whitespace = {
			provider = function() return ' ' end,
		}
	},
	{
		DiagnosticWarnLeftBracket = {
			provider = BracketProvider('rounded_left_filled', diag.get_diagnostic_warn),
			highlight = 'NVDiagnosticWarnInv',
		}
	},
	{
		DiagnosticWarn = {
			provider = function()
				highlight('NVDiagnosticWarn', colors.orange, colors.bg, 'bold')
				highlight('NVDiagnosticWarnInv', colors.bg, colors.orange, 'bold')
				local result = diag.get_diagnostic_warn()
				if (result ~= nil) then
					return result
				end

				return ''
			end,
			highlight = 'NVDiagnosticWarn',
			icon = icons.warn .. ' ',
			condition = check_width_and_git,
			highlight = 'NVDiagnosticWarn',
		}
	},
	{
		DiagnosticWarnRightBracket = {
			provider = BracketProvider('rounded_right_filled', diag.get_diagnostic_warn),
			highlight = 'NVDiagnosticWarnInv',
		}
	},
	{
		Whitespace = {
			provider = function() return ' ' end,
		}
	},
	{
		DiagnosticErrorLeftBracket = {
			provider = BracketProvider('rounded_left_filled', diag.get_diagnostic_error),
			highlight = 'NVDiagnosticErrorInv',
		}
	},
	{
		DiagnosticError = {
			provider = function()
				highlight('NVDiagnosticError', colors.red, colors.bg, 'bold')
				highlight('NVDiagnosticErrorInv', colors.bg, colors.red, 'bold')
				local result = diag.get_diagnostic_error()
				if (result ~= nil) then
					return result
				end

				return ''
			end,
			icon = icons.error .. ' ',
			highlight = 'NVDiagnosticError',
			condition = check_width_and_git,
		}
	},
	{
		DiagnosticErrorRightBracket = {
			provider = BracketProvider('rounded_right_filled', diag.get_diagnostic_error),
			highlight = 'NVDiagnosticErrorInv',
		}
	},
	{
		FileSizeRightBracket = {
			provider = function()
				return icons.arrow_left_filled
			end,
			condition = condition.hide_in_width,
			highlight = 'GalaxyViModeNestedInv',
		}
	},
	{
		FileSize = {
			provider = 'FileSize',
			highlight = 'GalaxyViModeNested',
			icon = '📄',
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
			highlight = 'GalaxyViModeBracket',
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
			condition = function()
				return is_file() and check_width_and_git()
			end,
			highlight = { colors.white, colors.bg },
		},
	},
}

