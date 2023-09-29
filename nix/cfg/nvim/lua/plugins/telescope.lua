local actions = require("telescope.actions")
local telescope = require("telescope")
local themes = require("telescope.themes")
local undo_actions = require("telescope-undo.actions")
local references = os.getenv("REFERENCES")

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
			global_files = { references },
		},
		undo = {
			mappings = {
				i = {
					["<C-CR>"] = undo_actions.yank_additions,
					["<S-CR>"] = undo_actions.yank_deletions,
					["<CR>"] = undo_actions.restore,
				},
			},
		},
	},
})

-- load extensions
local extensions = {
	"bibtex",
	"fzy_native",
	"ui-select",
	"zoxide",
	"undo",
	"dap",
}

for _, ext in ipairs(extensions) do
	telescope.load_extension(ext)
end
