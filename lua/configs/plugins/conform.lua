require("conform").setup {
  formatters_by_ft = {
    c = { "clang-format" },
    cpp = { "clang-format" },
    css = { "prettier" },
    go = { "goimports", "gofmt" },
    graphql = { "prettier" },
    html = { "prettier" },
    javascript = { "prettier" },
    javascriptreact = { "prettier" },
    json = { "prettier" },
    lua = { "stylua" },
    make = { "bake" },
    markdown = { "prettier" },
    python = { "isort", "black" },
    scss = { "prettier" },
    sh = { "shfmt" },
    sql = { "sql_formatter" },
    ruby = { "rubocop" },
    terraform = { "terraform_fmt" },
    toml = { "taplo" },
    typescript = { "prettier" },
    typescriptreact = { "prettier" },
    yaml = { "prettier" },
    zsh = { "shfmt" },
  },
  format_on_save = function()
    if not vim.g.format_on_save then
      return
    end
    return { lsp_format = "fallback", timeout_ms = 3000 }
  end,
}
