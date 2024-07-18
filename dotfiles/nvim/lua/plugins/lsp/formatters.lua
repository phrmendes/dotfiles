require("conform").setup({
	format_on_save = {
		timeout_ms = 500,
		lsp_format = "fallback",
	},
	formatters_by_ft = {
		css = { "prettierd" },
		go = { "gofumpt", "goimports-reviser", "golines" },
		json = { "prettierd" },
		lua = { "stylua" },
		markdown = { "prettierd" },
		nix = { "alejandra" },
		python = { "ruff_format" },
		sh = { "shellharden" },
		terraform = { "terraform_fmt" },
		toml = { "taplo" },
		yaml = { "prettierd" },
		sql = { "sqlfluff" },
	},
})
