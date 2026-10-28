return {
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      completion = { callSnippet = "Replace" },
      telemetry = { enable = false },
      diagnostics = {
        disable = { "missing-fields" },
      },
      workspace = {
        checkThirdParty = "Disable",
      },
    },
  },
}
