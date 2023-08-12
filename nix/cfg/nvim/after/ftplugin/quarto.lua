local setup, which_key = pcall(require, "which-key")
if not setup then
	return
end

local normal_opts = {
	mode = "n",
	prefix = "<leader>",
	buffer = nil,
	silent = true,
	noremap = true,
	nowait = false,
}

local normal_mappings = {
	Q = {
		name = "+quarto",
		a = { "<cmd>QuartoActivate<cr>", "Activate" },
		p = { "<cmd>lua require('quarto').quartoPreview()<cr>", "Preview" },
		q = { "<cmd>lua require('quarto').quartoClosePreview()<cr>", "Close" },
	},
}

which_key.register(normal_mappings, normal_opts)
