local dap_python = require("dap-python")

dap_python.setup(vim.fn.expand("~") .. "/.virtualenvs/debugpy/bin/python")
dap_python.test_runner = "pytest"
