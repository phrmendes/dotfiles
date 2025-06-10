MiniDeps.now(
	function()
		require("mini.base16").setup({
			palette = require("nix.base16").palette,
			use_cterm = true,
		})
	end
)
