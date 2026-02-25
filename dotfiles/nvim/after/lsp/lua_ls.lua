return {
  settings = {
    Lua = {
      completion = { callSnippet = "Replace" },
      telemetry = { enable = false },
      diagnostics = {
        globals = { "vim", "Snacks" },
        disable = { "missing-fields" },
      },
    },
  },
}
