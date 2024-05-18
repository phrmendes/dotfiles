local neotest_namespace = vim.api.nvim_create_namespace("neotest")

require("neotest").setup({
	adapters = {
		require("neotest-python"),
		require("neotest-golang")({ dap_go_enabled = true }),
	},
})

vim.diagnostic.config({
	virtual_text = {
		format = function(diagnostic)
			local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
			return message
		end,
	},
}, neotest_namespace)
