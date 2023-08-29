local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local wk = require("which-key")

-- which-key configuration
local conf = {
    window = {
        border = "single",
        position = "bottom",
    },
}

-- lsp mappings
local lsp = {
    g = {
        normal = {
            options = {
                mode = "n",
                prefix = "g",
                buffer = nil,
                silent = true,
                noremap = true,
                nowait = false,
            },
            mappings = {
                a = {
                    function()
                        vim.lsp.buf.code_action()
                    end,
                    "LSP - Code action",
                },
                D = {
                    function()
                        vim.lsp.buf.declaration()
                    end,
                    "LSP - Declaration",
                },
                d = { "<cmd>Telescope lsp_definitions<cr>", "LSP - Definitions" },
                h = {
                    function()
                        vim.lsp.buf.hover()
                    end,
                    "LSP - Hover",
                },
                i = { "<cmd>Telescope lsp_implementations<cr>", "LSP - Implementation" },
                r = {
                    function()
                        vim.lsp.buf.rename()
                    end,
                    "LSP - Rename",
                },
                R = { "<cmd>Telescope lsp_references<cr>", "LSP - References" },
                s = {
                    function()
                        vim.lsp.buf.signature_help()
                    end,
                    "LSP - Signature help",
                },
                t = { "<cmd>Telescope lsp_type_definitions<cr>", "LSP - Type definition" },
                f = {
                    name = "+folders (LSP)",
                    a = {
                        function()
                            vim.lsp.buf.add_workspace_folder()
                        end,
                        "Add folder",
                    },
                    r = {
                        function()
                            vim.lsp.buf.remove_workspace_folder()
                        end,
                        "Remove folder",
                    },
                    l = {
                        function()
                            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                        end,
                        "List folders",
                    },
                },
            },
        },
        visual = {
            options = {
                mode = "v",
                prefix = "g",
                buffer = nil,
                silent = true,
                noremap = true,
                nowait = false,
            },
            mappings = {
                a = {
                    function()
                        vim.lsp.buf.code_action()
                    end,
                    "LSP - Code action",
                },
            },
        },
    },
    leader = {
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
                    B = {
                        function()
                            require("dap").step_back()
                        end,
                        "Step back",
                    },
                    c = {
                        function()
                            require("dap").continue()
                        end,
                        "Continue",
                    },
                    i = {
                        function()
                            require("dap").step_into()
                        end,
                        "Step into",
                    },
                    o = {
                        function()
                            require("dap").step_over()
                        end,
                        "Step over",
                    },
                    p = {
                        function()
                            require("dap").pause()
                        end,
                        "Pause",
                    },
                    q = {
                        function()
                            require("dap").close()
                        end,
                        "Quit",
                    },
                    s = {
                        function()
                            require("dap").continue()
                        end,
                        "Start",
                    },
                    t = {
                        function()
                            require("dapui").toggle()
                        end,
                        "Toggle UI",
                    },
                    u = {
                        function()
                            require("dap").step_out()
                        end,
                        "Step out",
                    },
                    b = {
                        function()
                            require("dap").toggle_breakpoint()
                        end,
                        "Toggle breakpoint",
                    },
                    r = {
                        function()
                            require("dapui").open({ reset = true })
                        end,
                        "Reset UI panes",
                    },
                },
                l = {
                    name = "+lsp",
                    c = {
                        function()
                            vim.lsp.codelens.run()
                        end,
                        "CodeLens action",
                    },
                    d = { "<cmd>Telescope diagnostics<cr>", "Diagnostics" },
                    l = {
                        function()
                            vim.diagnostic.setloclist()
                        end,
                        "Loclist",
                    },
                    n = {
                        function()
                            vim.diagnostic.goto_next()
                        end,
                        "Next diagnostic",
                    },
                    o = {
                        function()
                            vim.diagnostic.open_float()
                        end,
                        "Open float",
                    },
                    p = {
                        function()
                            vim.diagnostic.goto_prev()
                        end,
                        "Previous diagnostic",
                    },
                    s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document symbols" },
                    w = {
                        "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
                        "Workspace symbols",
                    },
                },
            },
        },
    },
    local_leader = {
        visual = {
            options = {
                mode = "v",
                prefix = ",",
                buffer = nil,
                silent = true,
                noremap = true,
                nowait = false,
            },
            mappings = {
                e = {
                    function()
                        require("dapui").eval()
                    end,
                    "Debugger - Evaluate",
                },
            },
        },
    },
}

-- local leader mappings
local local_leader = {
    normal = {
        options = {
            mode = "n",
            prefix = ",",
            buffer = nil,
            silent = true,
            noremap = true,
            nowait = false,
        },
        mappings = {
            S = { name = "+surround" },
            q = {
                name = "+quickfix",
                o = { "<cmd>copen<cr>", "Open" },
                q = { "<cmd>cclose<cr>", "Close" },
            },
        },
    },
    visual = {
        options = {
            mode = "v",
            prefix = ",",
            buffer = nil,
            silent = true,
            noremap = true,
            nowait = false,
        },
        mappings = {
            S = { name = "+surround" },
        },
    },
}

