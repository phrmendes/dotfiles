local api = vim.api

api.nvim_create_autocmd("FileType", {
	desc = "Quarto filetype",
	pattern = { "*.qmd" },
	callback = function()
		api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
			command = "<cmd>set ft=markdown<cr>",
		})
	end,
	group = api.nvim_create_augroup("QuartoFt", { clear = true }),
})
