local quarto = require("quarto")
local wk = require("which-key")

local localleader = {
    normal = {
        options = {
            mode = "n",
            prefix = "<localleader>",
            buffer = nil,
            silent = true,
            noremap = true,
            nowait = false,
        },
        mappings = {
            b = { "<cmd>Telescope bibtex<cr>", "Insert bibliography" },
        },
    },
}

quarto.setup({
    closePreviewOnExit = true,
    lspFeatures = {
        enabled = true,
        languages = { "python" },
        chunks = "curly",
        diagnostics = {
            enabled = true,
            triggers = { "BufWritePost" },
        },
        completion = {
            enabled = true,
        },
    },
})

wk.register(localleader.normal.mappings, localleader.normal.options)
