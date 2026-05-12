_: {
  modules.nixos.server.neovim-minimal =
    { pkgs, ... }:
    {
      programs.neovim = {
        enable = true;
        withRuby = false;
        configure = {
          packages.treesitter.start = pkgs.local.nvim-treesitter;
          packages.sidekick.start = [ pkgs.vimPlugins.sidekick-nvim ];
          customLuaRC = /* lua */ ''
            vim.cmd("packadd nvim.undotree")

            vim.ui.open = function(uri)
              vim.notify("Open: " .. uri, vim.log.levels.INFO)
              return nil, nil
            end

            vim.g.mapleader = " "
            vim.g.maplocalleader = ","

            vim.cmd.colorscheme("retrobox")

            vim.g.netrw_banner = 0
            vim.g.netrw_liststyle = 3
            vim.g.netrw_winsize = 20
            vim.opt.termguicolors = true
            vim.opt.confirm = true
            vim.opt.expandtab = true
            vim.opt.shiftwidth = 2
            vim.opt.tabstop = 2
            vim.opt.swapfile = false
            vim.opt.shiftround = true
            vim.opt.pumheight = 10
            vim.opt.pummaxwidth = 40
            vim.opt.updatetime = 200
            vim.opt.timeoutlen = 300
            vim.opt.splitbelow = true
            vim.opt.splitright = true
            vim.opt.foldenable = false
            vim.opt.inccommand = "split"
            vim.opt.winborder = "rounded"
            vim.opt.scrolloff = 8
            vim.opt.signcolumn = "yes"
            vim.opt.number = true
            vim.opt.relativenumber = true
            vim.opt.cursorline = true
            vim.opt.ignorecase = true
            vim.opt.smartcase = true
            vim.opt.grepprg = "rg --vimgrep --smart-case"
            vim.opt.grepformat = "%f:%l:%c:%m"
            vim.opt.undofile = true
            vim.opt.undolevels = 10000
            vim.opt.list = true
            vim.opt.listchars = { tab = "▏ ", trail = "·", extends = "»", precedes = "«" }
            vim.opt.autocomplete = true
            vim.opt.completeopt = "menu,menuone,popup,fuzzy"

            vim.schedule(function()
              vim.opt.clipboard = "unnamedplus"
              if vim.env.SSH_TTY then
                vim.g.clipboard = {
                  name = "OSC 52",
                  copy = {
                    ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
                    ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
                  },
                  paste = {
                    ["+"] = function() return { vim.split(vim.fn.getreg(""), "\n"), vim.fn.getregtype("") } end,
                    ["*"] = function() return { vim.split(vim.fn.getreg(""), "\n"), vim.fn.getregtype("") } end,
                  },
                }
              end
            end)

            vim.diagnostic.config({
              severity_sort = true,
              virtual_lines = { current_line = true },
              underline = false,
              signs = {
                text = {
                  [vim.diagnostic.severity.ERROR] = "E",
                  [vim.diagnostic.severity.WARN] = "W",
                  [vim.diagnostic.severity.INFO] = "I",
                  [vim.diagnostic.severity.HINT] = "H",
                },
              },
            })

            for _, name in ipairs({ "gzip", "matchit", "tar", "tarPlugin", "zip", "zipPlugin", "tutor" }) do
              vim.g["loaded_" .. name] = true
            end

            local line_numbers = vim.api.nvim_create_augroup("LineNumbers", {})

            vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave", "WinEnter" }, {
              group = line_numbers,
              command = "if &nu && mode() != 'i' | set rnu | endif",
            })

            vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter", "WinLeave" }, {
              group = line_numbers,
              command = "if &nu | set nornu | endif",
            })

            vim.api.nvim_create_autocmd("VimResized", {
              group = vim.api.nvim_create_augroup("Windows", {}),
              command = "wincmd =",
            })

            vim.api.nvim_create_autocmd("FileType", {
              group = vim.api.nvim_create_augroup("FormatOptions", {}),
              pattern = "*",
              callback = function() vim.opt.formatoptions = vim.opt.formatoptions - { "c", "r", "o" } end,
            })

            vim.api.nvim_create_autocmd("FileType", {
              group = vim.api.nvim_create_augroup("TransientBuffers", {}),
              pattern = { "diff", "git", "help", "man", "qf", "query" },
              callback = function(event)
                vim.bo[event.buf].buflisted = false
                vim.keymap.set("n", "q", "<cmd>q<cr>", { buffer = event.buf })
              end,
            })

            vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
              group = vim.api.nvim_create_augroup("Autoread", {}),
              callback = function()
                if vim.fn.mode() ~= "c" then vim.cmd.checktime() end
              end,
            })

            vim.api.nvim_create_autocmd("FileType", {
              group = vim.api.nvim_create_augroup("Treesitter", {}),
              callback = function(event)
                local lang = vim.treesitter.language.get_lang(event.match) or event.match
                if not vim.treesitter.language.add(lang) then return end
                vim.treesitter.start(event.buf, lang)
              end,
            })

            vim.api.nvim_create_autocmd("BufEnter", {
              group = vim.api.nvim_create_augroup("AutoRoot", {}),
              callback = vim.schedule_wrap(function(data)
                if data.buf ~= vim.api.nvim_get_current_buf() then return end
                local root = vim.fs.root(data.buf, { ".git" })
                if root then vim.fn.chdir(root) end
              end),
            })

            vim.keymap.set("n", "<c-d>", "<c-d>zz")
            vim.keymap.set("n", "<c-u>", "<c-u>zz")
            vim.keymap.set("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true })
            vim.keymap.set("n", "N", "'nN'[v:searchforward].'zv'", { expr = true })
            vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>")
            vim.keymap.set("n", "<leader>-", "<cmd>split<cr>", { desc = "Split (H)" })
            vim.keymap.set("n", "<leader>\\", "<cmd>vsplit<cr>", { desc = "Split (V)" })
            vim.keymap.set("n", "<leader>e", "<cmd>Lexplore<cr>", { desc = "Explorer" })
            vim.keymap.set("n", "<leader>/", function() vim.fn.feedkeys(":silent grep  | copen\18", "n") end, { desc = "Grep" })
            vim.keymap.set("n", "<c-p>", "<cmd>buffers<cr>:b<space>", { desc = "Buffers" })
            vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })
            vim.keymap.set("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix list" })
            vim.keymap.set("n", "<leader>gs", function() vim.cmd("terminal git status") end, { desc = "Git status" })
            vim.keymap.set("n", "<leader>gd", function() vim.cmd("vertical terminal git diff") end, { desc = "Git diff" })
            vim.keymap.set("n", "<leader>gl", function() vim.cmd("terminal git log --oneline --graph --decorate -20") end, { desc = "Git log" })
            vim.keymap.set("n", "<leader>gD", function() vim.cmd("windo diffthis") end, { desc = "Diff windows" })
            vim.keymap.set("n", "<leader>gO", "<cmd>diffoff!<cr>", { desc = "Diff off" })
            vim.keymap.set("n", "]c", "]czz", { desc = "Next hunk" })
            vim.keymap.set("n", "[c", "[czz", { desc = "Prev hunk" })
            vim.keymap.set("n", "<leader>u", "<cmd>Undotree<cr>", { desc = "Undo tree" })

            vim.keymap.set("n", "<leader>q", function()
              if vim.list_contains(vim.v.argv, "--embed") then
                vim.cmd.quit()
                return
              end
              vim.cmd.detach()
            end, { desc = "Quit" })

            vim.keymap.set("n", "<leader><leader>", function()
              local pattern = vim.fn.input("Find: ")
              if pattern == "" then return end
              local matches = vim.fn.systemlist({ "fd", "--type", "f", "--hidden", "--glob", pattern })
              if #matches == 0 then return vim.notify("No files found", vim.log.levels.WARN) end
              if #matches == 1 then return vim.cmd.edit(matches[1]) end
              vim.ui.select(matches, { prompt = "Find file" }, function(choice)
                if choice then vim.cmd.edit(choice) end
              end)
            end, { desc = "Find file" })

            vim.keymap.set("n", "<leader>p", function()
              local root = vim.fs.joinpath(vim.env.HOME, "Projects")
              local dirs = vim.fn.systemlist({ "fd", "--type", "d", "--hidden", "--max-depth", "2", root })
              local items = vim.iter(dirs)
                :map(function(d) return d:gsub("/$", "") end)
                :filter(function(d)
                  local stat = vim.uv.fs_stat(vim.fs.joinpath(d, ".git"))
                  return stat ~= nil and stat.type == "directory"
                end)
                :totable()
              vim.ui.select(items, { prompt = "Project" }, function(choice)
                if choice then vim.fn.chdir(choice) end
              end)
            end, { desc = "Projects" })

            require("sidekick").setup({
              nes = { enabled = false },
              cli = {
                win = { layout = "float" },
                mux = { backend = "tmux", enabled = true },
                tools = { pi = {} },
              },
            })

            vim.keymap.set({ "n", "t", "i", "x" }, "<c-.>", function() require("sidekick.cli").toggle() end, { desc = "Toggle coding agent" })
            vim.keymap.set({ "n", "x" }, "<leader>aa", function() require("sidekick.cli").send({ msg = "{this}" }) end, { desc = "Send this" })
            vim.keymap.set({ "n", "x" }, "<leader>ad", function() require("sidekick.cli").close() end, { desc = "Detach" })
            vim.keymap.set({ "n", "x" }, "<leader>af", function() require("sidekick.cli").send({ msg = "{file}" }) end, { desc = "Send file" })
            vim.keymap.set({ "n", "x" }, "<leader>as", function() require("sidekick.cli").select() end, { desc = "Select CLI" })
          '';
        };
      };

      environment.sessionVariables.EDITOR = "nvim";
      environment.systemPackages = [ pkgs.fd ];
    };
}
