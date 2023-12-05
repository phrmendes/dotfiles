local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

autocmd("FileType", {
	group = augroup("NvimMetals", { clear = true }),
	pattern = { "scala", "sbt", "java" },
	callback = function()
		require("plugins.dap")

		local metals = require("metals")
		local config = metals.bare_config()
		local utils = require("plugins.lsp.utils")

		config.init_options.statusBarProvider = false

		config.settings = {
			showImplicitArguments = true,
			excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
		}

		config.capabilities = utils.capabilities

		config.on_attach = function()
			metals.setup_dap()
			utils.on_attach()
		end

		vim.keymap.set("n", "<leader>m", metals.hover_worksheet, { desc = "Metals: hover worksheet" })

		metals.initialize_or_attach(config)
	end,
})
