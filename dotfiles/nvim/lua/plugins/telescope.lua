local actions = require("telescope.actions")
local telescope = require("telescope")

telescope.setup({
	defaults = require("telescope.themes").get_ivy({
		prompt_prefix = "   ",
		selection_caret = " ",
		mappings = {
			i = {
				["<esc>"] = actions.close,
				["<c-j>"] = actions.cycle_history_next,
				["<c-k>"] = actions.cycle_history_prev,
				["<c-d>"] = actions.preview_scrolling_down,
				["<c-u>"] = actions.preview_scrolling_up,
				["<c-n>"] = actions.move_selection_next,
				["<c-p>"] = actions.move_selection_previous,
				["<c-s>"] = actions.file_split,
				["<c-v>"] = actions.file_vsplit,
				["<c-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
			},
		},
	}),
	pickers = {
		current_buffer_fuzzy_find = {
			previewer = false,
			winblend = 10,
		},
	},
	extensions = {
		fzf = {
			fuzzy = true,
			override_generic_sorter = true,
			override_file_sorter = true,
			case_mode = "smart_case",
		},
		smart_open = {
			cwd_only = true,
			match_algorithm = "fzf",
			filename_first = false,
			ignore_patterns = {
				"*.git/*",
				"*.obsidian/*",
				"*.sync/*",
				"/tmp/*",
			},
		},
	},
})
local extensions = {
	"fzf",
	"lazygit",
	"smart_open",
}
for _, ext in ipairs(extensions) do
	telescope.load_extension(ext)
end
