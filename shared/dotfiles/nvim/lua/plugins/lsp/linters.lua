local lint = require("lint")
local augroup = require("utils").augroup

local autocmd = vim.api.nvim_create_autocmd

lint.linters_by_ft = {
	nix = { "statix" },
	sh = { "shellcheck" },
	sql = { "sqlfluff" },
}

autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
	group = augroup,
	callback = function()
		lint.try_lint()
	end,
})
