local utils = require("utils")

utils.map({
	key = "<leader>gcr",
	command = "<cmd>LazyGitFilter<cr>",
	desc = "Repository",
})

utils.map({
	key = "<leader>gcf",
	command = "<cmd>LazyGitFilterCurrentFile<cr>",
	desc = "File",
})

utils.map({
	key = "<leader>gg",
	command = "<cmd>LazyGit<cr>",
	desc = "LazyGit",
})

utils.map({
	key = "<leader>gl",
	command = "<cmd>Telescope lazygit<cr>",
	desc = "List repos",
})
