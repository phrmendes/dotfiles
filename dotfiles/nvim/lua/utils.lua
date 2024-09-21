local augroup = vim.api.nvim_create_augroup

local M = {}

M.augroups = {
	filetype = augroup("UserFileType", { clear = true }),
	mini = augroup("UserMini", { clear = true }),
	yank = augroup("UserYank", { clear = true }),
	lsp = {
		attach = augroup("UserLspAttach", { clear = true }),
		detach = augroup("UserLspDetach", { clear = true }),
		highlight = augroup("UserLspHighlight", { clear = true }),
		lint_format = augroup("UserLspLintFormat", { clear = true }),
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

M.open = function(obj)
	vim.fn.jobstart({ "xdg-open", obj })
end

M.borders = {
	border = "rounded",
	winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None",
}

return M
