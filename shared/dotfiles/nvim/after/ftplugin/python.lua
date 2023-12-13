require("plugins.dap")

local dap_python = require("dap-python")

local map = vim.keymap.set

dap_python.setup(vim.fn.expand("~") .. "/.virtualenvs/tools/bin/python")
dap_python.test_runner = "pytest"

map("n", "<localleader>m", dap_python.test_method, { buffer = 0, desc = "DAP: test method" })
map("n", "<localleader>c", dap_python.test_class, { buffer = 0, desc = "DAP: thest class" })
map("x", "<localleader>s", dap_python.debug_selection, { buffer = 0, desc = "DAP: debug region" })
