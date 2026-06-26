package.preload["sidekick.cli.picker.mini.pick"] = function()
  local M = {}

  local parse = {}

  function parse.table(item)
    local buf = item.bufnr or item.buf
    if buf and vim.api.nvim_buf_is_valid(buf) then return {
      buf = buf,
      name = item.path or vim.api.nvim_buf_get_name(buf),
    } end
    if type(item.path) == "string" then return { name = item.path, row = item.lnum, col = item.col } end
  end

  function parse.string(item)
    local lnum, col = item:match("%z(%d+)%z?(%d*)")
    local path = item:match("^(.-)%z") or item
    if path:sub(1, 1) == "~" then path = (vim.loop.os_homedir() or "~") .. path:sub(2) end
    if path == "" then return nil end
    return {
      name = path,
      row = tonumber(lnum),
      col = tonumber(col),
    }
  end

  function parse.item(item)
    if type(item) == "table" then return parse.table(item) end
    return parse.string(item)
  end

  function M.action(cb)
    return function(item_or_items)
      local items = vim.islist(item_or_items) and item_or_items or { item_or_items }
      local result = vim.iter(items):map(parse.item):filter(function(loc) return loc ~= nil end):totable()
      if #result > 0 then cb(result) end
    end
  end

  local sources = {
    files = "files",
    buffers = "buffers",
    grep = "grep_live",
  }

  function M.open(source, cb, opts)
    local builtin = sources[source]
    if not builtin or not MiniPick.builtin[builtin] then return end

    MiniPick.builtin[builtin](
      {},
      vim.tbl_deep_extend("force", opts or {}, {
        source = {
          choose = M.action(cb),
          choose_marked = M.action(cb),
        },
      })
    )
  end

  function M.send(...)
    local ok, picker = pcall(require, "sidekick.cli.picker")
    if ok then M.action(picker._send_cb())(...) end
  end

  return M
end

safely("now", function()
  local cli = require("sidekick.cli")

  require("sidekick").setup({
    nes = { enabled = false },
    cli = {
      picker = "mini.pick",
      mux = { backend = "tmux", enabled = true },
      prompts = {
        dev = "Load /skill:dev. Instructions: ",
        plan = "Load /skill:plan. Instructions: ",
        guide = "Load /skill:guide. Instructions: ",
        research = "Load /skill:research. Instructions: ",
        review = "Load /skill:review. Instructions: ",
      },
      win = {
        keys = {
          nav_left = false,
          nav_down = false,
          nav_up = false,
          nav_right = false,
        },
      },
    },
  })

  vim.keymap.set("n", "<leader>at", cli.toggle, { desc = "Toggle coding agent" })
  vim.keymap.set({ "n", "t", "i", "x" }, "<c-.>", cli.toggle, { desc = "Toggle" })
  vim.keymap.set({ "n", "x" }, "<leader>aa", function() cli.send({ msg = "{this}" }) end, { desc = "Send this" })
  vim.keymap.set({ "n", "x" }, "<leader>ap", cli.prompt, { desc = "Select prompt" })
  vim.keymap.set({ "n", "x" }, "<leader>ad", cli.close, { desc = "Detach" })
  vim.keymap.set({ "n", "x" }, "<leader>af", function() cli.send({ msg = "{file}" }) end, { desc = "Send file" })
  vim.keymap.set({ "n", "x" }, "<leader>as", cli.select, { desc = "Select CLI" })
end)
