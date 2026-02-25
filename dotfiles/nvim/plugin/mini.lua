safely("now", function() require("mini.sessions").setup() end)
safely("now", function() require("mini.statusline").setup() end)
safely("now", function() require("mini.tabline").setup() end)

safely("now", function()
  require("mini.icons").setup()
  safely("later", MiniIcons.tweak_lsp_kind)
  safely("later", MiniIcons.mock_nvim_web_devicons)
end)

safely("now", function()
  require("mini.base16").setup({
    palette = require("nix.base16").palette,
    use_cterm = true,
  })
end)

safely(
  "now",
  function()
    require("mini.bracketed").setup({
      file = { suffix = "" },
      comment = { suffix = "" },
      diagnostic = { options = { float = false } },
    })
  end
)

safely("now", function()
  local starter = require("mini.starter")

  starter.setup({
    evaluate_single = true,
    items = {
      starter.sections.sessions(5, true),
      starter.sections.recent_files(5, true),
      starter.sections.recent_files(5, false),
      starter.sections.builtin_actions(),
    },
    content_hooks = {
      starter.gen_hook.adding_bullet(),
      starter.gen_hook.indexing("all", { "Builtin actions" }),
      starter.gen_hook.aligning("center", "center"),
    },
  })
end)

safely("now", function()
  require("mini.notify").setup({
    window = { config = { border = vim.g.border } },
    content = {
      sort = function(array)
        local to_filter = { "Diagnosing", "Processing files", "file to analyze", "ltex" }
        return MiniNotify.default_sort(vim.iter(to_filter):fold(array, function(tbl, filter)
          return vim.iter(tbl):filter(function(n) return not string.find(n.msg, filter) end):totable()
        end))
      end,
    },
  })

  vim.notify = MiniNotify.make_notify()
end)

safely("later", function() require("mini.align").setup() end)
safely("later", function() require("mini.comment").setup() end)
safely("later", function() require("mini.cursorword").setup() end)
safely("later", function() require("mini.doc").setup() end)
safely("later", function() require("mini.indentscope").setup({ symbol = "│" }) end)
safely("later", function() require("mini.jump").setup() end)
safely("later", function() require("mini.operators").setup({ replace = { prefix = "gR", reindent_linewise = true } }) end)
safely("later", function() require("mini.pairs").setup({ modes = { insert = true, command = true, terminal = true } }) end)
safely("later", function() require("mini.splitjoin").setup({ mappings = { toggle = "T" } }) end)
safely("later", function() require("mini.test").setup() end)
safely("later", function() require("mini.visits").setup() end)
safely("later", function() require("mini.extra").setup() end)
safely("later", function() require("mini.bufremove").setup() end)

safely("later", function()
  local ai = require("mini.ai")
  local extra = require("mini.extra")

  ai.setup({
    n_lines = 500,
    custom_textobjects = {
      B = extra.gen_ai_spec.buffer(),
      D = extra.gen_ai_spec.diagnostic(),
      I = extra.gen_ai_spec.indent(),
      L = extra.gen_ai_spec.line(),
      N = extra.gen_ai_spec.number(),
      t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
      u = ai.gen_spec.function_call(),
      f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
      c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
      o = ai.gen_spec.treesitter({
        a = { "@block.outer", "@conditional.outer", "@loop.outer" },
        i = { "@block.inner", "@conditional.inner", "@loop.inner" },
      }),
    },
  })
end)

safely("later", function()
  local clue = require("mini.clue")
  clue.setup({
    triggers = {
      { mode = "n", keys = "<leader>" },
      { mode = "x", keys = "<leader>" },
      { mode = "n", keys = "<localleader>" },
      { mode = "x", keys = "<localleader>" },
      { mode = "i", keys = "<c-x>" },
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
      clue.gen_clues.builtin_completion(),
      clue.gen_clues.g(),
      clue.gen_clues.marks(),
      clue.gen_clues.registers(),
      clue.gen_clues.square_brackets(),
      clue.gen_clues.windows(),
      clue.gen_clues.z(),
      { mode = "n", keys = "<leader><tab>", desc = "+tabs" },
      { mode = "n", keys = "<leader>b", desc = "+buffers" },
      { mode = "n", keys = "<leader>g", desc = "+git" },
      { mode = "n", keys = "<leader>k", desc = "+kulala" },
      { mode = "n", keys = "<leader>n", desc = "+notes" },
      { mode = "n", keys = "<leader>o", desc = "+opencode" },
      { mode = "n", keys = "<leader>t", desc = "+todotxt" },
      { mode = "n", keys = "<leader>y", desc = "+yank" },
      { mode = "x", keys = "<leader>g", desc = "+git" },
      { mode = "x", keys = "<leader>o", desc = "+opencode" },
      { mode = "x", keys = "<leader>y", desc = "+yank" },
    },
    window = { delay = 500, config = { width = "auto", border = vim.g.border } },
  })
end)

