require("image").setup({
	backend = "kitty",
	integrations = {
		markdown = {
			filetypes = { "markdown", "quarto" },
		},
	},
})

require("img-clip").setup({
	default = {
		dir_path = function()
			return vim.fn.expand("%:h") .. "/assets"
		end,
		extension = "png",
		file_name = function()
			return os.date("%Y%m%d") .. os.time() .. "-" .. vim.fn.expand("%:t:r") .. "-"
		end,
		use_absolute_path = false,
		relative_to_current_file = true,
		prompt_for_file_name = true,
		show_dir_path_in_prompt = true,
		drag_and_drop = {
			enabled = true,
			insert_mode = true,
		},
	},
	filetypes = {
		markdown = {
			url_encode_path = true,
			template = "![$CURSOR]($FILE_PATH)",
			download_images = true,
		},
		quarto = {
			url_encode_path = true,
			template = "![$CURSOR]($FILE_PATH)",
			download_images = true,
		},
	},
})
