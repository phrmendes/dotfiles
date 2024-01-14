local obsidian = require("obsidian")
local utils = require("utils")

local map = require("utils").map
local section = require("utils").section

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
	dir = vim.fn.expand("~/Documents/notes"),
	finder = "telescope.nvim",
	follow_url_func = utils.open,
	note_frontmatter_func = metadata,
	note_id_func = utils.normalize,
	open_notes_in = "current",
	sort_by = "modified",
	sort_reversed = true,
	attachments = {
		img_folder = "assets",
	},
	completion = {
		new_notes_location = "notes_subdir",
		nvim_cmp = true,
		prepend_note_id = true,
	},
	mappings = {
		["gf"] = {
			action = obsidian.util.gf_passthrough,
			opts = { noremap = false, expr = true, buffer = 0 },
		},
	},
})

section({
	key = "<leader>o",
	name = "obsidian",
})

map({
	key = "<leader>ob",
	cmd = "<CMD>ObsidianBacklinks<CR>",
	desc = "Backlinks",
})

map({
	key = "<leader>of",
	cmd = "<CMD>ObsidianFollowLink<CR>",
	desc = "Follow link under cursor",
})

map({
	key = "<leader>oo",
	cmd = "<CMD>ObsidianOpen<CR>",
	desc = "Open Obsidian",
})

map({
	key = "<leader>os",
	cmd = "<CMD>ObsidianQuickSwitch<CR>",
	desc = "Quick switch to another note",
})
