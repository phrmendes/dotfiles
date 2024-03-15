require("neogit").setup()

require("gitsigns").setup({
	on_attach = function()
		if vim.fn.has("mac") == 0 then
			require("octo").setup({
				suppress_missing_scope = {
					project_v2 = true,
				},
			})
		end
	end,
})
