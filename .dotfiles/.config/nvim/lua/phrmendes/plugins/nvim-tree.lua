local g = vim.g
local fn = vim.fn
local cmd = vim.cmd
local api = vim.api
local bo = vim.bo

local setup, nvim_tree = pcall(require, "nvim-tree")
if not setup then
	return
end

g.loaded_netrw = 1
g.loaded_netrwPlugin = 1

nvim_tree.setup({
	renderer = {
		icons = {
			glyphs = {
				folder = {
					arrow_closed = "", -- arrow when folder is closed
					arrow_open = "", -- arrow when folder is open
				},
			},
		},
	},
	-- disable window_picker
	actions = {
		open_file = {
			window_picker = {
				enable = false,
			},
		},
	},
})

-- open nvim-tree on setup
local function open_nvim_tree(data)
	-- buffer is a [No Name]
	local no_name = data.file == "" and bo[data.buf].buftype == ""
	-- buffer is a directory
	local directory = fn.isdirectory(data.file) == 1
	if not no_name and not directory then
		return
	end

	-- change to the directory
	if directory then
		cmd.cd(data.file)
	end

	-- open the tree
	require("nvim-tree.api").tree.open()
end

api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })
