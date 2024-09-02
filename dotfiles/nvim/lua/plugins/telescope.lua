local actions = require("telescope.actions")
local telescope = require("telescope")

telescope.setup({
	defaults = {
		hidden = true,
		prompt_prefix = "   ",
		selection_caret = "  ",
		layout_strategy = "vertical",
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
	},
	pickers = {
		buffers = { theme = "dropdown", previewer = false },
		current_buffer_fuzzy_find = { theme = "dropdown", previewer = false, winblend = 10 },
		git_branches = { theme = "dropdown", previewer = false },
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
	"smart_open",
}

for _, ext in ipairs(extensions) do
	telescope.load_extension(ext)
end
