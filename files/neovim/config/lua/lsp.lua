local augroups = {
  attach = vim.api.nvim_create_augroup("UserLspAttach", {}),
}

vim.lsp.config("*", {
  capabilities = { workspace = { didChangeWatchedFiles = { dynamicRegistration = true } } },
})

vim.lsp.enable({
  "ansiblels",
  "astro",
  "basedpyright",
  "bashls",
  "cssls",
  "docker_language_server",
  "dot",
  "emmet_language_server",
  "eslint",
  "gitlab_ci_ls",
  "helm_ls",
  "html",
  "jsonls",
  "lua_ls",
  "nixd",
  "nushell",
  "pyrefly",
  "ruff",
  "rust_analyzer",
  "svelte",
  "taplo",
  "texlab",
  "tofu_ls",
  "tsc",
  "yamlls",
})

vim.api.nvim_create_autocmd("LspAttach", {
  desc = "Configure LSP buffer settings and keymaps",
  group = augroups.attach,
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)

    if not client then return end

    if vim.bo[event.buf].filetype == "sql" then
      vim.bo[event.buf].omnifunc = "vim_dadbod_completion#omni"
    else
      vim.bo[event.buf].omnifunc = "v:lua.MiniCompletion.completefunc_lsp"
    end

    require("keymaps.lsp")(client, event.buf)
  end,
})
