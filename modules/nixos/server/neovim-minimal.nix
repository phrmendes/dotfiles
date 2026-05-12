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
          packages.mini.start = [ pkgs.vimPlugins.mini-nvim ];
          customLuaRC = # lua
            ''
              vim.cmd("packadd nvim.undotree")

              vim.ui.open = function(uri)
                vim.notify("Open: " .. uri, vim.log.levels.INFO)
                return nil, nil
              end

              vim.g.mapleader = " "
              vim.g.maplocalleader = ","

              vim.opt.expandtab = true
              vim.opt.shiftwidth = 2
              vim.opt.tabstop = 2
              vim.opt.swapfile = false
              vim.opt.shiftround = true
              vim.opt.pummaxwidth = 40
              vim.opt.updatetime = 200
              vim.opt.timeoutlen = 300
              vim.opt.foldenable = false
              vim.opt.inccommand = "split"
              vim.opt.winborder = "rounded"
              vim.opt.scrolloff = 8
              vim.opt.grepprg = "rg --vimgrep --smart-case"
              vim.opt.grepformat = "%f:%l:%c:%m"
              vim.opt.undolevels = 10000
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
                      ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
                      ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
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

              vim.api.nvim_create_autocmd("VimResized", {
                group = vim.api.nvim_create_augroup("Windows", {}),
                command = "wincmd =",
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

              require("mini.misc").setup()

              MiniMisc.setup_auto_root()
              MiniMisc.setup_restore_cursor()
              MiniMisc.setup_termbg_sync()

              vim.cmd.colorscheme("retrobox")

              require("mini.basics").setup({
                options = { basic = true, extra_ui = false },
                mappings = { basic = true, windows = false, move_with_alt = true },
                autocommands = { basic = true, relnum_in_visual_mode = true },
              })

              require("mini.ai").setup({
                n_lines = 500,
                custom_textobjects = {
                  f = require("mini.ai").gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
                  c = require("mini.ai").gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
                  o = require("mini.ai").gen_spec.treesitter({
                    a = { "@block.outer", "@conditional.outer", "@loop.outer" },
                    i = { "@block.inner", "@conditional.inner", "@loop.inner" },
                  }),
                },
              })

              require("mini.bracketed").setup({
                comment = { suffix = "k" },
                file = { suffix = "e" },
                diagnostic = { options = { float = false } },
              })

              require("mini.bufremove").setup()

              require("mini.clue").setup({
                triggers = {
                  { mode = "n", keys = "<leader>" },
                  { mode = "x", keys = "<leader>" },
                  { mode = "n", keys = "<localleader>" },
                  { mode = "x", keys = "<localleader>" },
                  { mode = "n", keys = "g" },
                  { mode = "x", keys = "g" },
                  { mode = "n", keys = "s" },
                  { mode = "x", keys = "s" },
                  { mode = "n", keys = "'" },
                  { mode = "n", keys = "`" },
                  { mode = "x", keys = "'" },
                  { mode = "x", keys = "`" },
                  { mode = "n", keys = '"' },
                  { mode = "x", keys = '"' },
                  { mode = "i", keys = "<c-r>" },
                  { mode = "c", keys = "<c-r>" },
                  { mode = "n", keys = "<c-w>" },
                  { mode = "n", keys = "z" },
                  { mode = "x", keys = "z" },
                },
                clues = {
                  require("mini.clue").gen_clues.builtin_completion(),
                  require("mini.clue").gen_clues.g(),
                  require("mini.clue").gen_clues.marks(),
                  require("mini.clue").gen_clues.registers(),
                  require("mini.clue").gen_clues.square_brackets(),
                  require("mini.clue").gen_clues.windows(),
                  require("mini.clue").gen_clues.z(),
                  { mode = "n", keys = "<leader>a", desc = "+ai" },
                  { mode = "x", keys = "<leader>a", desc = "+ai" },
                  { mode = "n", keys = "<leader>b", desc = "+buffers" },
                  { mode = "n", keys = "<leader>g", desc = "+git" },
                  { mode = "n", keys = "<leader>x", desc = "+lists" },
                },
                window = { delay = 250 },
              })

              require("mini.comment").setup()
              require("mini.cursorword").setup()

              require("mini.diff").setup({
                view = { style = "sign" },
                signs = { add = "█", change = "▒", delete = "" },
              })

              require("mini.extra").setup()

              require("mini.files").setup({
                windows = { preview = true },
                mappings = {
                  close = "q",
                  go_in = "l",
                  go_in_plus = "<cr>",
                  go_out = "h",
                  go_out_plus = "H",
                  reset = "<bs>",
                  reveal_cwd = "@",
                  show_help = "?",
                  synchronize = "=",
                  trim_left = "<",
                  trim_right = ">",
                },
              })

              vim.api.nvim_create_autocmd("User", {
                pattern = "MiniFilesBufferCreate",
                callback = function(event)
                  local bufnr = event.data.buf_id

                  local split = function(direction)
                    return function()
                      local win = MiniFiles.get_explorer_state().target_window
                      if win then
                        local new_win
                        vim.api.nvim_win_call(win, function()
                          vim.cmd("belowright " .. direction .. " split")
                          new_win = vim.api.nvim_get_current_win()
                        end)
                        MiniFiles.set_target_window(new_win)
                        MiniFiles.go_in({ close_on_file = true })
                      end
                    end
                  end

                  vim.keymap.set("n", "-", split("horizontal"), { buffer = bufnr, desc = "Open file (split)" })
                  vim.keymap.set("n", "\\", split("vertical"), { buffer = bufnr, desc = "Open file (vsplit)" })

                  vim.keymap.set("n", ".", function()
                    vim.g.mini_show_dotfiles = not vim.g.mini_show_dotfiles
                    MiniFiles.refresh({
                      content = {
                        filter = vim.g.mini_show_dotfiles and function() return true end
                          or function(fs_entry) return not vim.startswith(fs_entry.name, ".") end,
                      },
                    })
                  end, { buffer = bufnr, desc = "Toggle dotfiles" })
                end,
              })

              require("mini.git").setup({ command = { split = "horizontal" } })

              require("mini.hipatterns").setup({
                highlighters = {
                  fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
                  hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
                  todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
                  note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
                  hex_color = require("mini.hipatterns").gen_highlighter.hex_color(),
                },
              })

              require("mini.indentscope").setup()

              local jump2d = require("mini.jump2d")
              jump2d.setup({
                mappings = { start_jumping = "<leader>j" },
                spotter = jump2d.gen_spotter.pattern("[^%s%p]+"),
                view = { dim = true, n_steps_ahead = 2 },
              })

              require("mini.jump").setup()

              require("mini.move").setup({
                mappings = {
                  down = "<s-j>",
                  left = "<s-h>",
                  right = "<s-l>",
                  up = "<s-k>",
                  line_down = "",
                  line_left = "",
                  line_right = "",
                  line_up = "",
                },
              })

              require("mini.notify").setup()

              vim.notify = MiniNotify.make_notify()

              require("mini.operators").setup({ replace = { prefix = "gR", reindent_linewise = true } })
              require("mini.pairs").setup({ modes = { insert = true, command = true, terminal = true } })
              require("mini.splitjoin").setup({ mappings = { toggle = "T" } })
              require("mini.statusline").setup()

              require("mini.surround").setup({
                mappings = {
                  add = "sa",
                  find = "sf",
                  find_left = "sF",
                  highlight = "sh",
                  replace = "sr",
                  update_n_lines = "sn",
                  suffix_last = "l",
                  suffix_next = "n",
                },
              })

              require("mini.icons").setup({ style = "ascii" })

              require("mini.pick").setup({
                mappings = { refine = "<c-r>", refine_marked = "<a-r>", paste = "<c-y>", choose_marked = "<c-q>" },
              })

              vim.ui.select = MiniPick.ui_select

              require("mini.trailspace").setup()
              vim.api.nvim_create_user_command("Trim", function()
                MiniTrailspace.trim()
                MiniTrailspace.trim_last_lines()
                vim.cmd.write()
              end, { desc = "Trim trailing whitespace and last empty lines" })

              require("mini.visits").setup()

              vim.keymap.set("n", "<c-d>", "<c-d>zz")
              vim.keymap.set("n", "<c-u>", "<c-u>zz")
              vim.keymap.set("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true })
              vim.keymap.set("n", "N", "'nN'[v:searchforward].'zv'", { expr = true })
              vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>")

              local sort_recent = MiniVisits.gen_sort.default({ recency_weight = 1 })
              local iterate_opts = { sort = sort_recent, wrap = true }

              vim.keymap.set("n", "[v", function() MiniVisits.iterate_paths("backward", nil, iterate_opts) end, { desc = "Previous visit (MRU)" })
              vim.keymap.set("n", "]v", function() MiniVisits.iterate_paths("forward", nil, iterate_opts) end, { desc = "Next visit (MRU)" })
              vim.keymap.set("n", "[V", function() MiniVisits.iterate_paths("first", nil, iterate_opts) end, { desc = "Most recent visit" })
              vim.keymap.set("n", "]V", function() MiniVisits.iterate_paths("last", nil, iterate_opts) end, { desc = "Oldest visit" })
              vim.keymap.set("n", "<leader>/", MiniPick.builtin.grep_live, { desc = "Live grep" })
              vim.keymap.set("n", "<leader>:", function() MiniExtra.pickers.history({ scope = ":" }) end, { desc = "`:` history" })
              vim.keymap.set("n", "<leader><del>", MiniNotify.clear, { desc = "Clear notifications" })
              vim.keymap.set("n", "<leader><leader>", MiniPick.builtin.files, { desc = "Files" })
              vim.keymap.set("n", "<leader>=", MiniMisc.resize_window, { desc = "Resize to default size" })
              vim.keymap.set("n", "<leader>?", MiniPick.builtin.help, { desc = "Help" })
              vim.keymap.set("n", "<leader>K", MiniExtra.pickers.keymaps, { desc = "Keymaps" })
              vim.keymap.set("n", "<leader>N", MiniNotify.show_history, { desc = "Notifications" })
              vim.keymap.set("n", "<leader>V", function() MiniExtra.pickers.visit_paths({ cwd = "" }) end, { desc = "Visits (all)" })
              vim.keymap.set("n", "<leader>Z", MiniMisc.zoom, { desc = "Zoom" })
              vim.keymap.set("n", "<leader>bd", MiniBufremove.delete, { desc = "Delete" })
              vim.keymap.set("n", "<leader>bw", MiniBufremove.wipeout, { desc = "Wipeout" })
              vim.keymap.set("n", "<leader>gA", "<cmd>Git add --all<cr>", { desc = "Add (repo)" })
              vim.keymap.set("n", "<leader>gH", MiniExtra.pickers.git_hunks, { desc = "Hunks (repo)" })
              vim.keymap.set("n", "<leader>gL", MiniExtra.pickers.git_commits, { desc = "Log (repo)" })
              vim.keymap.set("n", "<leader>gP", "<cmd>Git push<cr>", { desc = "Push" })
              vim.keymap.set("n", "<leader>ga", "<cmd>Git add %<cr>", { desc = "Add (file)" })
              vim.keymap.set("n", "<leader>gc", "<cmd>Git commit<cr>", { desc = "Commit" })
              vim.keymap.set("n", "<leader>gd", function() MiniDiff.toggle_overlay(0) end, { desc = "Diff (file)" })
              vim.keymap.set("n", "<leader>gh", function() MiniExtra.pickers.git_hunks({ path = vim.fn.expand("%") }) end, { desc = "Hunks (file)" })
              vim.keymap.set("n", "<leader>gl", function() MiniExtra.pickers.git_commits({ paths = "%" }) end, { desc = "Log (file)" })
              vim.keymap.set("n", "<leader>gm", function() MiniExtra.pickers.git_files({ scope = "modified" }) end, { desc = "Modified files" })
              vim.keymap.set("n", "<leader>gp", "<cmd>Git pull<cr>", { desc = "Pull" })
              vim.keymap.set("n", "<leader>m", MiniExtra.pickers.marks, { desc = "Marks" })
              vim.keymap.set("n", "<leader>v", MiniExtra.pickers.visit_paths, { desc = "Visits (cwd)" })
              vim.keymap.set("n", "<c-s-p>", MiniExtra.pickers.commands, { desc = "Commands" })
              vim.keymap.set("n", "<leader>q", function()
                if vim.list_contains(vim.v.argv, "--embed") then
                  vim.cmd.quit()
                  return
                end
                vim.cmd.detach()
              end, { desc = "Quit / detach" })

              vim.keymap.set("n", "<c-p>", function()
                local buf_items = function()
                  return vim
                    .iter(vim.fn.getbufinfo({ buflisted = 1 }))
                    :map(function(buf)
                      local text
                      if vim.bo[buf.bufnr].buftype == "terminal" then
                        text = vim.fn.fnamemodify(buf.name, ":t")
                      else
                        local name = vim.fn.fnamemodify(buf.name, ":~:.")
                        text = name ~= "" and name or "[No Name]"
                      end
                      return { bufnr = buf.bufnr, text = text }
                    end)
                    :totable()
                end

                MiniPick.start({
                  source = {
                    name = "Buffers",
                    items = buf_items(),
                    show = function(buf_id, items, query) MiniPick.default_show(buf_id, items, query, { show_icons = true }) end,
                    choose = function(item) vim.api.nvim_set_current_buf(item.bufnr) end,
                  },
                  mappings = {
                    wipeout = {
                      char = "<c-d>",
                      func = function()
                        local matches = MiniPick.get_picker_matches()
                        if not matches then return end
                        local to_delete = matches.marked and #matches.marked > 0 and matches.marked or { matches.current }
                        vim.iter(to_delete):each(function(buf)
                          if buf then MiniBufremove.delete(buf.bufnr) end
                        end)
                        MiniPick.set_picker_items(buf_items())
                      end,
                    },
                  },
                })
              end, { desc = "Buffers" })

              vim.keymap.set("n", "<leader>e", function()
                if not MiniFiles.close() then
                  local path = vim.fn.expand("%:p:h")
                  MiniFiles.open(vim.uv.fs_stat(path) and path or nil, true)
                end
              end, { desc = "Explorer" })

              vim.keymap.set("n", "<leader>p", function()
                local root = vim.fs.joinpath(vim.env.HOME, "Projects")
                local command = { "fd", "--type", "d", "--hidden", "--max-depth", "3", ".", root }
                local postprocess = function(lines)
                  local items = vim
                    .iter(lines)
                    :map(function(dir) return dir:gsub("/$", "") end)
                    :map(function(dir)
                      local stat = vim.uv.fs_stat(vim.fs.joinpath(dir, ".git"))
                      if not stat then return nil end
                      local prefix = stat.type == "file" and "[S] " or ""
                      return { text = prefix .. vim.fn.fnamemodify(dir, ":~"), path = dir }
                    end)
                    :filter(function(item) return item ~= nil end)
                    :totable()
                  table.sort(items, function(a, b) return a.text < b.text end)
                  return items
                end
                MiniPick.builtin.cli({ command = command, postprocess = postprocess }, {
                  source = {
                    name = "Projects",
                    show = function(buf_id, items_, query) MiniPick.default_show(buf_id, items_, query, { show_icons = true }) end,
                    choose = function(item)
                      if not item then return end
                      vim.schedule(function()
                        vim.fn.chdir(item.path)
                      end)
                    end,
                  },
                })
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
