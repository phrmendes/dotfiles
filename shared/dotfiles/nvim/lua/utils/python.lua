local M = {}

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
