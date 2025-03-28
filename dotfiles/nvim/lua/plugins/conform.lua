return {
	"stevearc/conform.nvim",
	event = "BufWritePre",
	opts = {
		notify_on_error = false,
		formatters_by_ft = {
			css = { "prettier" },
			elixir = { "mix" },
			html = { "prettier" },
			htmldjango = { "djlint" },
			jinja2 = { "djlint" },
			json = { "prettier" },
			lua = { "stylua" },
			markdown = { "prettier" },
			nix = { "nixfmt" },
			python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
			sh = { "shellharden" },
			sql = { "sqlfluff" },
			terraform = { "terraform_fmt" },
			toml = { "taplo" },
			yaml = { "prettier" },
		},
		format_on_save = {
			timeout_ms = 500,
			lsp_format = "fallback",
		},
	},
}
