local files = require("mini.files")

files.setup({
	mappings = {
		go_in_plus = "<CR>",
	},
})

local files_toggle = function(...)
	if not files.close() then
		files.open(...)
	end
end

vim.keymap.set("n", "<leader>fe", function()
	files_toggle(vim.loop.cwd(), true)
end, { noremap = true, desc = "Explorer" })
