local lint = require "lint"

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

local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
  group = lint_augroup,
  callback = function()
    lint.try_lint()
  end,
})
