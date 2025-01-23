local configs = require("lspconfig.configs")
local lspconfig = require("lspconfig")

if not configs.bibli_ls then
	configs.bibli_ls = {
		default_config = {
			cmd = { "bibli_ls" },
			filetypes = { "markdown", "quarto" },
			root_dir = lspconfig.util.root_pattern(".bibli.toml"),
		},
	}
end

return {}
