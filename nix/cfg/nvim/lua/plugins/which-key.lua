local setup, which_key = pcall(require, "which-key")
if not setup then
    return
end

local conf = { window = { border = "single", position = "bottom" } }

which_key.setup(conf)

-- g prefix normal mappings
local g_normal_opts = {
    mode = "n",
    prefix = "g",
    buffer = nil,
    silent = true,
    noremap = true,
    nowait = false,
}

local g_normal_mappings = {
    a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "LSP - Code action" },
    D = { "<cmd>lua vim.lsp.buf.declaration()<cr>", "LSP - Declaration" },
    d = { "<cmd>Telescope lsp_definitions<cr>", "LSP - Definitions" },
    h = { "<cmd>lua vim.lsp.buf.hover()<cr>", "LSP - Hover" },
    i = { "<cmd>Telescope lsp_implementations<cr>", "LSP - Implementation" },
    r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "LSP - Rename" },
    R = { "<cmd>Telescope lsp_references<cr>", "LSP - References" },
    s = { "<cmd>lua vim.lsp.buf.signature_help()<cr>", "LSP - Signature help" },
    t = { "<cmd>Telescope lsp_type_definitions<cr>", "LSP - Type definition" },
}

which_key.register(g_normal_mappings, g_normal_opts)

-- leader visual mappings

local leader_visual_opts = {
    mode = "v",
    prefix = "<leader>",
    buffer = nil,
    silent = true,
    noremap = true,
    nowait = false,
}

local leader_visual_mappings = { e = { "<cmd>lua require('dapui').eval()" } }

which_key.register(leader_visual_mappings, leader_visual_opts)

-- leader normal mappings
local leader_normal_opts = {
    mode = "n",
    prefix = "<leader>",
    buffer = nil,
    silent = true,
    noremap = true,
    nowait = false,
}

local leader_normal_mappings = {
    Q = { "<cmd>q!<cr>", "Quit withoust saving" },
    c = { "<cmd>noh<cr>", "Clear highlights" },
    e = { "<cmd>NvimTreeToggle<cr>", "File explorer tree" },
    h = { "<cmd>Telescope help_tags<cr>", "Help tags" },
    q = { "<cmd>confirm q<cr>", "Quit" },
    t = { "<cmd>split ~/pCloudDrive/notes/todo.txt<cr>", "Open todo.txt" },
    u = { "<cmd>UndotreeToggle<cr>", "Undo tree" },
    z = { "<cmd>ZenMode<cr>", "Zen mode" },

    b = {
        name = "+buffers",
        G = { "<cmd>bl<cr>", "Last buffer" },
        b = { "<cmd>Telescope buffers previewer=false<cr>", "Buffers" },
        d = { "<cmd>lua MiniBufremove.delete()<cr>", "Delete buffer" },
        f = { "<cmd>Telescope current_buffer_fuzzy_find<cr>", "Fuzzy find" },
        g = { "<cmd>bf<cr>", "First buffer" },
        n = { "<cmd>bn<cr>", "Next buffer" },
        p = { "<cmd>bp<cr>", "Previous buffer" },
        o = { "<cmd>w <bar> %bd <bar> e# <bar> bd# <cr><cr>", "Close all other buffers" },
        w = { "<cmd>lua MiniBufremove.wipeout()<cr>", "Wipeout buffers" },

        s = {
            name = "+split",
            p = { "<cmd>sbp<cr>", "Previous buffer" },
            n = { "<cmd>sbn<cr>", "Next buffer" },
        },
    },

    d = {
        name = "+debugger",
        B = { "<cmd>lua require('dap').step_back()<cr>", "Step back" },
        c = { "<cmd>lua require('dap').continue()<cr>", "Continue" },
        i = { "<cmd>lua require('dap').step_into()<cr>", "Step into" },
        o = { "<cmd>lua require('dap').step_over()<cr>", "Step over" },
        p = { "<cmd>lua require('dap').pause()<cr>", "Pause" },
        q = { "<cmd>lua require('dap').close()<cr>", "Quit" },
        s = { "<cmd>lua require('dap').continue()<cr>", "Start" },
        t = { "<cmd>lua require('dapui').toggle()<cr>", "Toggle UI" },
        u = { "<cmd>lua require('dap').step_out()<cr>", "Step out" },
        b = {
            "<cmd>lua require('dap').toggle_breakpoint()<cr>",
            "Toggle breakpoint",
        },
        r = {
            "<cmd>lua require('dapui').open({reset = true})<cr>",
            "Reset UI panes",
        },
    },

    f = {
        name = "+files",
        ["."] = { "<cmd>lua require('oil').open()<cr>", "File explorer" },
        G = { "<cmd>Telescope git_files<cr>", "Find (git files)" },
        c = { "<cmd>Telescope grep_string<cr>", "Find string in cursor" },
        f = { "<cmd>Telescope find_files hidden=true<cr>", "Find" },
        g = { "<cmd>Telescope live_grep<cr>", "Live grep in project" },
        r = { "<cmd>Telescope oldfiles<cr>", "Open recent file" },
        s = { "<cmd>w<cr>", "Save" },
        t = { "<cmd>TodoTelescope<cr>", "Search TODOs" },
        S = {
            "<cmd>lua require('spectre').open()<cr>",
            "Spectre - Search in project",
        },
    },

    g = {
        name = "+git",
        B = { "<cmd>Telescope git_bcommits<cr>", "Checkout commit (buffer)" },
        C = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
        D = { "<cmd>Gdiff<cr>", "Diff file (editor)" },
        L = { "<cmd>Gllog<cr>", "Log" },
        P = { "<cmd>G push<cr>", "Push" },
        b = { "<cmd>G blame<cr>", "Blame" },
        c = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
        d = { "<cmd>G diff %<cr>", "Diff file" },
        g = { "<cmd>G<cr>", "Git" },
        p = { "<cmd>G pull<cr>", "Pull" },
        r = { "<cmd>lua require('gitsigns').reset_buffer()<cr>", "Reset buffer" },
    },

    l = {
        name = "+lsp",
        c = { "<cmd>lua vim.lsp.codelens.run()<cr>", "CodeLens action" },
        d = { "<cmd>Telescope diagnostics<cr>", "Diagnostics" },
        s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document symbols" },
        w = {
            "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
            "Workspace symbols",
        },
    },

    m = {
        name = "+markdown",
        b = { "<cmd>Telescope bibtex<cr>", "Insert bibliography" },
        p = { "<cmd>MarkdownPreview<cr>", "Preview markdown document" },
        s = { "<cmd>MarkdownPreviewStop<cr>", "Stop markdown preview" },
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
}

which_key.register(leader_normal_mappings, leader_normal_opts)
