local M = {}

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
