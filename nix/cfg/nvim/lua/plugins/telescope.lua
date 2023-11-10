local actions = require("telescope.actions")
local telescope = require("telescope")
local themes = require("telescope.themes")
local references = os.getenv("REFERENCES") or vim.fn.expand("~/.references.bib")
local trouble_telescope = require("trouble.providers.telescope")

local open_with_trouble = function(...)
	return trouble_telescope.open_with_trouble(...)
end
local open_selected_with_trouble = function(...)
	return trouble_telescope.open_selected_with_trouble(...)
end

telescope.setup({
	defaults = {
		hidden = true,
		layout_strategy = "vertical",
		prompt_prefix = " ",
		selection_caret = " ",
		mappings = {
			i = {
				["<C-u>"] = false,
				["<C-d>"] = false,
				["<C-Down>"] = actions.cycle_history_next,
				["<C-Up>"] = actions.cycle_history_prev,
				["<C-b>"] = actions.preview_scrolling_up,
				["<C-f>"] = actions.preview_scrolling_down,
				["<C-n>"] = actions.move_selection_next,
				["<C-p>"] = actions.move_selection_previous,
				["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
				["<a-t>"] = open_selected_with_trouble,
				["<c-t>"] = open_with_trouble,
			},
			n = {
				["q"] = actions.close,
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
	"bibtex",
	"dap",
	"fzy_native",
	"ui-select",
	"zoxide",
}

for _, ext in ipairs(extensions) do
	telescope.load_extension(ext)
end
