return {
	on_attach = function(_, bufnr)
		if vim.bo[bufnr].buftype ~= "" or vim.bo[bufnr].filetype == "helm" then
			vim.diagnostic.enable(false, { bufnr = bufnr })

			vim.defer_fn(function() vim.diagnostic.reset(nil, bufnr) end, 1000)
		end
	end,
	settings = {
		yaml = {
			schemas = require("schemastore").yaml.schemas(),
			schemaStore = {
				enable = false,
				url = "",
			},
		},
	},
}
