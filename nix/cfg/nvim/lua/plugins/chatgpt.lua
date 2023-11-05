local home = os.getenv("HOME")
local chatgpt = require("chatgpt")

chatgpt.setup({
	api_key_cmd = "gpg --decrypt " .. home .. "/.openai-token.gpg",
})
