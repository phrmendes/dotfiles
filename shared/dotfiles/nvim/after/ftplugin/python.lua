local dap = require("plugins.dap")

vim.g.jupytext_fmt = "py:percent"

dap.setup()
dap.python()
