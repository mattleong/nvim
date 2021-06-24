local galaxy = require('galaxyline');
local gls = galaxy.section
local condition = require 'galaxyline.condition'

local colors = {
	brown = '#a9323d',
	aqua = '#5b9c9c',
	blue = '#5d8fac',
	darkBlue = '#557486',
	purple = '#6f78be',
	lightPurple = '#959acb',
	red = '#c2616b', beige = '#686765', yellow = '#8e8a6f',
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

local function get_basename(file)
	return file:match '^.+/(.+)$'
end

local GetGitRoot = function()
	local git_dir = require('galaxyline.provider_vcs').get_git_dir()
	if not git_dir then
		return ''
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

local in_git_repo = function ()
	local vcs = require('galaxyline.provider_vcs')
	local branch_name = vcs.get_git_branch()

	return branch_name ~= nil
end

local function file_readonly()
	if vim.bo.filetype == 'help' then
		return ''
	end
	if vim.bo.readonly == true then
		return '  '
	end
	return ''
end

local function get_current_file_name()
	local file = vim.fn.expand '%:t'
	if vim.fn.empty(file) == 1 then
		return ''
	end
	if string.len(file_readonly()) ~= 0 then
		return file .. file_readonly()
	end
	if vim.bo.modifiable then
		if vim.bo.modified then
			return file .. '  '
		end
	end
	return file .. ' '
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

local function has_width_gt(cols)
	-- Check if the windows width is greater than a given number of columns
	return vim.fn.winwidth(0) / 2 > cols
end

local buffer_empty = function()
	return vim.fn.empty(vim.fn.expand '%:t') == 1
end

local buffer_not_empty = function()
	return not buffer_empty()
end

local checkwidth = function()
	return has_width_gt(35) and buffer_not_empty()
end

local is_file = function()
	return vim.bo.buftype ~= 'nofile'
end

galaxy.short_line_list = {" "}

gls.left[1]= {
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
			vim.api.nvim_command('hi GalaxyViMode guibg=' .. mode_color())
			local alias = aliases[vim.fn.mode():byte()]
			local mode
			if alias ~= nil then
				if has_width_gt(35) then
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
	},
}

gls.left[2] = {
	FileIcon = {
		provider = { function()
			return '  '
		end, 'FileIcon' },
		condition = buffer_not_empty,
		highlight = {
			require('galaxyline.provider_fileinfo').get_file_icon,
			colors.matteBlue,
		},
	},
}

gls.left[3] = {
	FilePath = {
		provider = function()
			local fp = vim.fn.fnamemodify(vim.fn.expand '%', ':~:.:h')
			local tbl = split(fp, '/')
			local len = #tbl

			if len > 2 and not len == 3 and not tbl[0] == '~' then
				return '…/' .. table.concat(tbl, '/', len - 1) .. '/'
			else
				return fp .. '/'
			end
		end,
		condition = function()
			return is_file() and checkwidth()
		end,
		highlight = { colors.white, colors.matteBlue },
	},
}

gls.left[4] = {
	FileName = {
		provider = get_current_file_name,
		condition = buffer_not_empty,
		highlight = { colors.white, colors.matteBlue },
		separator = '',
		separator_highlight = { colors.matteBlue, colors.matteBlue },
	},
}

gls.left[6] = {
	DiffAdd = {
		provider = 'DiffAdd',
		condition = checkwidth,
		icon = '  ',
		highlight = { colors.bg, colors.green },
		separator = '',
		separator_highlight = { colors.green, colors.green },
	},
}

gls.left[7] = {
	DiffModified = {
		provider = 'DiffModified',
		condition = checkwidth,
		icon = '  ',
		highlight = { colors.bg, colors.orange },
		separator = '',
		separator_highlight = { colors.orange, colors.orange },
	},
}

gls.left[8] = {
	DiffRemove = {
		provider = 'DiffRemove',
		condition = checkwidth,
		separator = '',
		separator_highlight = { colors.red, colors.red },
		icon = '  ',
		highlight = { colors.bg, colors.red },
	},
}

gls.left[9] = {
	GitIcon = {
		provider = function() return '  ' end,
		condition = in_git_repo,
		highlight = {colors.pink, colors.bg},
	}
}

gls.left[10] = {
	GitBranch = {
		provider = function()
			local vcs = require('galaxyline.provider_vcs')
			local branch_name = vcs.get_git_branch()
			if (string.len(branch_name) > 28) then
				return string.sub(branch_name, 1, 25).."..."
			end
			return branch_name .. " "
		end,
		condition = in_git_repo,
		highlight = {colors.white, colors.bg},
	}
}

gls.right[0] = {
	DiagnosticInfo = {
		provider = 'DiagnosticInfo',
		icon = '  ',
		highlight = {colors.blue, colors.bg},
	}
}

gls.right[1] = {
	Space = {
		provider = function () return ' ' end,
		highlight = {colors.bg, colors.bg},
	}
}

gls.right[2] = {
	DiagnosticWarn = {
		provider = 'DiagnosticWarn',
		icon = '  ',
		highlight = {colors.orange, colors.bg},
	}
}

gls.right[3] = {
	Space = {
		provider = function () return ' ' end,
		highlight = {colors.bg, colors.bg},
	}
}

gls.right[10] = {
	DiagnosticError = {
		provider = 'DiagnosticError',
		icon = '  ',
		highlight = {colors.red, colors.bg},
	}
}

gls.right[20] = {
	GitRoot = {
		provider = { GetGitRoot },
		condition = function()
			return has_width_gt(50) and condition.check_git_workspace
		end,
		icon = ' ',
		highlight = { colors.white, colors.matteBlue },
		separator = '',
		separator_highlight = { colors.matteBlue, colors.matteBlue },
	},
}

gls.right[30] = {
	PerCent = {
		provider = 'LinePercent',
		separator = ' ',
		highlight = { colors.bg, colors.lightPurple },
		separator_highlight = { colors.lightPurple, colors.lightPurple },
	},
}

