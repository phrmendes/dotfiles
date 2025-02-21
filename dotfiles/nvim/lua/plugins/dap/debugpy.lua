return {
	setup = function()
		local dap = require("dap")

		require("dap-python").setup(vim.fn.exepath("nvim-python3"))

		local configs = dap.configurations.python or {}

		dap.configurations.python = configs

		table.insert(configs, {
			type = "python",
			request = "launch",
			name = "django:server",
			program = vim.uv.cwd() .. "/manage.py",
			args = function()
				local port = vim.fn.input("Port: ", "8000")

				return { "runserver", "--noreload", port }
			end,
			justMyCode = true,
			django = true,
			console = "integratedTerminal",
		})

		table.insert(configs, {
			type = "python",
			request = "launch",
			name = "fastapi:server",
			module = "fastapi",
			args = function()
				local entrypoint = vim.fn.input("Entrypoint: ", "src/main.py")
				local port = vim.fn.input("Port: ", "8000")

				return { "run", entrypoint, "--port", port }
			end,
			justMyCode = true,
			console = "integratedTerminal",
		})
	end,
}
