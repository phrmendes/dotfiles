local actions = require("telescope.actions")
local telescope = require("telescope")
local trouble = require("trouble.providers.telescope")
local undo_actions = require("telescope-undo.actions")
local map = require("utils").map

telescope.setup({
	defaults = {
		hidden = true,
		layout_strategy = "vertical",
		prompt_prefix = " ",
		selection_caret = " ",
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
				["<C-d>"] = actions.preview_scrolling_down,
				["<C-u>"] = actions.preview_scrolling_up,
				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,
				["<C-n>"] = actions.cycle_history_next,
				["<C-p>"] = actions.cycle_history_prev,
				["<C-q>"] = actions.close,
				["<C-t>"] = trouble.open_with_trouble,
			},
			n = {
				["j"] = actions.move_selection_next,
				["k"] = actions.move_selection_previous,
				["q"] = actions.close,
				["t"] = trouble.open_with_trouble,
				["<C-d>"] = actions.preview_scrolling_down,
				["<C-u>"] = actions.preview_scrolling_up,
				["<C-n>"] = actions.cycle_history_next,
				["<C-p>"] = actions.cycle_history_prev,
			},
		},
	},
	pickers = {
		current_buffer_fuzzy_find = { previewer = false },
		find_files = { previewer = false },
		git_branches = { previewer = false },
		buffers = {
			previewer = false,
			i = { ["<C-d>"] = actions.delete_buffer },
			n = { ["dd"] = actions.delete_buffer },
		},
	},
	extensions = {
		fzf = {
			fuzzy = true,
			override_generic_sorter = true,
			override_file_sorter = true,
			case_mode = "smart_case",
		},
		undo = {
			side_by_side = true,
			layout_config = { preview_height = 0.6 },
			mappings = {
				i = {
					["<C-y>"] = undo_actions.yank_additions,
					["<C-Y>"] = undo_actions.yank_deletions,
					["<CR>"] = undo_actions.restore,
				},
				n = {
					["y"] = undo_actions.yank_additions,
					["Y"] = undo_actions.yank_deletions,
					["<CR>"] = undo_actions.restore,
				},
			},
		},
	},
})

local extensions = {
	"fzf",
	"lazygit",
	"undo",
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
	command = "<cmd>Telescope oldfiles<cr>",
	desc = "Recent files",
})

map({
	key = "<leader>fz",
	command = "<cmd>Telescope zoxide list<cr>",
	desc = "Zoxide",
})

map({
	key = "<leader>gB",
	command = "<cmd>Telescope git_branches<cr>",
	desc = "Branches",
})

map({
	key = "<leader>gD",
	command = "<cmd>Telescope git_status<cr>",
	desc = "Diff (repo)",
})

map({
	key = "<leader>u",
	command = "<cmd>Telescope undo<cr>",
	desc = "Toggle undo tree",
})
