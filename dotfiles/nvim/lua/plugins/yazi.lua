require("yazi").setup({
	open_for_directories = true,
	open_multiple_tabs = true,
	keymaps = {
		show_help = "<f1>",
		open_file_in_vertical_split = "<c-v>",
		open_file_in_horizontal_split = "<c-s>",
		open_file_in_tab = "<c-t>",
		grep_in_directory = "<c-f>",
		replace_in_directory = "<c-g>",
		cycle_open_buffers = "<tab>",
		copy_relative_path_to_selected_files = "<c-y>",
		send_to_quickfix_list = "<c-q>",
		change_working_directory = "<c-\\>",
	},
	integrations = {
		grep_in_directory = function(directory)
			print("directory:", directory)
			require("mini.pick").builtin.grep_live({ globs = vim.fn.readdir(directory) }, { source = { name = "Yazi" } })
		end,
		grep_in_selected_files = function(selected_files)
			local files = {}

			for _, f in ipairs(selected_files) do
				table.insert(files, f.filename)
			end

			print(vim.inspect(files))

			require("mini.pick").builtin.grep_live(nil, { source = { name = "Yazi", items = files } })
		end,
	},
})
