local galaxy = require('galaxyline');
local gls = galaxy.section
local vcs = require('galaxyline.provider_vcs')
local condition = require 'galaxyline.condition'
local fileinfo = require('galaxyline.provider_fileinfo')

local sep = {
  right_filled = '', -- e0b2
  left_filled = '', -- e0b0
  right = '', -- e0b3
  left = '', -- e0b1
}
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
	brackets = {
		left = '',
		right = '',
	},
	arrows = {
		left_filled = '', -- e0b2
		right_filled = '', -- e0b0
		left = '', -- e0b3
		right = '', -- e0b1
	},
	ghost = '👻',
}

local get_formatted_bracket = function(type)
	local bracket = icons.brackets[type]
	if (type == 'left') then
		bracket = '' .. bracket
	end
	return bracket
end

local DiffBracketProvider = function(type, diff_type)
	return function()
		local result = nil
		local bracket = get_formatted_bracket(type)

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

local function get_basename(file)
	return file:match '^.+/(.+)$'
end

local GetGitRoot = function()
	local git_dir = require('galaxyline.provider_vcs').get_git_dir()
	if not git_dir then
		return 'not a git dir '
	end

	local git_root = git_dir:gsub('/.git/?$', '')
	return get_basename(git_root) .. ' '
end

local mode_color = function()
	local mode_colors = {
		[110] = colors.green,
		[105] = colors.blue,
		[99] = colors.green,
		[116] = colors.blue,
		[118] = colors.purple,
		[22] = colors.purple,
		[86] = colors.purple,
		[82] = colors.red,
		[115] = colors.red,
		[83] = colors.red,
	}

	local color = mode_colors[vim.fn.mode():byte()]
	if color ~= nil then
		return color
	else
		return colors.purple
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
	return '' .. line_column
end

local PercentProvider = function()
	local line_column = fileinfo.current_line_percent()
	line_column = line_column:gsub("%s+", "")
	return '≡' .. line_column
end

local mode_hightlight = function(bg, fg)
	vim.api.nvim_command(string.format('hi GalaxyViMode guibg=%s guifg=%s gui=bold', bg, fg))
	vim.api.nvim_command(string.format('hi GalaxyViModeInv guibg=%s guifg=%s gui=bold', fg, bg))
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
				local aliases = {
					[110] = 'NORMAL',
					[105] = 'INSERT',
					[99] = 'COMMAND',
					[116] = 'TERMINAL',
					[118] = 'VISUAL',
					[22] = 'V-BLOCK',
					[86] = 'V-LINE',
					[82] = 'REPLACE',
					[115] = 'SELECT',
					[83] = 'S-LINE',
				}

				mode_hightlight(mode_color(), colors.bg)
				local alias = aliases[vim.fn.mode():byte()]
				local mode
				if alias ~= nil then
					if condition.hide_in_width() then
						mode = alias
					else
						mode = alias:sub(1, 1)
					end
				else
					mode = vim.fn.mode():byte()
				end
				return '  ' .. mode .. ' '
			end,
			highlight = { colors.bg, colors.bg, 'bold' },
			separator = get_formatted_bracket('right'),
			separator_highlight = 'GalaxyViModeInv',
		},
	},
	{
		FileNameLeftBracket = {
			provider = function()
				return get_formatted_bracket('left')
			end,
			highlight = { colors.matteBlue, colors.bg },
			condition = condition.buffer_not_empty,
		}
	},
	{
		GitRoot = {
			provider = GetGitRoot,
			condition = condition.buffer_not_empty,
			icon = ' ',
			highlight = { colors.white, colors.matteBlue },
			separator = icons.arrows.right .. ' ',
			separator_highlight = { colors.white, colors.matteBlue }
		},
	},
	{
		FileIcon = {
			provider = 'FileIcon',
			condition = condition.buffer_not_empty,
			highlight = {
				require('galaxyline.provider_fileinfo').get_file_icon,
				colors.matteBlue,
			},
		},
	},
	{
		FilePath = {
			provider = FilePathShortProvider,
			condition = condition.buffer_not_empty,
			highlight = { colors.white, colors.matteBlue },
		},
	},
	{
		FileName = {
			provider = 'FileName',
			condition = condition.buffer_not_empty,
			highlight = { colors.white, colors.matteBlue },
		},
	},
	{
		FileNameRightBracket = {
			provider = function()
				return get_formatted_bracket('right')
			end,
			highlight = { colors.matteBlue, colors.bg },
			condition = condition.buffer_not_empty,
		},
	},
	{
		DiffAddLeftBracket = {
			provider = {
				DiffBracketProvider('left', 'add'),
			},
			condition = check_width_and_git,
			highlight = { colors.green, colors.bg },
		}
	},
	{
		DiffAdd = {
			provider = 'DiffAdd',
			icon = '  ',
			condition = check_width_and_git,
			highlight = { colors.bg, colors.green },
		},
	},
	{
		DiffAddRightBracket = {
			provider = {
				DiffBracketProvider('right', 'add'),
			},
			condition = check_width_and_git,
			highlight = { colors.green, colors.bg },
		}
	},
	{
		DiffModifiedLeftBracket = {
			provider = {
				DiffBracketProvider('left', 'modified'),
			},
			condition = check_width_and_git,
			highlight = { colors.orange, colors.bg },
		}
	},
	{
		DiffModified = {
			provider = 'DiffModified',
			condition = check_width_and_git,
			icon = '  ',
			highlight = { colors.bg, colors.orange }, -- test
		},
	},
	{
		DiffModifiedRightBracket = {
			provider = {
				DiffBracketProvider('right', 'modified'),
			},
			condition = check_width_and_git,
			highlight = { colors.orange, colors.bg },
		}
	},
	{
		DiffRemoveLeftBracket = {
			provider = {
				DiffBracketProvider('left', 'remove'),
			},
			condition = check_width_and_git,
			highlight = { colors.red, colors.bg },
		}
	},
	{
		DiffRemove = {
			provider = 'DiffRemove',
			condition = check_width_and_git,
			icon = '  ',
			highlight = { colors.bg, colors.red },
		},
	},
	{
		DiffRemoveRightBracket = {
			provider = {
				DiffBracketProvider('right', 'remove'),
			},
			condition = check_width_and_git,
			highlight = { colors.red, colors.bg },
		}
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
}

gls.right = {
	{
		DiagnosticInfo = {
			provider = 'DiagnosticInfo',
			icon = '  ',
			highlight = { colors.blue, colors.bg },
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
		}
	},
	{
		Whitespace = {
			provider = function() return ' ' end,
		}
	},
	{
	},
	{
		LCBracket = {
			provider = {
				function()
					return get_formatted_bracket('left')
				end
			},
			condition = check_width_and_git,
			highlight = { colors.lightPurple, colors.bg },
		}
	},
	{
		LineColumn = {
			provider = {
				LineColumnProvider,
				function() return ' ' end,
			},
			highlight = { colors.bg, colors.lightPurple },
			separator = ' ',
			separator_highlight = { colors.lightPurple, colors.lightPurple },
		}
	},
	{
		PerCent = {
			provider = {
				PercentProvider,
				function() return ' ' end,
			},
			highlight = { colors.bg, colors.lightPurple },
			separator = icons.arrows.left .. ' ',
			separator_highlight = { colors.bg, colors.lightPurple },
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
			provider = GetGitRoot,
			condition = condition.buffer_not_empty,
			icon = ' ',
			highlight = { colors.white, colors.bg },
		},
	},
}

