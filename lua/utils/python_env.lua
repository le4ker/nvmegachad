local M = {}

local is_windows = vim.fn.has("win32") == 1
local python_relative = is_windows and "Scripts/python.exe" or "bin/python"
local pylint_relative = is_windows and "Scripts/pylint.exe" or "bin/pylint"

local function find_project_root(start_path, is_directory)
  if not start_path or start_path == "" then
    start_path = vim.fn.getcwd()
    is_directory = true
  end

  local start_dir = is_directory and start_path or vim.fs.dirname(start_path)
  if not start_dir or start_dir == "" then
    start_dir = vim.fn.getcwd()
  end

  local marker = vim.fs.find({ "poetry.lock", "pyproject.toml" }, {
    path = start_dir,
    upward = true,
    type = "file",
  })[1]

  local git_marker = vim.fs.find(".git", { path = start_dir, upward = true })[1]
  local git_root = git_marker and vim.fs.dirname(git_marker)

  return (marker and vim.fs.dirname(marker)) or git_root or start_dir
end

local function is_poetry_project(root)
  if vim.fn.filereadable(vim.fs.joinpath(root, "poetry.lock")) == 1 then
    return true
  end

  local pyproject = vim.fs.joinpath(root, "pyproject.toml")
  if vim.fn.filereadable(pyproject) == 0 then
    return false
  end

  for _, line in ipairs(vim.fn.readfile(pyproject)) do
    if line:match("^%s*%[tool%.poetry%]%s*$") then
      return true
    end
  end

  return false
end

local function poetry_environment(root)
  if not is_poetry_project(root) or vim.fn.executable("poetry") ~= 1 then
    return nil
  end

  local result =
    vim.fn.system("cd " .. vim.fn.shellescape(root) .. " && poetry env info -p 2>/dev/null")
  local env = vim.fn.trim(result)
  if vim.v.shell_error == 0 and env ~= "" and vim.fn.isdirectory(env) == 1 then
    return env
  end
end

local function selected_environment(start_path, is_directory)
  local root = find_project_root(start_path, is_directory)
  local environments = {}
  local poetry_env = poetry_environment(root)

  if poetry_env then
    table.insert(environments, poetry_env)
  end

  local local_env = vim.fs.joinpath(root, ".venv")
  if vim.fn.isdirectory(local_env) == 1 and local_env ~= poetry_env then
    table.insert(environments, local_env)
  end

  for _, env in ipairs(environments) do
    local python = vim.fs.joinpath(env, python_relative)
    local pylint = vim.fs.joinpath(env, pylint_relative)
    if vim.fn.executable(python) == 1 and vim.fn.executable(pylint) == 1 then
      return env
    end
  end

  for _, env in ipairs(environments) do
    local python = vim.fs.joinpath(env, python_relative)
    if vim.fn.executable(python) == 1 then
      return env
    end
  end
end

function M.python_path(start_path, is_directory)
  local env = selected_environment(start_path, is_directory)
  if env then
    return vim.fs.joinpath(env, python_relative)
  end
end

function M.pylint_command(start_path, is_directory)
  local env = selected_environment(start_path, is_directory)
  if env then
    local pylint = vim.fs.joinpath(env, pylint_relative)
    if vim.fn.executable(pylint) == 1 then
      return pylint
    end
  end

  return "pylint"
end

return M
