local lint = require("lint")

lint.linters_by_ft = {
  go = { "golangcilint" },
  markdown = { "markdownlint" },
  python = { "pylint" },
  sh = { "shellcheck" },
  make = { "checkmake" },
  terraform = { "tflint" },
  dockerfile = { "hadolint" },
}

-- Configure pylint to use the active Python environment (Poetry venv → local .venv → system fallback)
lint.linters.pylint.cmd = function()
  return require("utils.python_env").pylint_command(vim.api.nvim_buf_get_name(0))
end

vim.api.nvim_create_autocmd("BufWritePost", {
  desc = "Lint buffer after saving",
  callback = function()
    lint.try_lint()
  end,
})
