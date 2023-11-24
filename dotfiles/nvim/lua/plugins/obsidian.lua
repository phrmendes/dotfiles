local obsidian = require("obsidian")
local utils = require("core.utils")
local notes = os.getenv("NOTES") or vim.fn.expand("~/Documents/notes")
local wk = require("which-key")

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
	dir = notes,
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
			opts = { noremap = false, expr = true, buffer = true },
		},
		["<C-CR>"] = {
			action = function()
				return obsidian.util.toggle_checkbox()
			end,
			opts = { buffer = true },
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
	p = { "<cmd>ObsidianPasteImg<cr>", "Paste image" },
}, { prefix = "<leader>o", mode = "n" })
