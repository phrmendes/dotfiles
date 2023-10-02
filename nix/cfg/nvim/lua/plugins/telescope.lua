local actions = require("telescope.actions")
local telescope = require("telescope")
local themes = require("telescope.themes")
local undo_actions = require("telescope-undo.actions")
local references = os.getenv("REFERENCES") or vim.fn.expand("~/.references.bib")
local utils = require("utils")

telescope.setup({
	defaults = {
		hidden = true,
		layout_strategy = "vertical",
		layout_config = {
			height = utils.round(vim.o.lines * 0.8),
			width = utils.round(vim.o.columns * 0.5),
            preview_height = 0.3,
			prompt_position = "bottom",
		},
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
		buffers = { previewer = false },
		current_buffer_fuzzy_find = { previewer = false },
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
