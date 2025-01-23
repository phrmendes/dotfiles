return {
	debugpy = function()
		local dap = require("dap")
		local configs = dap.configurations.python or {}

		require("dap-python").setup(vim.fn.exepath("nvim-python3"))

		dap.configurations.python = configs

		table.insert(configs, {
			type = "python",
			request = "launch",
			name = "Debug Django app",
			program = vim.uv.cwd() .. "/manage.py",
			args = function()
				local port

				vim.ui.input({ prompt = "Enter the port to the Django app: ", default = "8001" }, function(input)
					port = input
				end)

				return { "runserver", "--noreload", port }
			end,
			justMyCode = true,
			django = true,
			console = "integratedTerminal",
		})

		table.insert(configs, {
			type = "python",
			request = "launch",
			name = "Debug FastAPI app",
			module = "fastapi",
			args = function()
				local path

				vim.ui.input({ prompt = "Enter the path to the FastAPI app: ", default = "src/main.py" }, function(input)
					path = input
				end)

				return { "run", path }
			end,
			justMyCode = true,
			console = "integratedTerminal",
		})
	end,
}
