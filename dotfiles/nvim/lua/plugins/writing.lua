local later = require("mini.deps").later

later(function()
	vim.g.markdown_fenced_languages = { "python", "sh" }
	vim.g.mkdp_filetypes = { "markdown", "quarto" }
	vim.g.vim_markdown_folding_disabled = 1

	require("mdeval").setup({
		require_confirmation = false,
		results_label = "**OUTPUT:**",
		eval_options = {
			sh = { command = { "bash" } },
			python = { command = { "python" } },
		},
	})

	require("quarto").setup({
		codeRunner = {
			enabled = true,
			default_method = "slime",
			never_run = { "yaml" },
		},
	})
end)
