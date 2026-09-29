local lint = require "lint"

lint.linters_by_ft = {
  go = { "golangcilint" },
  markdown = { "markdownlint" },
  python = { "pylint" },
  ruby = { "rubocop" },
  make = { "checkmake" },
  terraform = { "tflint" },
}

-- Configure pylint to use the active Python environment (Poetry venv → local .venv → system fallback)
lint.linters.pylint.cmd = function()
  local util = require "lspconfig.util"
  local bufname = vim.api.nvim_buf_get_name(0)
  local buf_dir = vim.fs.dirname(bufname)
  local project_root = util.root_pattern("poetry.lock", "pyproject.toml")(buf_dir)
  local root_dir = project_root or util.find_git_ancestor(bufname) or buf_dir
  local poetry_root

  if project_root then
    if vim.fn.filereadable(project_root .. "/poetry.lock") == 1 then
      poetry_root = project_root
    end

    for _, line in ipairs(vim.fn.readfile(project_root .. "/pyproject.toml")) do
      if line:match("^%s*%[tool%.poetry%]%s*$") then
        poetry_root = project_root
        break
      end
    end
  end

  if poetry_root then
    local result = vim.fn.system("cd " .. vim.fn.shellescape(poetry_root) .. " && poetry env info -p 2>/dev/null")
    if vim.v.shell_error == 0 then
      local venv = vim.fn.trim(result)
      if venv ~= "" then
        local poetry_pylint = venv .. "/bin/pylint"
        if vim.fn.executable(poetry_pylint) == 1 then
          return poetry_pylint
        end
      end
    end
  end

  -- Fallback: check for local .venv directory
  local local_venv = util.path.join(root_dir, ".venv")
  local local_pylint = local_venv .. "/bin/pylint"
  if vim.fn.executable(local_pylint) == 1 then
    return local_pylint
  end

  -- Final fallback to system pylint
  return "pylint"
end

local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
  group = lint_augroup,
  callback = function()
    lint.try_lint()
  end,
})
