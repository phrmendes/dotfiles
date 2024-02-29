local map = require("utils.keybindings").map
local files = require("mini.files")

files.setup({
	mappings = {
		close = "q",
		go_in = "l",
		go_in_plus = "<CR>",
		go_out = "h",
		go_out_plus = "<BS>",
		reset = "<BS>",
		reveal_cwd = "@",
		show_help = "g?",
		synchronize = "=",
		trim_left = "<",
		trim_right = ">",
	},
})

map({
	key = "<leader>e",
	cmd = function()
		if not files.close() then
			files.open()
		end
	end,
	desc = "Open file explorer",
})

-- toggle dotfiles
local show_dotfiles = true

local filter_show = function()
	return true
end

local filter_hide = function(fs_entry)
	return not vim.startswith(fs_entry.name, ".")
end

local toggle_dotfiles = function()
	show_dotfiles = not show_dotfiles
	local new_filter = show_dotfiles and filter_show or filter_hide
	files.refresh({ content = { filter = new_filter } })
end

vim.api.nvim_create_autocmd("User", {
	pattern = "MiniFilesBufferCreate",
	callback = function(args)
		local buf_id = args.data.buf_id
		vim.keymap.set("n", ".", toggle_dotfiles, { buffer = buf_id })
	end,
})
