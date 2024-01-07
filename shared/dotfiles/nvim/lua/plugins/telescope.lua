local actions = require("telescope.actions")
local telescope = require("telescope")
local trouble = require("trouble.providers.telescope")
local map = require("utils").map

telescope.setup({
	defaults = {
		hidden = true,
		layout_strategy = "vertical",
		prompt_prefix = "   ",
		selection_caret = "  ",
		entry_prefix = "  ",
		vimgrep_arguments = {
			"rg",
			"--color=never",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
			"--smart-case",
			"--hidden",
			"--glob=!.git/",
		},
		mappings = {
			i = {
				["<C-S-n>"] = actions.cycle_history_next,
				["<C-S-p>"] = actions.cycle_history_prev,
				["<C-d>"] = actions.preview_scrolling_down,
				["<C-n>"] = actions.move_selection_next,
				["<C-p>"] = actions.move_selection_previous,
				["<C-q>"] = actions.close,
				["<C-s>"] = actions.file_split,
				["<C-t>"] = trouble.open_with_trouble,
				["<C-u>"] = actions.preview_scrolling_up,
				["<C-v>"] = actions.file_vsplit,
				["<C-x>"] = actions.delete_buffer,
			},
			n = {
				["<C-d>"] = actions.preview_scrolling_down,
				["<C-n>"] = actions.cycle_history_next,
				["<C-p>"] = actions.cycle_history_prev,
				["<C-u>"] = actions.preview_scrolling_up,
				["j"] = actions.move_selection_next,
				["k"] = actions.move_selection_previous,
				["q"] = actions.close,
				["s"] = actions.file_vsplit,
				["t"] = trouble.open_with_trouble,
				["v"] = actions.file_split,
				["x"] = actions.delete_buffer,
			},
		},
	},
	pickers = {
		buffers = { theme = "dropdown", previewer = false },
		current_buffer_fuzzy_find = { theme = "dropdown", previewer = false, winblend = 10 },
		find_files = { theme = "dropdown", previewer = false },
		git_branches = { theme = "dropdown", previewer = false },
	},
	extensions = {
		fzf = {
			fuzzy = true,
			override_generic_sorter = true,
			override_file_sorter = true,
			case_mode = "smart_case",
		},
	},
})

local extensions = {
	"frecency",
	"fzf",
	"lazygit",
	"zoxide",
}

for _, ext in ipairs(extensions) do
	telescope.load_extension(ext)
end

map({
	key = "<leader>.",
	command = "<cmd>Telescope commands<cr>",
	desc = "List commands",
})

map({
	key = "<leader>/",
	command = "<cmd>Telescope current_buffer_fuzzy_find<cr>",
	desc = "Search in current buffer",
})

map({
	key = "<leader>?",
	command = "<cmd>Telescope help_tags<cr>",
	desc = "Help",
})

map({
	key = "<leader>bb",
	command = "<cmd>Telescope buffers<cr>",
	desc = "List",
})

map({
	key = "<leader>ff",
	command = "<cmd>Telescope find_files<cr>",
	desc = "Find",
})

map({
	key = "<leader>fg",
	command = "<cmd>Telescope live_grep<cr>",
	desc = "Live grep",
})

map({
	key = "<leader>fr",
	command = "<cmd>Telescope frecency<cr>",
	desc = "Recent files",
})

map({
	key = "<leader>fz",
	command = "<cmd>Telescope zoxide list<cr>",
	desc = "Zoxide",
})
