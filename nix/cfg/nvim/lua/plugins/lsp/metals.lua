local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local map = vim.keymap.set

local cmp_nvim_lsp = require("cmp_nvim_lsp")
local metals = require("metals")
local metals_config = require("metals").bare_config()

-- statusline
metals_config.init_options.statusBarProvider = "on"

-- LSP
metals_config.settings = {
	useGlobalExecutable = true,
	showInferredType = true,
	showImplicitArguments = true,
}

metals_config.capabilities = cmp_nvim_lsp.default_capabilities()

-- DAP
metals_config.on_attach = function()
	metals.setup_dap()
end

-- start metals server with configurations
local group = augroup("MetalsLspConfig", { clear = true })

autocmd("FileType", {
	pattern = { "scala", "sbt", "java" },
	callback = function()
		metals.initialize_or_attach(metals_config)
		map("n", "<Leader>m", metals.hover_worksheet, { desc = "Metals: Worksheet" })
	end,
	group = group,
})
