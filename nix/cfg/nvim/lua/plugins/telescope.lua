local actions = require("telescope.actions")
local telescope = require("telescope")
local themes = require("telescope.themes")
local references = os.getenv("REFERENCES") or vim.fn.expand("~/.references.bib")

telescope.setup({
	defaults = {
		hidden = true,
		layout_strategy = "vertical",
		mappings = {
			i = {
				["<C-n>"] = actions.move_selection_next,
				["<C-p>"] = actions.move_selection_previous,
				["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
			},
		},
	},
	pickers = {
		find_files = {
			find_command = { "rg", "--files", "--hidden", "--glob", "!.git" },
			previewer = false,
		},
		buffers = {
			previewer = false,
			theme = "dropdown",
		},
		current_buffer_fuzzy_find = {
			previewer = false,
			theme = "dropdown",
		},
		git_branches = { previewer = false },
		commands = { previewer = false },
		help_tags = { previewer = false },
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
	},
})

-- load extensions
local extensions = {
	"fzy_native",
	"ui-select",
	"zoxide",
	"dap",
	"bibtex",
}

for _, ext in ipairs(extensions) do
	telescope.load_extension(ext)
end
