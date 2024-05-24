local augroup = vim.api.nvim_create_augroup

local M = {}
M.lsp = {}

M.augroups = {
	term = augroup("UserTerm", { clear = true }),
	filetype = augroup("UserFileType", { clear = true }),
	linter = augroup("UserLinter", { clear = false }),
	lsp = {
		attach = augroup("UserLspAttach", { clear = true }),
		detach = augroup("UserLspDetach", { clear = true }),
		highlight = augroup("UserLspHighlight", { clear = false }),
		fs = augroup("UserFileSystem", { clear = false }),
	},
}

M.match_pattern = function(string, pattern)
	if string:match(pattern) then
		return true
	end

	return false
end

M.normalize = function(word)
	local normalized_word = word:lower():gsub("[%z\1-\127\194-\244][\128-\191]*", function(c)
		return c:gsub("[áàâ]", "a")
			:gsub("[ç]", "c")
			:gsub("[éèê]", "e")
			:gsub("[íìî]", "i")
			:gsub("[óòô]", "o")
			:gsub("[úùû]", "u")
	end)

	return normalized_word:gsub("[%s%W]", "_")
end

M.open = function(arg)
	local open

	if vim.fn.has("mac") == 1 then
		open = { "open", arg }
	else
		open = { "xdg-open", arg }
	end

	vim.fn.jobstart(open)
end

return M
