MiniDeps.later(function()
	require("mini.completion").setup({
		window = {
			info = { height = 25, width = 80, border = vim.g.border },
			signature = { height = 25, width = 80, border = vim.g.border },
		},
		fallback_action = "<c-n>",
		lsp_completion = {
			source_func = "omnifunc",
			auto_setup = true,
		},
		mappings = {
			force_twostep = "<c-f>",
			force_fallback = "<a-f>",
			scroll_down = "<c-d>",
			scroll_up = "<c-u>",
		},
	})

	vim.api.nvim_create_autocmd("FileType", {
		desc = "Disable completion in certain filetypes",
		pattern = { "dap-view", "dap-view-term", "dap-repl", "snacks_input", "minifiles", "grug-far" },
		callback = function(event) vim.b[event.buf].minicompletion_disable = true end,
	})
end)