safely("later", function()
  vim.pack.add({ "https://github.com/rafamadriz/friendly-snippets" })
  require("mini.completion").setup({
    window = {
      info = { height = 25, width = 80, border = vim.g.border },
      signature = { height = 25, width = 80, border = vim.g.border },
    },
    fallback_action = "<c-x><c-o>",
    lsp_completion = {
      source_func = "omnifunc",
      auto_setup = false,
      process_items = function(items, base) return MiniCompletion.default_process_items(items, base, { kind_priority = { Text = -1, Snippet = 99 } }) end,
    },
    mappings = { force_twostep = "<c-f>", force_fallback = "<a-f>", scroll_down = "<c-d>", scroll_up = "<c-u>" },
  })
  vim.lsp.config("*", { capabilities = MiniCompletion.get_lsp_capabilities() })
  vim.api.nvim_create_autocmd("FileType", {
    desc = "Disable completion in certain filetypes",
    pattern = { "dap-view", "dap-view-term", "dap-repl", "snacks_input", "minifiles", "grug-far", "opencode_ask" },
    callback = function(event) vim.b[event.buf].minicompletion_disable = true end,
  })
end)

safely(
  "later",
  function()
    require("mini.diff").setup({
      view = { style = "sign" },
      signs = { add = "█", change = "▒", delete = "" },
    })
  end
)

safely("later", function() require("mini.git").setup({ command = { split = "horizontal" } }) end)

safely("later", function()
  local hipatterns = require("mini.hipatterns")
  hipatterns.setup({
    highlighters = {
      fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
      hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
      todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
      note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
      hex_color = hipatterns.gen_highlighter.hex_color(),
    },
  })
end)

safely("later", function()
  local jump2d = require("mini.jump2d")

  jump2d.setup({
    mappings = { start_jumping = "<leader>j" },
    spotter = jump2d.gen_spotter.pattern("[^%s%p]+"),
    view = { dim = true, n_steps_ahead = 2 },
  })
end)

safely("later", function()
  require("mini.keymap").setup()

  MiniKeymap.map_multistep("i", "<c-n>", { "minisnippets_next", "pmenu_next" })
  MiniKeymap.map_multistep("i", "<c-p>", { "pmenu_prev", "minisnippets_prev" })
  MiniKeymap.map_multistep("i", "<cr>", { "pmenu_accept", "minipairs_cr" })
  MiniKeymap.map_multistep("i", "<bs>", { "minipairs_bs" })
  MiniKeymap.map_combo({ "i", "c", "x", "s" }, "jk", "<bs><bs><esc>")
  MiniKeymap.map_combo({ "i", "c", "x", "s" }, "kj", "<bs><bs><esc>")
  MiniKeymap.map_combo({ "i", "c", "x", "s", "n" }, "<esc><esc>", function() vim.cmd("nohlsearch") end)
end)

safely("later", function()
  MiniMisc.setup_auto_root()
  MiniMisc.setup_restore_cursor()
  MiniMisc.setup_termbg_sync()
end)

safely(
  "later",
  function()
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
  end
)

safely("later", function()
  local snippets = require("mini.snippets")

  snippets.setup({
    snippets = { snippets.gen_loader.from_lang() },
    mappings = { expand = "<c-j>", stop = "<c-c>", jump_next = "", jump_prev = "" },
  })

  MiniSnippets.start_lsp_server()
end)

safely(
  "later",
  function()
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
  end
)

safely("later", function()
  require("mini.pick").setup({
    mappings = { refine = "<c-r>", refine_marked = "<a-r>", paste = "<c-y>", choose_marked = "<c-q>" },
    window = { config = { border = vim.g.border } },
  })

  vim.ui.select = MiniPick.ui_select
end)

safely("later", function()
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
    desc = "Set mini.files keybindings",
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
            filter = vim.g.mini_show_dotfiles and function() return true end or function(fs_entry) return not vim.startswith(fs_entry.name, ".") end,
          },
        })
      end, { buffer = bufnr, desc = "Toggle dotfiles" })

      vim.keymap.set("n", "go", function()
        local fs_entry = MiniFiles.get_fs_entry()
        if not fs_entry then return vim.notify("No file selected", vim.log.levels.ERROR) end
        vim.schedule(function()
          vim.notify("Opening " .. fs_entry.name, vim.log.levels.INFO)
          vim.ui.open(fs_entry.path)
        end)
      end, { buffer = bufnr, desc = "Open file" })

      vim.keymap.set("n", "gs", function()
        local grug_far = require("grug-far")
        local prefills = { paths = vim.fs.dirname(MiniFiles.get_fs_entry().path) }
        if not grug_far.has_instance("explorer") then
          grug_far.open({ instanceName = "explorer", prefills = prefills, staticTitle = "Find and Replace from Explorer" })
        else
          grug_far.get_instance("explorer"):open()
          grug_far.get_instance("explorer"):update_input_values(prefills, false)
        end
      end, { buffer = bufnr, desc = "Search with grug-far.nvim" })
    end,
  })

  vim.api.nvim_create_autocmd("User", {
    desc = "LSP-aware file renaming",
    pattern = "MiniFilesActionRename",
    callback = function(event) Snacks.rename.on_rename_file(event.data.from, event.data.to) end,
  })

  vim.api.nvim_create_autocmd("User", {
    desc = "Set border for mini.files window",
    pattern = "MiniFilesWindowOpen",
    callback = function(event) vim.api.nvim_win_set_config(event.data.win_id, { border = vim.g.border }) end,
  })
