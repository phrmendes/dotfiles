local obsidian = require("obsidian")
local notes = os.getenv("NOTES") or vim.fn.expand("~/Documents/notes")
local normalize = require("utils").normalize

obsidian.setup({
	dir = notes,
	finder = "telescope.nvim",
	open_notes_in = "current",
	overwrite_mappings = true,
	sort_by = "modified",
	sort_reversed = true,
	disable_frontmatter = true,
	note_id_func = function(title)
		title = title:gsub(" ", "_"):lower()
		return normalize(title)
	end,
	daily_notes = {
		alias_format = "%Y-%m-%d",
		date_format = "%Y-%m-%d",
		folder = "daily",
	},
	templates = {
		date_format = "%Y-%m-%d",
		subdir = "templates",
		time_format = "%H:%M",
	},
	completion = {
		min_chars = 2,
		new_notes_location = "notes_subdir",
		nvim_cmp = true,
		prepend_note_id = false,
	},
	mappings = {
		["gf"] = {
			action = function()
				return obsidian.util.gf_passthrough()
			end,
			opts = { noremap = false, expr = true, buffer = true },
		},
	},
})
