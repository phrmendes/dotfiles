local augroups = {
  attach = vim.api.nvim_create_augroup("UserLspAttach", {}),
  codelens = vim.api.nvim_create_augroup("UserLspCodelens", {}),
}

vim.lsp.enable({
  "astro",
  "basedpyright",
  "bashls",
  "copilot",
  "cssls",
  "docker_language_server",
  "dotls",
  "elixirls",
  "emmet_language_server",
  "eslint",
  "helm_ls",
  "html",
  "jsonls",
  "ltex_plus",
  "lua_ls",
  "marksman",
  "nixd",
  "ruff",
  "scls",
  "tailwindcss",
  "taplo",
  "terraformls",
  "ts_ls",
  "ty",
  "yamlls",
})

vim.api.nvim_create_autocmd("LspAttach", {
  desc = "Configure LSP buffer settings and keymaps",
  group = augroups.attach,
  callback = function(event)
    local client = assert(vim.lsp.get_client_by_id(event.data.client_id))

    vim.bo[event.buf].omnifunc = "v:lua.MiniCompletion.completefunc_lsp"

    if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlineCompletion, event.buf) then
      vim.lsp.inline_completion.enable(true, { bufnr = event.buf })

      vim.api.nvim_buf_create_user_command(
        event.buf,
        "LspCopilotDisable",
        function() vim.lsp.inline_completion.enable(false, { bufnr = event.buf }) end,
        { desc = "Disable LSP inline completions for the current buffer" }
      )
    end

    if client:supports_method(vim.lsp.protocol.Methods.textDocument_codeLens, event.buf) then
      vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
        buffer = event.buf,
        group = augroups.codelens,
        callback = function(ev) vim.lsp.codelens.enable(true, { bufnr = ev.buf }) end,
      })
    end

    if client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
      require("helpers").setup_lsp_document_highlight(event.buf)
    end

    require("keymaps.lsp")(client, event.buf)
  end,
})
