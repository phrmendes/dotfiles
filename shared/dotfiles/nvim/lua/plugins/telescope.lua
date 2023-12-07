local actions = require("telescope.actions")
local fuzzy = require("mini.fuzzy")
local telescope = require("telescope")
local trouble = require("trouble.providers.telescope")

local map = vim.keymap.set

telescope.setup({
	defaults = {
		hidden = true,
		layout_strategy = "vertical",
		prompt_prefix = " ",
		selection_caret = " ",
		generic_sorter = fuzzy.get_telescope_sorter,
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
				["<C-q>"] = trouble.open_with_trouble,
			},
			n = {
				["q"] = actions.close,
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
})

local extensions = {
	"zoxide",
	"lazygit",
}

for _, ext in ipairs(extensions) do
	telescope.load_extension(ext)
end

map("n", "<leader>.", "<cmd>Telescope commands<cr>", { desc = "List commands" })
map("n", "<leader>/", "<cmd>Telescope current_buffer_fuzzy_find<cr>", { desc = "Search in current buffer" })
map("n", "<leader><space>", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
map("n", "<leader>?", "<cmd>Telescope help_tags<cr>", { desc = "Help" })
map("n", "<leader>bb", "<cmd>Telescope buffers<cr>", { desc = "List" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live grep" })
map("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Recent files" })
map("n", "<leader>fz", "<cmd>Telescope zoxide list<cr>", { desc = "Zoxide" })
