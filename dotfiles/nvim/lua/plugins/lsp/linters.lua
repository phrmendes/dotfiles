local lint = require("lint")

local autocmd = vim.api.nvim_create_autocmd

lint.linters_by_ft = {
	nix = { "statix" },
	sh = { "shellcheck" },
	sql = { "sqlfluff" },
	jinja = { "djlint" },
	go = { "golangcilint" },
}

autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
	group = require("utils").augroups.linter,
	callback = function()
		lint.try_lint()
	end,
})
