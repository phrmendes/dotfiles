local actions = require("telescope.actions")
local telescope = require("telescope")
local trouble = require("trouble.providers.telescope")
local map = require("utils").map

telescope.setup({
	defaults = {
		hidden = true,
		layout_strategy = "vertical",
		prompt_prefix = " ",
		selection_caret = " ",
		mappings = {
			i = {
				["<C-c>"] = actions.close,
				["<C-u>"] = actions.preview_scrolling_up,
				["<C-d>"] = actions.preview_scrolling_down,
				["<C-n>"] = actions.move_selection_next,
				["<C-p>"] = actions.move_selection_previous,
				["<C-q>"] = trouble.open_with_trouble,
			},
			n = {
				["<C-c>"] = actions.close,
				["<C-q>"] = trouble.open_with_trouble,
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
		fzf = {
			fuzzy = true,
			override_generic_sorter = true,
			override_file_sorter = true,
			case_mode = "smart_case",
		},
	},
})

local extensions = {
	"zoxide",
	"lazygit",
	"fzf",
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
	command = "<cmd>Telescope oldfiles<cr>",
	desc = "Recent files",
})

map({
	key = "<leader>fz",
	command = "<cmd>Telescope zoxide list<cr>",
	desc = "Zoxide",
})
