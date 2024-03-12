local later = require("mini.deps").later
local home = vim.env.HOME

later(function()
	require("chatgpt").setup({
		api_key_cmd = "gpg --decrypt " .. home .. "/.openai_api_key.gpg",
	})
end)
