local config = require("metals").bare_config()

config.settings = {
	showImplicitArguments = true,
	excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
}

config.init_options.statusBarProvider = "off"
config.capabilities = require("cmp_nvim_lsp").default_capabilities()

return config
