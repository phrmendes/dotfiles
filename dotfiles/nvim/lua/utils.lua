local augroup = vim.api.nvim_create_augroup

local M = {}
M.lsp = {}

M.augroups = {
	term = augroup("UserTerm", { clear = true }),
	filetype = augroup("UserFileType", { clear = true }),
	linter = augroup("UserLinter", { clear = true }),
	mini = augroup("UserMini", { clear = true }),
	lsp = {
		attach = augroup("UserLspAttach", { clear = true }),
		detach = augroup("UserLspDetach", { clear = true }),
		highlight = augroup("UserLspHighlight", { clear = true }),
		fs = augroup("UserFileSystem", { clear = true }),
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
		return c:gsub("[ÁÀÂ]", "A")
			:gsub("[ÉÈÊ]", "E")
			:gsub("[ÍÌÎ]", "I")
			:gsub("[ÓÒÔ]", "O")
			:gsub("[ÚÙÛ]", "U")
			:gsub("[Ç]", "C")
			:gsub("[áàâ]", "a")
			:gsub("[éèê]", "e")
			:gsub("[íìî]", "i")
			:gsub("[óòô]", "o")
			:gsub("[úùû]", "u")
			:gsub("[ç]", "c")
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
