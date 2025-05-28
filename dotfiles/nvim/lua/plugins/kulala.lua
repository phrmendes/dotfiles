local ft = { "http", "rest" }

return {
	"mistweaverco/kulala.nvim",
	ft = ft,
	opts = {
		ui = {
			formatter = true,
			icons = {
				inlay = {
					done = "",
					error = "󰅚",
					loading = "",
				},
			},
		},
		kulala_keymaps = {
			["show headers"] = { "H", function() require("kulala.ui").show_headers() end },
		},
	},
	config = function(_, opts)
		require("kulala").setup(opts)

		vim.api.nvim_create_autocmd("FileType", {
			desc = "Hide kulala buffer",
			group = vim.api.nvim_create_augroup("UserKulalaFileType", { clear = true }),
			pattern = "*kulala_ui",
			callback = function() vim.opt_local.buflisted = false end,
		})
	end,
	keys = {
		{ "<leader>k", "", desc = "+kulala" },
		{ "<leader>ks", function() require("kulala").scratchpad() end, desc = "Scratchpad" },
		{ "<leader>kS", function() require("kulala").show_stats() end, desc = "Statistics", ft = ft },
		{ "<leader>kc", function() require("kulala").copy() end, desc = "Copy as a curl command", ft = ft },
		{ "<leader>ki", function() require("kulala").inspect() end, desc = "Inspect", ft = ft },
		{ "<leader>kr", function() require("kulala").replay() end, desc = "Replay", ft = ft },
		{ "<leader>kq", function() require("kulala").close() end, desc = "Close", ft = ft },
		{ "<leader>kk", function() require("kulala").run() end, mode = { "n", "x" }, desc = "Send", ft = ft },
		{
			"<leader>kf",
			function() require("kulala").from_curl() end,
			desc = "Paste curl from clipboard",
			ft = "http",
		},
		{
			"<leader>ka",
			function() require("kulala").run_all() end,
			desc = "Send all",
			ft = "http",
			mode = { "n", "x" },
		},
		{
			"<leader>kt",
			function() require("kulala").toggle_view() end,
			desc = "Toggle between body and headers",
			ft = "http",
		},
	},
}
