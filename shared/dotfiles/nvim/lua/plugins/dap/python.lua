local dap_python = require("dap-python")

dap_python.setup(vim.fn.expand("~") .. "/.virtualenvs/debugpy/bin/python")
dap_python.test_runner = "pytest"

vim.keymap.set("n", "<localleader>m", dap_python.test_method, { buffer = true, desc = "DAP: test method" })
vim.keymap.set("n", "<localleader>c", dap_python.test_class, { buffer = true, desc = "DAP: thest class" })
vim.keymap.set("x", "<localleader>d", dap_python.debug_selection, { buffer = true, desc = "DAP: debug region" })
