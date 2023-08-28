local wk = require("which-key")
local cmd = vim.cmd

local leader = {
    normal = {
        options = {
            mode = "n",
            prefix = "<leader>",
            buffer = nil,
            silent = true,
            noremap = true,
            nowait = false,
        },
        mappings = {
            Q = {
                name = "+quarto",
                m = {
                    function()
                        cmd([[setlocal filetype=markdown]])
                    end,
                    "Markdown filetype",
                },
                q = {
                    function()
                        cmd([[setlocal filetype=quarto]])
                    end,
                    "Quarto filetype",
                },
            },
        },
    },
}

wk.register(leader.normal.mappings, leader.normal.options)
