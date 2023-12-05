local obsidian = require("obsidian")
local utils = require("core.utils")

local map = vim.keymap.set

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
			opts = { buffer = 0 },
		},
	},
})

require("which-key").register({
	mode = "n",
	["<leader>o"] = { name = "obsidian" },
})

map("n", "<leader>ob<cr>", "<cmd>ObsidianBacklinks<cr>", { desc = "Backlinks" })
map("n", "<leader>od<cr>", "<cmd>ObsidianToday<cr>", { desc = "Diary (today)" })
map("n", "<leader>of<cr>", "<cmd>ObsidianFollowLink<cr>", { desc = "Follow link under cursor" })
map("n", "<leader>oo<cr>", "<cmd>ObsidianOpen<cr>", { desc = "Open Obsidian" })
map("n", "<leader>op<cr>", "<cmd>ObsidianPasteImg<cr>", { desc = "Paste image" })
map("n", "<leader>os<cr>", "<cmd>ObsidianQuickSwitch<cr>", { desc = "Quick switch to another note" })
