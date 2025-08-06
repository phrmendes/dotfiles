MiniDeps.now(function()
	require("mini.files").setup({
		mappings = {
			close = "q",
			go_in = "l",
			go_in_plus = "<cr>",
			go_out = "h",
			go_out_plus = "H",
			reset = "<bs>",
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
		callback = function(event) vim.api.nvim_win_set_config(event.data.win_id, { border = vim.g.border }) end,
	})

	vim.api.nvim_create_autocmd("User", {
		desc = "Set mini.files keybindings",
		pattern = "MiniFilesBufferCreate",
		callback = function(event)
			local opts = { noremap = true, buffer = event.data.buf_id }

			opts.desc = "Toggle dotfiles"
			vim.keymap.set("n", ".", function() require("helpers.mini").files.toggle_dotfiles() end, opts)

			opts.desc = "Open file"
			vim.keymap.set("n", "go", function() require("helpers.mini").files.open_file() end, opts)

			opts.desc = "Open file in horizontal split"
			vim.keymap.set("n", "-", require("helpers.mini").files.split("horizontal", true), opts)

			opts.desc = "Open file in vertical split"
			vim.keymap.set("n", "\\", require("helpers.mini").files.split("vertical", true), opts)

			opts.desc = "Search with grug-far.nvim"
			vim.keymap.set("n", "gs", function() require("helpers.mini").files.grug_far_replace() end, opts)
		end,
	})
end)
