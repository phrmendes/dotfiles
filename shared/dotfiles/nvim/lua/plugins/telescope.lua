local actions = require("telescope.actions")
local telescope = require("telescope")
local trouble = require("trouble.providers.telescope")
local map = require("utils").map

telescope.setup({
	defaults = {
		hidden = true,
		prompt_prefix = "  ",
		selection_caret = "  ",
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
				["<C-n>"] = actions.cycle_history_next,
				["<C-p>"] = actions.cycle_history_prev,
				["<C-d>"] = actions.preview_scrolling_down,
				["<C-u>"] = actions.preview_scrolling_up,
				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,
				["<C-s>"] = actions.file_split,
				["<C-v>"] = actions.file_vsplit,
				["<C-c>"] = actions.close,
				["<C-t>"] = trouble.open_with_trouble,
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
		find_files = { layout_strategy = "horizontal" },
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
	"fzf",
	"lazygit",
	"zoxide",
}

for _, ext in ipairs(extensions) do
	telescope.load_extension(ext)
end

map({
	key = "<leader>.",
	cmd = "<CMD>Telescope commands<CR>",
	desc = "List commands",
})

map({
	key = "<leader>?",
	cmd = "<CMD>Telescope help_tags<CR>",
	desc = "Help",
})

map({
	key = "<leader>bb",
	cmd = "<CMD>Telescope buffers<CR>",
	desc = "List",
})

map({
	key = "<leader>bf",
	cmd = "<CMD>Telescope current_buffer_fuzzy_find<CR>",
	desc = "Search in current buffer",
})

map({
	key = "<leader>ff",
	cmd = "<CMD>Telescope find_files<CR>",
	desc = "Find",
})

map({
	key = "<leader>fg",
	cmd = "<CMD>Telescope live_grep<CR>",
	desc = "Live grep",
})

map({
	key = "<leader>fz",
	cmd = "<CMD>Telescope zoxide list<CR>",
	desc = "Zoxide",
})
