local home = vim.env.HOME

require("chatgpt").setup({
	api_key_cmd = "gpg --decrypt " .. home .. "/.openai_api_key.gpg",
})
