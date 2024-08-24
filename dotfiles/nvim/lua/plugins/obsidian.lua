local obsidian = require("obsidian")
local utils = require("utils")

obsidian.setup({
	follow_url_func = utils.open,
	follow_img_func = utils.open,
	preferred_link_style = "wiki",
	attachments = { img_folder = "assets" },
	picker = {
		name = "mini.pick",
	},
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
	image_name_func = function()
		local prefix = os.date("%Y%m%d%H%M%S")
		local suffix = vim.fn.expand("%:p:t:r")

		return prefix .. "-" .. suffix .. "-"
	end,
	note_id_func = function(title)
		local prefix = os.date("%Y%m%d%H%M%S")
		local suffix = utils.normalize(title)

		return prefix .. "-" .. suffix
	end,
	note_frontmatter_func = function(note)
		if note.title then
			note:add_alias(note.title)
		end

		local header = {
			id = note.id,
			aliases = note.aliases,
			tags = note.tags,
		}

		if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
			for k, v in pairs(note.metadata) do
				header[k] = v
			end
		end

		return header
	end,
	ui = {
		checkboxes = {
			[" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
			["x"] = { char = "", hl_group = "ObsidianDone" },
		},
	},
})
