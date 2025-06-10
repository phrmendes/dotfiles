MiniDeps.later(
	function()
		require("mini.diff").setup({
			view = { style = "sign" },
			signs = { add = "█", change = "▒", delete = "" },
		})
	end
)
