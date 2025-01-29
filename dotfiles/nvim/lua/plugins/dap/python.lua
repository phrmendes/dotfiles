return {
	debugpy = function()
		local dap = require("dap")

		require("dap-python").setup(vim.fn.exepath("nvim-python3"))

		local configs = dap.configurations.python or {}

		dap.configurations.python = configs

		table.insert(configs, {
			type = "python",
			request = "launch",
			name = "Debug Django app",
			program = vim.uv.cwd() .. "/manage.py",
			args = function()
				local input = vim.fn.input("Enter the port for the Django app: ", "8001")
				return { "runserver", "--noreload", input }
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
				local input = vim.fn.input("Enter the path to the FastAPI app: ", "src/main.py")
				return { "run", input }
			end,
			justMyCode = true,
			console = "integratedTerminal",
		})
	end,
}
