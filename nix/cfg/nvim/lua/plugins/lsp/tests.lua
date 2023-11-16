local neotest = require("neotest")
local python = require("neotest-python")
local scala = require("neotest-scala")

local map = vim.keymap.set

local M = {}

M.config = function()
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
end

M.keymaps = function()
	map("n", "<Leader>ta", neotest.run.attach, { desc = "Attach nearest test" })
	map("n", "<Leader>ts", neotest.run.stop, { desc = "Stop nearest test" })
	map("n", "<Leader>tt", neotest.run.run, { desc = "Run nearest test" })

	map("n", "<Leader>tf", function()
		neotest.run.run(vim.fn.expand("%"))
	end, { desc = "Run current file" })

	map("n", "<Leader>td", function()
		neotest.run.run({ strategy = "dap" })
	end, { desc = "Debug nearest test" })
end

return M
