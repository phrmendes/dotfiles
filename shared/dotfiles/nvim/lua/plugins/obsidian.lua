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

local follow_url = function(url)
	vim.fn.jobstart({ "xdg-open", url })
end

obsidian.setup({
	dir = vim.fn.expand("~/Documents/notes"),
	finder = "telescope.nvim",
	follow_url_func = follow_url,
	note_frontmatter_func = metadata,
	note_id_func = id,
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
	daily_notes = {
		folder = "log",
		date_format = "%d-%m-%Y",
		alias_format = "%d-%m-%Y",
		template = "log.md",
	},
	templates = {
		subdir = "templates",
		date_format = "%d-%m-%Y",
		time_format = "%H:%M",
	},
	mappings = {
		["gf"] = {
			action = obsidian.util.gf_passthrough,
			opts = { noremap = false, expr = true, buffer = 0 },
		},
		["<C-CR>"] = {
			action = obsidian.util.toggle_checkbox,
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
	key = "<leader>os",
	command = "<cmd>ObsidianQuickSwitch<cr>",
	desc = "Quick switch to another note",
})
