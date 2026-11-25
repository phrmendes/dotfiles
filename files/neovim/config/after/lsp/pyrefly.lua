local method = "workspace/didChangeWatchedFiles"

---@param registration lsp.Registration
local function suffix_id(registration)
  if registration.method ~= method then return end

  registration.id = ("%s-%s"):format(registration.id, vim.fn.sha256(vim.inspect(registration.registerOptions)):sub(1, 8))
end

---@param registration lsp.Registration
---@return fun(unregisteration: lsp.Unregistration): boolean
local function is_unregistered_by(registration)
  return function(unregisteration) return unregisteration.method == method and vim.startswith(registration.id, unregisteration.id .. "-") end
end

---@param unregisterations lsp.Unregistration[]
---@return fun(registration: lsp.Registration): boolean
local function is_suffixed_by(unregisterations)
  return function(registration) return vim.iter(unregisterations):any(is_unregistered_by(registration)) end
end

---@param registration lsp.Registration
---@return lsp.Unregistration
local function to_unregistration(registration) return { id = registration.id, method = method } end

-- pyrefly registers several file watchers under the same id. Neovim keeps one watcher per id, so
-- each new registration cancels the previous one and the project's .py files stop being watched.
-- Suffix every id with a hash of its watchers, and unregister all the suffixed ids together.
return {
  capabilities = {
    workspace = { didChangeWatchedFiles = { dynamicRegistration = true } },
  },
  handlers = {
    ---@type lsp.Handler
    ["client/registerCapability"] = function(err, result, ctx)
      ---@cast result lsp.RegistrationParams

      vim.iter(result.registrations):each(suffix_id)

      return vim.lsp.handlers["client/registerCapability"](err, result, ctx)
    end,
    ---@type lsp.Handler
    ["client/unregisterCapability"] = function(err, result, ctx)
      ---@cast result lsp.UnregistrationParams
      local client = assert(vim.lsp.get_client_by_id(ctx.client_id))
      local suffixed = vim.iter(client.dynamic_capabilities:get(method) or {}):filter(is_suffixed_by(result.unregisterations)):totable()

      vim.list_extend(result.unregisterations, vim.tbl_map(to_unregistration, suffixed))

      return vim.lsp.handlers["client/unregisterCapability"](err, result, ctx)
    end,
  },
}
