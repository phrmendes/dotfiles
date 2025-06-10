local autocmd = vim.api.nvim_create_autocmd
local map = vim.keymap.set

MiniDeps.now(function()
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

	autocmd("User", {
		desc = "LSP-aware file renaming",
		pattern = "MiniFilesActionRename",
		callback = function(event) Snacks.rename.on_rename_file(event.data.from, event.data.to) end,
	})

	autocmd("User", {
		desc = "Set border for mini.files window",
		pattern = "MiniFilesWindowOpen",
		callback = function(event) vim.api.nvim_win_set_config(event.data.win_id, { border = vim.g.border }) end,
	})

	autocmd("User", {
		desc = "Set mini.files keybindings",
		pattern = "MiniFilesBufferCreate",
		callback = function(event)
			local opts = { noremap = true, buffer = event.data.buf_id }

			opts.desc = "Toggle dotfiles"
			map("n", ".", function() require("helpers.mini").files.toggle_dotfiles() end, opts)

			opts.desc = "Open file"
			map("n", "go", function() require("helpers.mini").files.open_file() end, opts)

			opts.desc = "Set current workdir"
			map("n", "g.", function() require("helpers.mini").files.set_cwd() end, opts)

			opts.desc = "Open file in horizontal split"
			map("n", "-", require("helpers.mini").files.split("horizontal", true), opts)

			opts.desc = "Open file in vertical split"
			map("n", "\\", require("helpers.mini").files.split("vertical", true), opts)

			opts.desc = "Search with grug-far.nvim"
			vim.keymap.set("n", "gs", function() require("helpers.mini").files.grug_far_replace() end, opts)
		end,
	})
end)
