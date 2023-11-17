local files = require("mini.files")
local utils = require("core.utils")

local map = vim.keymap.set

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

map("n", "<Leader>e", function()
	local buffer_name = vim.api.nvim_buf_get_name(0)

	if utils.match_pattern(buffer_name, "Starter") then
		files_toggle(vim.loop.cwd(), true)
	else
		files_toggle(buffer_name, true)
	end
end, { desc = "File explorer" })
