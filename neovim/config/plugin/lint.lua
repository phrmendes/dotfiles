safely("later", function()
  require("lint").linters_by_ft = {
    bash = { "shellcheck" },
    htmldjango = { "djlint" },
    jinja2 = { "djlint" },
    sh = { "shellcheck" },
    terraform = { "tflint" },
    zsh = { "shellcheck" },
  }

  safely("event:BufWritePost,BufReadPost,InsertLeave", function() require("lint").try_lint() end)
end)
