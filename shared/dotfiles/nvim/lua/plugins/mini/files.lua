local files = require("mini.files")
local utils = require("core.utils")
local wk = require("which-key")

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

local files_buffer = function()
	local buffer_name = vim.api.nvim_buf_get_name(0)

	if utils.match_pattern(buffer_name, "Starter") then
		files_toggle(vim.loop.cwd(), true)
	else
		files_toggle(buffer_name, true)
	end
end

local files_cwd = function()
	files_toggle(vim.loop.cwd(), true)
end

wk.register({
	E = { files_cwd, "File explorer (cwd)" },
	e = { files_buffer, "File explorer (buffer)" },
}, { prefix = "<leader>", mode = "n" })
