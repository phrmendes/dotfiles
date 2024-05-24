local obsidian = require("obsidian")
local utils = require("utils")

obsidian.setup({
	dir = vim.fn.expand("~/Documents/notes"),
	finder = "telescope.nvim",
	follow_url_func = utils.open,
	note_id_func = function(title)
		local prefix = os.date("%Y%m%d") .. os.time()
		local suffix = utils.normalize(title)

		return prefix .. "-" .. suffix
	end,
	image_name_func = function()
		local prefix = os.time()
		local suffix = vim.fn.expand("%:p:t:r")

		return prefix .. "-" .. suffix .. "-"
	end,
	note_frontmatter_func = function(note)
		local header = { id = note.id, tags = note.tags }

		if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
			for k, v in pairs(note.metadata) do
				header[k] = v
			end
		end

		return header
	end,
	open_notes_in = "current",
	preferred_link_style = "markdown",
	sort_by = "modified",
	sort_reversed = true,
	attachments = {
		img_folder = "assets",
	},
	mappings = {
		["<CR>"] = {
			action = function()
				return obsidian.util.smart_action()
			end,
			opts = { buffer = true, expr = true },
		},
	},
})
