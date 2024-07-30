require("conform").setup({
	notify_on_error = false,
	format_on_save = {
		timeout_ms = 500,
		lsp_format = "fallback",
	},
	formatters_by_ft = {
		css = { "prettier" },
		html = { "prettier" },
		go = { "gofumpt", "goimports-reviser", "golines" },
		json = { "prettier" },
		lua = { "stylua" },
		markdown = { "prettier" },
		nix = { "alejandra" },
		python = { "ruff_format" },
		sh = { "shellharden" },
		terraform = { "terraform_fmt" },
		toml = { "taplo" },
		yaml = { "prettier" },
	},
})
