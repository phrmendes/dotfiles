MiniDeps.add({ source = "stevearc/conform.nvim" })

require("conform").setup({
	notify_on_error = false,
	formatters_by_ft = {
		css = { "prettier" },
		go = { "golines", "gofumpt", "goimports" },
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
		http = { "kulala-fmt" },
	},
	format_on_save = {
		timeout_ms = 500,
		lsp_format = "fallback",
	},
})
