require("mini.files").setup({
	mappings = {
		close = "q",
		go_in = "l",
		go_in_plus = "<cr>",
		go_out = "h",
		go_out_plus = "<bs>",
		reset = "<del>",
		reveal_cwd = "@",
		show_help = "?",
		synchronize = "=",
		trim_left = "<",
		trim_right = ">",
	},
})

vim.g.mini_show_dotfiles = true

vim.api.nvim_create_autocmd("User", {
	desc = "LSP-aware file renaming",
	pattern = "MiniFilesActionRename",
	callback = function(event) Snacks.rename.on_rename_file(event.data.from, event.data.to) end,
})

vim.api.nvim_create_autocmd("User", {
	desc = "Set border for mini.files window",
	pattern = "MiniFilesWindowOpen",
	callback = function(event) vim.api.nvim_win_set_config(event.data.win_id, { border = require("utils").border }) end,
})

vim.api.nvim_create_autocmd("User", {
	desc = "mini.files keybindings",
	pattern = "MiniFilesBufferCreate",
	callback = function(event)
		local opts = { noremap = true, buffer = event.data.buf_id }

		opts.desc = "Toggle dotfiles"
		vim.keymap.set("n", ".", function()
			local filter_show = function() return true end

			local filter_hide = function(fs_entry) return not vim.startswith(fs_entry.name, ".") end

			vim.g.mini_show_dotfiles = not vim.g.mini_show_dotfiles

			require("mini.files").refresh({
				content = { filter = vim.g.mini_show_dotfiles and filter_show or filter_hide },
			})
		end, opts)

		opts.desc = "Open file"
		vim.keymap.set("n", "go", function()
			local fs_entry = require("mini.files").get_fs_entry()

			if not fs_entry then
				vim.notify("No file selected", vim.log.levels.ERROR, { title = "mini.nvim" })
				return
			end

			vim.schedule(function()
				vim.notify("Opening " .. fs_entry.name, vim.log.levels.INFO, { title = "mini.nvim" })
				vim.ui.open(fs_entry.path)
			end)
		end, opts)

		opts.desc = "Set current workdir"
		vim.keymap.set("n", "g.", function()
			local current_entry_path = require("mini.files").get_fs_entry().path
			local current_directory = vim.fs.dirname(current_entry_path)
			if current_directory ~= nil then vim.fn.chdir(current_directory) end
		end, opts)

		opts.desc = "Open file in horizontal split"
		vim.keymap.set("n", "-", require("utils").mini_files_split("horizontal", true), opts)

		opts.desc = "Open file in vertical split"
		vim.keymap.set("n", "\\", require("utils").mini_files_split("vertical", true), opts)
	end,
})
