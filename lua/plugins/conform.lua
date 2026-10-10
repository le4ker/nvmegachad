local utils_formatter = require("utils.formatter")

return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  opts = {
    formatters_by_ft = {
      c = { "clang-format" },
      cpp = { "clang-format" },
      css = { "prettier" },
      dockerfile = { "dockerfmt" },
      go = { "goimports" },
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
    formatters = {
      isort = {
        prepend_args = { "--profile", "black" },
      },
    },
    format_on_save = utils_formatter.format_on_save,
  },
}
