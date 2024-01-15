local conform = require("conform")

conform.setup({
	notify_on_error = false,
	format_on_save = {
		lsp_fallback = true,
		async = false,
		timeout_ms = 1000,
	},
})

conform.formatters.tex = {
	cmd = "latexindent.pl",
	args = { "-" },
	stdin = true,
}

conform.formatters_by_ft = {
	css = { "prettierd" },
	go = { "gofumpt", "goimports-reviser", "golines" },
	html = { "prettierd" },
	jinja = { "djlint" },
	json = { "prettierd" },
	lua = { "stylua" },
	markdown = { "prettierd" },
	nix = { "alejandra" },
	python = { "ruff" },
	sh = { "shellharden" },
	sql = { "sqlfluff" },
	terraform = { "terraform_fmt" },
	toml = { "taplo" },
	yaml = { "prettierd" },
}
