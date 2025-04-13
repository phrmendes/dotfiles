return {
	cmd = { "bibli_ls" },
	filetypes = { "markdown", "quarto" },
	root_dir = require("lspconfig").util.root_pattern(".bibli.toml"),
}