-- leader mappings
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
            e = { "<cmd>NvimTreeToggle<cr>", "Explorer (tree)" },
            c = { "<cmd>noh<cr>", "Clear highlights" },
            h = { "<cmd>Telescope help_tags<cr>", "Help tags" },
            q = { "<cmd>confirm q<cr>", "Quit" },
            t = { "<cmd>split ~/pCloudDrive/notes/todo.txt<cr>", "Open todo.txt" },
            u = { "<cmd>UndotreeToggle<cr>", "Undo tree" },
            z = { "<cmd>ZenMode<cr>", "Zen mode" },
            Z = { "<cmd>Telescope zoxide list<cr>", "Zoxide" },
            b = {
                name = "+buffers",
                G = { "<cmd>bl<cr>", "Last buffer" },
                b = { "<cmd>Telescope buffers previewer=false<cr>", "Buffers" },
                d = {
                    function()
                        require("mini.bufremove").delete()
                    end,
                    "Delete buffer",
                },
                f = { "<cmd>Telescope current_buffer_fuzzy_find<cr>", "Fuzzy find" },
                g = { "<cmd>bf<cr>", "First buffer" },
                n = { "<cmd>bn<cr>", "Next buffer" },
                p = { "<cmd>bp<cr>", "Previous buffer" },
                o = { "<cmd>w <bar> %bd <bar> e# <bar> bd# <cr><cr>", "Close all other buffers" },
                w = {
                    function()
                        require("mini.bufremove").wipeout()
                    end,
                    "Wipeout buffers",
                },
                s = {
                    name = "+split",
                    p = { "<cmd>sbp<cr>", "Previous buffer" },
                    n = { "<cmd>sbn<cr>", "Next buffer" },
                },
            },
            f = {
                name = "+files",
                ["."] = {
                    function()
                        require("oil").open()
                    end,
                    "File explorer",
                },
                G = { "<cmd>Telescope git_files<cr>", "Find (git files)" },
                c = { "<cmd>Telescope grep_string<cr>", "Find string in cursor" },
                f = { "<cmd>Telescope find_files hidden=true<cr>", "Find" },
                g = { "<cmd>Telescope live_grep<cr>", "Live grep in project" },
                r = { "<cmd>Telescope oldfiles<cr>", "Open recent file" },
                s = { "<cmd>w<cr>", "Save" },
                t = { "<cmd>TodoTelescope<cr>", "Search TODOs" },
                S = {
                    function()
                        require("spectre").open()
                    end,
                    "Spectre - Search in project",
                },
            },
            g = {
                name = "+git",
                B = { "<cmd>Telescope git_bcommits<cr>", "Checkout commit (buffer)" },
                C = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
                D = { "<cmd>Gdiff<cr>", "Diff file (editor)" },
                L = { "<cmd>Gllog<cr>", "Log (project)" },
                l = { "<cmd>G log %<cr>", "Log (file)" },
                P = { "<cmd>G push<cr>", "Push" },
                b = { "<cmd>G blame<cr>", "Blame" },
                c = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
                d = { "<cmd>G diff %<cr>", "Diff file" },
                g = { "<cmd>G<cr>", "Git" },
                p = { "<cmd>G pull<cr>", "Pull" },
                r = {
                    function()
                        require("gitsigns").reset_buffer()
                    end,
                    "Reset buffer",
                },
            },
            T = {
                name = "+tabs",
                d = { "<cmd>tabclose<cr>", "Close" },
                n = { "<cmd>tabnext<cr>", "Next" },
                p = { "<cmd>tabprevious<cr>", "Previous" },
                t = { "<cmd>tabnew<cr>", "New" },
            },
            w = {
                name = "+windows",
                d = { "<C-w>q", "Close" },
                n = { "<C-w>w", "Next" },
                p = { "<C-w>p", "Previous" },
                s = { "<C-w>v", "Split" },
                v = { "<C-w>s", "Vertical split" },
                x = { "<C-w>x", "Swap" },
            },
        },
    },
}

-- apply mappings
wk.setup(conf)
wk.register(leader.normal.mappings, leader.normal.options)
wk.register(local_leader.normal.mappings, local_leader.normal.options)
wk.register(local_leader.visual.mappings, local_leader.visual.options)

autocmd("LspAttach", {
    group = augroup("UserLspConfig", { clear = true }),
    callback = function()
        wk.register(lsp.g.normal.mappings, lsp.g.normal.options)
        wk.register(lsp.g.visual.mappings, lsp.g.visual.options)
        wk.register(lsp.leader.normal.mappings, lsp.leader.normal.options)
        wk.register(lsp.local_leader.visual.mappings, lsp.local_leader.visual.options)
    end,
})
