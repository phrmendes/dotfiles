local home = os.getenv("HOME")
local chatgpt = require("chatgpt")
local wk = require("which-key")

chatgpt.setup({
	api_key_cmd = "gpg --decrypt " .. home .. "/.openai-token.gpg",
})

wk.register({
	name = "IA",
	s = { "<cmd>Copilot panel<cr>", "Copilot: sugestions" },
	S = { "<cmd>ChatGPTRun summarize<cr>", "Summarize" },
	a = { "<cmd>ChatGPTRun add_tests<cr>", "Add tests" },
	c = { "<cmd>ChatGPT<cr>", "ChatGPT" },
	d = { "<cmd>ChatGPTRun docstring<cr>", "Docstring" },
	e = { "<cmd>ChatGPTEditWithInstruction<cr>", "Edit with instruction" },
	f = { "<cmd>ChatGPTRun fix_bugs<cr>", "Fix bugs" },
	g = { "<cmd>ChatGPTRun grammar_correction<cr>", "Grammar correction" },
	k = { "<cmd>ChatGPTRun keywords<cr>", "Keywords" },
	l = { "<cmd>ChatGPTRun code_readability_analysis<cr>", "Code readability analysis" },
	o = { "<cmd>ChatGPTRun optimize_code<cr>", "Optimize code" },
	t = { "<cmd>ChatGPTRun translate<cr>", "Translate" },
	x = { "<cmd>ChatGPTRun explain_code<cr>", "Explain code" },
}, { prefix = "<leader>i", mode = { "n", "x" } })
