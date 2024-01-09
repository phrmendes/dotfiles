local conform = require("conform")

conform.setup({
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
	css = { "prettier" },
	go = { "gofumpt", "goimports-reviser", "golines" },
	html = { "prettier" },
	jinja = { "djlint" },
	json = { "prettier" },
	lua = { "stylua" },
	markdown = { "prettier" },
	nix = { "alejandra" },
	python = { "ruff" },
	sh = { "shellharden" },
	sql = { "sqlfluff" },
	terraform = { "terraform_fmt" },
	toml = { "taplo" },
	yaml = { "prettier" },
}
