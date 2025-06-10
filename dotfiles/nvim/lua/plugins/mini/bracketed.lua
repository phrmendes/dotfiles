MiniDeps.now(
	function()
		require("mini.bracketed").setup({
			file = { suffix = "" },
			comment = { suffix = "" },
			diagnostic = { options = { float = false } },
		})
	end
)
