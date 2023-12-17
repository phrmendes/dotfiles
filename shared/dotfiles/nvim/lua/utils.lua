local M = {}

M.border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }

M.normalize = function(word)
	word = word:lower()
	local normalized_word = word:gsub("[%z\1-\127\194-\244][\128-\191]*", function(c)
		return c:gsub("[áàâ]", "a")
			:gsub("[éèê]", "e")
			:gsub("[íìî]", "i")
			:gsub("[óòô]", "o")
			:gsub("[úùû]", "u")
			:gsub("[ç]", "c")
	end)

	normalized_word = normalized_word:gsub("[%s%W]", "_")

	return normalized_word
end

M.match_pattern = function(string, pattern)
	local match = string:match(pattern)

	if match then
		return true
	else
		return false
	end
end

M.section = function(args)
	require("which-key").register({
		mode = args.mode or "n",
		buffer = args.buffer or nil,
		[args.key] = { name = args.name },
	})
end

M.map = function(args, opts)
	local options

	if opts then
		options = vim.tbl_extend("force", opts, { buffer = args.buffer or nil, desc = args.desc })
	else
		options = {
			buffer = args.buffer or nil,
			desc = args.desc,
		}
	end

	vim.keymap.set(args.mode or "n", args.key, args.command, options)
end

M.open_uri_under_cursor = function()
	local function open_uri(uri)
		if type(uri) ~= "nil" then
			uri = string.gsub(uri, "#", "\\#")
			uri = '"' .. uri .. '"'

			if vim.fn.has("mac") == 1 then
				vim.cmd["!"]({ "open", uri })
				vim.cmd.redraw()
			else
				vim.cmd["!"]({ "xdg-open", uri })
				vim.cmd.redraw()
			end

			return true
		else
			return false
		end
	end

	local word_under_cursor = vim.fn.expand("<cWORD>")

	local regex_protocol_uri = "%a*:%/%/[%a%d%#%[%]%-%%+:;!$@/?&=_.,~*()]*[^%)]"

	if open_uri(string.match(word_under_cursor, regex_protocol_uri)) then
		return
	end

	local regex_plugin_url = "[%a%d%-%.%_]*%/[%a%d%-%.%_]*"

	if open_uri("https://github.com/" .. string.match(word_under_cursor, regex_plugin_url)) then
		return
	end
end

M.augroup = vim.api.nvim_create_augroup("UserGroup", { clear = true })

M.venv = function()
	if vim.env.CONDA_DEFAULT_ENV then
		return string.format(" %s (conda)", vim.env.CONDA_DEFAULT_ENV)
	end

	if vim.env.VIRTUAL_ENV then
		return string.format(" %s (venv)", vim.fn.fnamemodify(vim.env.VIRTUAL_ENV, ":t"))
	end

	return ""
end

return M
