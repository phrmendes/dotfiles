local obsidian = require("obsidian")
local utils = require("utils")

local map = require("utils").map
local section = require("utils").section

local id = function(title)
	return utils.normalize(title)
end

local metadata = function(note)
	local out = { aliases = note.aliases, tags = note.tags }
	if note.metadata ~= nil and obsidian.util.table_length(note.metadata) > 0 then
		for k, v in pairs(note.metadata) do
			out[k] = v
		end
	end

	return out
end

obsidian.setup({
	attachments = { img_folder = "assets" },
	completion = {
		new_notes_location = "notes_subdir",
		nvim_cmp = true,
		prepend_note_id = true,
	},
	daily_notes = {
		alias_format = "%Y-%m-%d",
		date_format = "%Y-%m-%d",
		folder = "daily",
	},
	dir = vim.fn.expand("~/Documents/notes"),
	finder = "telescope.nvim",
	note_frontmatter_func = metadata,
	note_id_func = id,
	open_notes_in = "current",
	sort_by = "modified",
	sort_reversed = true,
	templates = {
		date_format = "%Y-%m-%d",
		subdir = "templates",
		time_format = "%H:%M",
	},
	mappings = {
		["gf"] = {
			action = function()
				return obsidian.util.gf_passthrough()
			end,
			opts = { noremap = false, expr = true, buffer = 0 },
		},
		["<C-CR>"] = {
			action = function()
				return obsidian.util.toggle_checkbox()
			end,
			opts = { buffer = true },
		},
	},
})

section({
	key = "<leader>o",
	name = "obsidian",
})

map({
	key = "<leader>ob",
	command = "<cmd>ObsidianBacklinks<cr>",
	desc = "Backlinks",
})

map({
	key = "<leader>od",
	command = "<cmd>ObsidianToday<cr>",
	desc = "Diary (today)",
})

map({
	key = "<leader>of",
	command = "<cmd>ObsidianFollowLink<cr>",
	desc = "Follow link under cursor",
})

map({
	key = "<leader>oo",
	command = "<cmd>ObsidianOpen<cr>",
	desc = "Open Obsidian",
})

map({
	key = "<leader>op",
	command = "<cmd>ObsidianPasteImg<cr>",
	desc = "Paste image",
})

map({
	key = "<leader>os",
	command = "<cmd>ObsidianQuickSwitch<cr>",
	desc = "Quick switch to another note",
})
