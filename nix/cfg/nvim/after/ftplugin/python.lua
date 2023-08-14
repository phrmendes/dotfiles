local wk = require("which-key")

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
            d = {
                name = "+debugger",
                P = {
                    name = "+python",
                    c = {
                        "<cmd>lua require('dap-python').test_class()<cr>",
                        "Test class",
                    },
                    m = {
                        "<cmd>lua require('dap-python').test_method()<cr>",
                        "Test method",
                    },
                },
            },
        },
    },
    visual = {
        options = {
            mode = "v",
            prefix = "<leader>",
            buffer = nil,
            silent = true,
            noremap = true,
            nowait = false,
        },
        mappings = {
            p = {
                "<cmd>lua require('dap-python').debug_selection()<cr>",
                "DAP - Debug python region",
            },
        },
    },
}

wk.register(leader.normal.mappings, leader.normal.options)
wk.register(leader.visual.mappings, leader.visual.options)
