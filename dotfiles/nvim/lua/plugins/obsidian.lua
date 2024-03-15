local obsidian = require("obsidian")
local utils = require("utils")

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
	mappings = {
		["gf"] = {
			action = obsidian.util.gf_passthrough,
			opts = { noremap = false, expr = true, buffer = 0 },
		},
	},
})
