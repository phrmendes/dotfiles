local metals = require("metals")
local utils = require("utils")

local metals_config = metals.bare_config()

metals_config.init_options.statusBarProvider = "on"

metals_config.settings = {
	showImplicitArguments = true,
	excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
}

metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()

metals_config.on_attach = function(client, bufnr)
	require("plugins.dap.scala")

	metals.setup_dap()
	utils.on_attach(client, bufnr)

	utils.section({
		buffer = bufnr,
		key = "<leader>m",
		name = "metals",
	})

	utils.map({
		key = "<leader>mh",
		command = require("metals").hover_worksheet,
		desc = "Hover worksheet",
		buffer = bufnr,
	})

	utils.map({
		key = "<leader>mc",
		command = require("metals").commands,
		desc = "Commands",
		buffer = bufnr,
	})
end

vim.api.nvim_create_autocmd("FileType", {
	group = utils.augroup,
	pattern = { "scala", "sbt" },
	callback = function()
		metals.initialize_or_attach(metals_config)
	end,
})
