local obsidian = require("obsidian")
local utils = require("core.utils")
local map = vim.keymap.set
local notes = os.getenv("NOTES") or vim.fn.expand("~/Documents/notes")

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

map("n", "<Leader>o<space>", "<cmd>ObsidianSearch<cr>", { desc = "Search" })
map("n", "<Leader>ob", "<cmd>ObsidianBacklinks<cr>", { desc = "Backlinks" })
map("n", "<Leader>od", "<cmd>ObsidianToday<cr>", { desc = "Diary (today)" })
map("n", "<Leader>of", "<cmd>ObsidianFollowLink<cr>", { desc = "Follow link under cursor" })
map("n", "<Leader>oo", "<cmd>ObsidianOpen<cr>", { desc = "Open Obsidian" })
map("n", "<Leader>os", "<cmd>ObsidianQuickSwitch<cr>", { desc = "Quick switch to another note" })
