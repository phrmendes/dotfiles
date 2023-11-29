local lint = require("lint")

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

lint.linters_by_ft = {
	nix = { "statix" },
	sh = { "shellcheck" },
	go = { "golangci_lint" },
}

autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
	group = augroup("LintersConfig", { clear = true }),
	callback = function()
		lint.try_lint()
	end,
})
