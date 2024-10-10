local obsidian = require("obsidian")
local utils = require("utils")

obsidian.setup({
	follow_url_func = utils.open,
	follow_img_func = utils.open,
	preferred_link_style = "wiki",
	attachments = { img_folder = "assets" },
	workspaces = {
		{
			name = "personal",
			path = vim.env.NOTES_PATH or vim.env.HOME .. "/Documents/notes",
		},
	},
	mappings = {
		["<cr>"] = {
			action = function()
				return obsidian.util.smart_action()
			end,
			opts = { buffer = true, expr = true },
		},
	},
	image_name_func = utils.image_name,
	note_id_func = utils.note_id,
	note_frontmatter_func = utils.note_frontmatter,
	ui = {
		checkboxes = {
			[" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
			[">"] = { char = "", hl_group = "ObsidianRightArrow" },
			["x"] = { char = "", hl_group = "ObsidianDone" },
		},
	},
})
