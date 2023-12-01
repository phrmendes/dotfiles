local dap_go = require("dap-go")

dap_go.setup()

vim.keymap.set("n", "<localleader>m", dap_go.debug_test, { buffer = true, desc = "DAP: debug test" })
