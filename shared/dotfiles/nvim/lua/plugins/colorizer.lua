vim.api.nvim_create_autocmd("FileType", {
	group = require("utils").augroup,
	pattern = { "css", "html" },
	callback = function()
		require("colorizer").setup({
			tailwind = true,
			filetypes = { "css", "html" },
		})
	end,
})
