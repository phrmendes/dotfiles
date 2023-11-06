local neotest = require("neotest")
local python = require("neotest-python")
local scala = require("neotest-scala")

neotest.setup({
	adapters = {
		python({
			dap = { justMyCode = false },
			runner = "pytest",
		}),
		scala({
			runner = "sbt",
		}),
	},
})
