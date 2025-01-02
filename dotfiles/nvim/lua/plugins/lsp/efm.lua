local efm = {
	css = { require("efmls-configs.formatters.prettier") },
	dockerfile = { require("efmls-configs.linters.hadolint") },
	elixir = { require("efmls-configs.formatters.mix") },
	html = { require("efmls-configs.formatters.prettier") },
	htmldjango = { require("efmls-configs.linters.djlint"), require("efmls-configs.formatters.djlint") },
	jinja2 = { require("efmls-configs.linters.djlint"), require("efmls-configs.formatters.djlint") },
	json = { require("efmls-configs.formatters.prettier") },
	lua = { require("efmls-configs.formatters.stylua") },
	markdown = { require("efmls-configs.formatters.prettier") },
	nix = { require("efmls-configs.formatters.alejandra") },
	python = { require("efmls-configs.formatters.ruff"), require("efmls-configs.formatters.ruff_sort") },
	scss = { require("efmls-configs.formatters.prettier") },
	sh = { require("efmls-configs.formatters.shellharden") },
	sql = { require("efmls-configs.formatters.sql-formatter") },
	terraform = { require("efmls-configs.formatters.terraform_fmt") },
	toml = { require("efmls-configs.formatters.taplo") },
	yaml = { require("efmls-configs.formatters.prettier") },
}

return {
	init_options = {
		documentFormatting = true,
		documentRangeFormatting = true,
	},
	filetypes = vim.tbl_keys(efm),
	settings = {
		rootMarkers = { ".git/" },
		languages = efm,
	},
}
