local M = {}

-- Runs `callback` with filesystem, executable and Poetry lookups faked for a project at `root`.
-- `opts` describes the project (see the fields read below); the callback receives the expected paths.
function M.with_environment(root, opts, callback)
  local previous_module = package.loaded["utils.python_env"]
  package.loaded["utils.python_env"] = nil
  require("utils.python_env")
  local saved = {
    find = vim.fs.find,
    executable = vim.fn.executable,
    filereadable = vim.fn.filereadable,
    isdirectory = vim.fn.isdirectory,
    readfile = vim.fn.readfile,
    system = vim.fn.system,
  }
  local project_file = root .. "/pyproject.toml"
  local lock_file = root .. "/poetry.lock"
  local poetry_env = root .. "/poetry-env"
  local venv = root .. "/.venv"

  vim.fn.system("true")
  vim.fs.find = function(names)
    if type(names) == "table" then
      return opts.project and { project_file } or {}
    end
    return {}
  end
  vim.fn.filereadable = function(path)
    return ((opts.poetry and path == lock_file) or (opts.project and path == project_file)) and 1
      or 0
  end
  vim.fn.readfile = function()
    if not opts.poetry_header then
      return {}
    end
    return { opts.poetry_header == true and "[tool.poetry]" or opts.poetry_header }
  end
  vim.fn.isdirectory = function(path)
    if path == poetry_env then
      return opts.poetry_env_dir and 1 or 0
    end
    if path == venv then
      return opts.venv_dir and 1 or 0
    end
    return 0
  end
  vim.fn.executable = function(path)
    return opts.executables[path] and 1 or 0
  end
  vim.fn.system = function()
    saved.system(opts.shell_error and "false" or "true")
    return opts.poetry_path or ""
  end

  local ok, err = pcall(callback, {
    poetry_env = poetry_env,
    python = venv .. "/bin/python",
    pylint = venv .. "/bin/pylint",
    poetry_python = poetry_env .. "/bin/python",
    poetry_pylint = poetry_env .. "/bin/pylint",
  })

  vim.fs.find = saved.find
  vim.fn.executable = saved.executable
  vim.fn.filereadable = saved.filereadable
  vim.fn.isdirectory = saved.isdirectory
  vim.fn.readfile = saved.readfile
  vim.fn.system = saved.system
  package.loaded["utils.python_env"] = previous_module
  assert(ok, err)
end

return M
