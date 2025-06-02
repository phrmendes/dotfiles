MiniDeps.add({ source = "mfussenegger/nvim-lint" })

local lint = require("lint")

lint.linters_by_ft = {
	htmldjango = { "djlint" },
	jinja2 = { "djlint" },
	dockerfile = { "hadolint" },
	terraform = { "tflint" },
	go = { "golangcilint" },
}

vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
	desc = "Run linters on file save, read, or leave insert mode",
	group = vim.api.nvim_create_augroup("UserLint", { clear = true }),
	callback = function() lint.try_lint() end,
})
