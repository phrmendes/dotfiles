local actions = require("telescope.actions")
local telescope = require("telescope")

telescope.setup({
	defaults = {
		hidden = true,
		prompt_prefix = "  ",
		selection_caret = "  ",
		entry_prefix = "  ",
		layout_strategy = "vertical",
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
				["<c-j>"] = actions.cycle_history_next,
				["<c-k>"] = actions.cycle_history_prev,
				["<c-d>"] = actions.preview_scrolling_down,
				["<c-u>"] = actions.preview_scrolling_up,
				["<c-n>"] = actions.move_selection_next,
				["<c-p>"] = actions.move_selection_previous,
				["<c-s>"] = actions.file_split,
				["<c-v>"] = actions.file_vsplit,
				["<c-c>"] = actions.close,
				["<c-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
				["<c-x>"] = actions.delete_buffer + actions.move_to_top,
			},
			n = {
				["<c-d>"] = actions.preview_scrolling_down,
				["<c-n>"] = actions.cycle_history_next,
				["<c-p>"] = actions.cycle_history_prev,
				["<c-u>"] = actions.preview_scrolling_up,
				["j"] = actions.move_selection_next,
				["k"] = actions.move_selection_previous,
				["q"] = actions.close,
				["s"] = actions.file_vsplit,
				["v"] = actions.file_split,
				["x"] = actions.delete_buffer,
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
	},
})

local extensions = {
	"dap",
	"fzf",
	"rest",
	"zoxide",
}

if vim.fn.has("mac") == 0 then
	table.insert(extensions, "zotero")
end

for _, ext in ipairs(extensions) do
	telescope.load_extension(ext)
end
