local M = {}

M.border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }

M.normalize = function(word)
	word = word:lower()
	local normalized_word = word:gsub("[%z\1-\127\194-\244][\128-\191]*", function(c)
		return c:gsub("[áàâä]", "a")
			:gsub("[éèêë]", "e")
			:gsub("[íìîï]", "i")
			:gsub("[óòôö]", "o")
			:gsub("[úùûü]", "u")
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

return M
