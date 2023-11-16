local actions = require("telescope.actions")
local telescope = require("telescope")
local themes = require("telescope.themes")
local references = os.getenv("REFERENCES") or vim.fn.expand("~/.references.bib")
local fuzzy = require("mini.fuzzy")

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
				["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
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
		bibtex = {
			global_files = { references },
		},
	},
})

local extensions = {
	"bibtex",
	"ui-select",
	"zoxide",
}

for _, ext in ipairs(extensions) do
	telescope.load_extension(ext)
end

map("n", "<Leader>.", "<cmd>Telescope commands<cr>", { desc = "List commands" })
map("n", "<Leader>/", "<cmd>Telescope current_buffer_fuzzy_find<cr>", { desc = "Search in current buffer" })
map("n", "<Leader><space>", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
map("n", "<Leader>bb", "<cmd>Telescope buffers<cr>", { desc = "List" })
map("n", "<Leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live grep" })
map("n", "<Leader>fz", "<cmd>Telescope zoxite list<cr>", { desc = "Zoxide" })
map("n", "<Leader>h", "<cmd>Telescope help_tags<cr>", { desc = "Help" })
