local telescope = require("telescope")
local actions = require("telescope.actions")
local themes = require("telescope.themes")
local notes = os.getenv("NOTES_DIR")

telescope.setup({
	defaults = {
		hidden = true,
		mappings = {
			i = {
				["<C-n>"] = actions.move_selection_next, -- move to next result
				["<C-p>"] = actions.move_selection_previous, -- move to prev result
				["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist, -- send selected to quickfixlist
			},
		},
	},
	extensions = {
		["ui-select"] = { themes.get_dropdown() },
		["fzy_native"] = {
			override_generic_sorter = false,
			override_file_sorter = true,
		},
		bibtex = {
			global_files = { notes .. "/references.bib" },
		},
	},
})

-- load extensions
local extensions = { "bibtex", "fzy_native", "ui-select", "zoxide" }

for _, ext in ipairs(extensions) do
	telescope.load_extension(ext)
end