end)

safely("later", function()
  require("mini.trailspace").setup()
  vim.api.nvim_create_user_command("Trim", function()
    MiniTrailspace.trim()
    MiniTrailspace.trim_last_lines()
    vim.cmd.write()
  end, { desc = "Trim trailing whitespace and last empty lines" })
end)

safely("later", function()
  local pickers = MiniExtra.pickers

  vim.keymap.set("n", "<leader>N", MiniNotify.show_history, { desc = "Notifications" })
  vim.keymap.set("n", "<leader><del>", MiniNotify.clear, { desc = "Clear notifications" })
  vim.keymap.set("n", "<leader>bd", MiniBufremove.delete, { desc = "Delete" })
  vim.keymap.set("n", "<leader>bw", MiniBufremove.wipeout, { desc = "Wipeout" })
  vim.keymap.set("n", "<leader>gd", function() MiniDiff.toggle_overlay(0) end, { desc = "Diff (file)" })
  vim.keymap.set("n", "<leader>:", function() pickers.history({ scope = ":" }) end, { desc = "`:` history" })
  vim.keymap.set("n", "<leader>K", pickers.keymaps, { desc = "Keymaps" })
  vim.keymap.set("n", "<leader>m", pickers.marks, { desc = "Marks" })
  vim.keymap.set("n", "<leader>v", pickers.visit_paths, { desc = "Visits (cwd)" })
  vim.keymap.set("n", "<leader>V", function() pickers.visit_paths({ cwd = "" }) end, { desc = "Visits (all)" })
  vim.keymap.set("n", "<leader>gL", pickers.git_commits, { desc = "Log (repo)" })
  vim.keymap.set("n", "<leader>gH", pickers.git_hunks, { desc = "Hunks (repo)" })
  vim.keymap.set("n", "<leader>gh", function() pickers.git_hunks({ path = "%" }) end, { desc = "Hunks (file)" })
  vim.keymap.set("n", "<leader>gm", function() pickers.git_files({ scope = "modified" }) end, { desc = "Modified files" })
  vim.keymap.set("n", "<leader>gl", function() pickers.git_commits({ paths = "%" }) end, { desc = "Log (file)" })
  vim.keymap.set("n", "<leader>gA", "<cmd>Git add --all<cr>", { desc = "Add (repo)" })
  vim.keymap.set("n", "<leader>gP", "<cmd>Git push<cr>", { desc = "Push" })
  vim.keymap.set("n", "<leader>ga", "<cmd>Git add %<cr>", { desc = "Add (file)" })
  vim.keymap.set("n", "<leader>gc", "<cmd>Git commit<cr>", { desc = "Commit" })
  vim.keymap.set("n", "<leader>gp", "<cmd>Git pull<cr>", { desc = "Pull" })
  vim.keymap.set({ "n", "x" }, "<leader>gs", function() MiniGit.show_at_cursor({ split = "horizontal" }) end, { desc = "Show at cursor" })
  vim.keymap.set("n", "<leader>W", MiniMisc.setup_auto_root, { desc = "Change working dir" })
  vim.keymap.set("n", "<leader>z", MiniMisc.zoom, { desc = "Zoom" })
  vim.keymap.set("n", "<leader>=", MiniMisc.resize_window, { desc = "Resize to default size" })
  vim.keymap.set("n", "<leader>/", MiniPick.builtin.grep_live, { desc = "Live grep" })
  vim.keymap.set("n", "<leader>?", MiniPick.builtin.help, { desc = "Help" })
  vim.keymap.set("n", "<leader><leader>", MiniPick.builtin.files, { desc = "Files" })

  vim.keymap.set("n", "<c-p>", function()
    MiniPick.builtin.buffers(nil, {
      mappings = {
        wipeout = {
          char = "<c-d>",
          func = function() vim.api.nvim_buf_delete(MiniPick.get_picker_matches().current.bufnr, {}) end,
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
end)

safely("filetype:lua", function()
  vim.api.nvim_buf_create_user_command(0, "GenerateDocs", MiniDoc.generate, { desc = "mini: generate docs" })
  vim.api.nvim_buf_create_user_command(0, "RunAllTests", MiniTest.run, { desc = "mini: run all tests" })
  vim.api.nvim_buf_create_user_command(0, "RunTest", MiniTest.run_at_location, { desc = "mini: run test" })
end)
