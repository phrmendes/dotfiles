local obsidian = require("obsidian")
local utils = require("core.utils")
local notes = os.getenv("NOTES") or vim.fn.expand("~/Documents/notes")
local wk = require("which-key")

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
		return utils.normalize(title)
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

wk.register({
	name = "obsidian",
	["<space>"] = { "<cmd>ObsidianSearch<cr>", "Search" },
	b = { "<cmd>ObsidianBacklinks<cr>", "Backlinks" },
	d = { "<cmd>ObsidianToday<cr>", "Diary (today)" },
	f = { "<cmd>ObsidianFollowLink<cr>", "Follow link under cursor" },
	o = { "<cmd>ObsidianOpen<cr>", "Open Obsidian" },
	s = { "<cmd>ObsidianQuickSwitch<cr>", "Quick switch to another note" },
}, { prefix = "<leader>o", mode = "n" })
