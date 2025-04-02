return {
	"mfussenegger/nvim-lint",
	event = "BufReadPre",
	opts = {
		events = { "BufWritePost", "BufReadPost", "InsertLeave" },
		linters_by_ft = {
			htmldjango = { "djlint" },
			jinja2 = { "djlint" },
			dockerfile = { "hadolint" },
			terraform = { "tflint" },
		},
	},
	config = function(_, opts)
		local lint = require("lint")

		lint.linters_by_ft = opts.linters_by_ft

		vim.api.nvim_create_autocmd(opts.events, {
			callback = function() lint.try_lint() end,
		})
	end,
}
