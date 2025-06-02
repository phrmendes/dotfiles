local map = vim.keymap.set
local bufnr = vim.api.nvim_get_current_buf()

map("n", "<leader>kS", function() require("kulala").show_stats() end, { buffer = bufnr, desc = "Statistics" })
map("n", "<leader>ka", function() require("kulala").run_all() end, { buffer = bufnr, desc = "Send all" })
map("n", "<leader>kc", function() require("kulala").copy() end, { buffer = bufnr, desc = "Copy as a curl command" })
map("n", "<leader>ki", function() require("kulala").inspect() end, { buffer = bufnr, desc = "Inspect" })
map("n", "<leader>kq", function() require("kulala").close() end, { buffer = bufnr, desc = "Close" })
map("n", "<leader>kr", function() require("kulala").replay() end, { buffer = bufnr, desc = "Replay" })
map({ "n", "x" }, "<leader>kk", function() require("kulala").run() end, { buffer = bufnr, desc = "Send" })

map("n", "<leader>kf", function() require("kulala").from_curl() end, {
	buffer = bufnr,
	desc = "Paste curl from clipboard",
})
