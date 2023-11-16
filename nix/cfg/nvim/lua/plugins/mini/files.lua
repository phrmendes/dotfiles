local files = require("mini.files")

local map = vim.keymap.set

files.setup()

vim.api.nvim_create_autocmd("User", {
	pattern = "MiniFilesBufferCreate",
	callback = function(args)
		local buf_id = args.data.buf_id
		map("n", "<Leader>e", "<cmd>lua MiniFiles.close()<cr>", { buffer = buf_id })
	end,
})

map("n", "<Leader>e", "<cmd>lua MiniFiles.open(vim.loop.cwd(), true)<cr>", { desc = "File explorer" })
