local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local lint = require("lint")

local group = augroup("LintersConfig", { clear = true })

lint.linters_by_ft = {
	nix = { "statix" },
	sh = { "shellcheck" },
}

autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
	group = group,
	callback = function()
		lint.try_lint()
	end,
})
