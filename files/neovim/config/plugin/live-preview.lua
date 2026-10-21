local TIMEOUT_MINUTES = 30

--- A path that never exists, so the preview server answers 404.
local DENIED = "/dev/null/denied"

--- Stops the server after TIMEOUT_MINUTES. Created on the first start.
---@type uv.uv_timer_t?
local expiry

local guarded = false

local function preview() return require("livepreview") end

local function preview_utils() return require("livepreview.utils") end

local function preview_config() return require("livepreview.config").config end

---@param message string
local function warn(message) vim.notify(message, vim.log.levels.WARN) end

---@param relative string
local function has_hidden_part(relative)
  return vim.iter(vim.split(relative, "/", { plain = true })):any(function(part) return vim.startswith(part, ".") end)
end

--- True when `real` lies below `root` and no part of the path below `root` is hidden.
---@param root string
---@param real string
local function is_served(root, real)
  local real_root = vim.uv.fs_realpath(root)
  local relative = real_root and vim.fs.relpath(real_root, real)
  if not relative or relative == "." then return false end

  return not has_hidden_part(relative)
end

--- Serve only files below the web root or the plugin folder, never hidden files or symlinks that leave the root.
local function guard_routes()
  if guarded then return end

  local Server = require("livepreview.server").Server
  assert(type(Server.routes) == "function", "livepreview changed: Server.routes is gone, refusing to serve unguarded")

  local routes = Server.routes

  Server.routes = function(self, path)
    local resolved = routes(self, path)
    local real = vim.uv.fs_realpath(resolved)
    if not real then return resolved end

    local roots = { self.webroot, preview_utils().get_plugin_path() }
    local allowed = vim.iter(roots):any(function(root) return is_served(root, real) end)

    return allowed and resolved or DENIED
  end

  guarded = true
end

--- The first WireGuard IPv4 address, or nil. `get-wg-ip` prints JSON: [{ interface, addresses }].
---@return string?
local function wireguard_address()
  if vim.fn.executable("get-wg-ip") == 0 then return nil end

  local result = vim.system({ "get-wg-ip" }, { text = true }):wait(2000)
  if result.code ~= 0 then return nil end

  local ok, links = pcall(vim.json.decode, result.stdout)
  if not ok then return nil end

  return vim.iter(links):map(function(link) return link.addresses[1] end):next()
end

--- The file to preview and its path below the current directory.
---@param argument string A file, or "" for the current buffer.
---@return string? path
---@return string reason_or_relative The path below the current directory, or why there is no file.
local function resolve_target(argument)
  local utils = preview_utils()

  -- The argument, the current buffer, or the first supported buffer.
  local file = argument ~= "" and vim.fn.fnamemodify(argument, ":p") or vim.api.nvim_buf_get_name(0)
  local path = utils.supported_filetype(file) and file or (argument == "" and utils.find_supported_buf() or nil)
  if not path then return nil, "Preview supports markdown, html, svg and asciidoc files" end

  path = vim.fs.normalize(path)

  local cwd = assert(vim.uv.cwd(), "the current directory is unknown")
  local relative = vim.fs.relpath(cwd, path)
  if not relative then return nil, ("%s is outside %s"):format(path, cwd) end

  return path, relative
end

local function arm_expiry()
  expiry = expiry or assert(vim.uv.new_timer())
  expiry:stop()
  expiry:start(
    TIMEOUT_MINUTES * 60 * 1000,
    0,
    vim.schedule_wrap(function()
      preview().close()
      vim.notify(("Live preview stopped after %d minutes"):format(TIMEOUT_MINUTES))
    end)
  )
end

local function disarm_expiry()
  if expiry then expiry:stop() end
end

--- Show the ssh tunnel command and the URL for another machine, and copy the command.
---@param host string
---@param port integer
---@param relative string
local function announce(host, port, relative)
  local user = vim.uv.os_get_passwd().username
  local tunnel = ("ssh -N -L %d:127.0.0.1:%d %s@%s"):format(port, port, user, host)
  local url = ("http://localhost:%d/%s"):format(port, vim.uri_encode(relative))

  if vim.fn.has("clipboard") == 1 then vim.fn.setreg("+", tunnel) end

  vim.notify(table.concat({ "On the viewer, run:", tunnel, "Then open:", url }, "\n"))
end

--- Start the preview server and announce how to reach it from another machine.
---@param argument string A file, or "" for the current buffer.
local function start(argument)
  local path, relative = resolve_target(argument)
  if not path then return warn(relative) end

  local config = preview_config()
  if config.address ~= "127.0.0.1" then return warn(("The preview server must listen on 127.0.0.1, not on %s"):format(config.address)) end

  local host = wireguard_address()
  if not host then return warn("No WireGuard interface with an IPv4 address found (get-wg-ip must be installed)") end

  guard_routes()

  if not preview().start(path, config.port) then return warn("The preview server did not start") end

  arm_expiry()
  announce(host, config.port, relative)
end

--- The subcommands of :RemotePreview.
---@type table<string, { run: fun(args: string[]), complete: (fun(lead: string): string[])? }>
local subcommands = {
  start = {
    run = function(args) start(args[1] or "") end,
    complete = function(lead) return vim.fn.getcompletion(lead, "file") end,
  },
  stop = {
    run = function()
      disarm_expiry()
      preview().close()
    end,
  },
  status = {
    run = function()
      if not preview().is_running() then return vim.notify("Live preview is stopped") end

      vim.notify(("Live preview runs on port %d"):format(preview_config().port))
    end,
  },
}

--- The sorted names of the subcommands that start with `lead`.
---@param lead string
local function subcommand_names(lead)
  local names = vim.tbl_keys(subcommands)
  table.sort(names)

  return vim.iter(names):filter(function(name) return vim.startswith(name, lead) end):totable()
end

safely("now", function()
  vim.api.nvim_create_user_command("RemotePreview", function(opts)
    local name = opts.fargs[1] or "start"
    local subcommand = subcommands[name]
    if not subcommand then return warn(("RemotePreview: unknown subcommand '%s'"):format(name)) end

    subcommand.run(vim.list_slice(opts.fargs, 2))
  end, {
    nargs = "*",
    desc = "Preview a file for another machine: start [file], stop or status",
    complete = function(lead, line)
      local words = vim.split(line, "%s+", { trimempty = true })
      local typing_name = #words == 1 or (#words == 2 and not line:match("%s$"))
      if typing_name then return subcommand_names(lead) end

      local subcommand = subcommands[words[2]]
      if not subcommand or not subcommand.complete then return {} end

      return subcommand.complete(lead)
    end,
  })
end)
