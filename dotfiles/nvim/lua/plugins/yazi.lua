require("yazi").setup({
	open_for_directories = true,
	open_multiple_tabs = true,
	keymaps = {
		open_file_in_vertical_split = "<c-v>",
		open_file_in_horizontal_split = "<c-s>",
		grep_in_directory = "<c-f>",
	},
	integrations = {
		grep_in_directory = function(directory)
			require("mini.pick").builtin.grep_live(nil, { source = { name = "Yazi", cwd = directory } })
		end,
		grep_in_selected_files = function(selected_files)
			local files = {}

			for _, f in ipairs(selected_files) do
				table.insert(files, f.filename)
			end

			local dir = vim.fn.fnamemodify(files[1], ":h")

			require("mini.pick").builtin.grep_live({ globs = files }, { source = { name = "Yazi", cwd = dir } })
		end,
	},
})
