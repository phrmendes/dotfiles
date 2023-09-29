local obsidian = require("obsidian")
local notes = os.getenv("NOTES")

obsidian.setup({
	dir = notes,
	daily_notes = {
		folder = "diary",
		date_dormat = "%Y-%m-%d",
		alias_format = "%a, %d %b %Y",
	},
	completion = {
		nvim_cmp = true,
		min_chars = 2,
		new_notes_location = "current_dir",
		prepend_note_id = true,
	},
	mappings = {
		["gf"] = {
			action = function()
				return obsidian.util.gf_passthrough()
			end,
			opts = { noremap = false, expr = true, buffer = true },
		},
	},
	overwrite_mappings = true,
	finder = "telescope.nvim",
	open_notes_in = "current",
	sort_by = "modified",
	sort_reversed = true,
})
