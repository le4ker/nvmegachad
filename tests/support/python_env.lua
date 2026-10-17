local T = require("test_helper")

local M = {}

-- Runs `callback` with filesystem, executable and Poetry lookups faked for a project at `root`.
-- `opts` describes the project (see the fields read below); the callback receives the expected paths.
function M.with_environment(root, opts, callback)
  local previous_module = package.loaded["utils.python_env"]
  T.cleanup(function()
    package.loaded["utils.python_env"] = previous_module
  end)
  package.loaded["utils.python_env"] = nil
  require("utils.python_env")

  local project_file = root .. "/pyproject.toml"
  local lock_file = root .. "/poetry.lock"
  local poetry_env = root .. "/poetry-env"
  local venv = root .. "/.venv"

  vim.fn.system("true")
  local system = vim.fn.system
  T.stub(vim.fs, "find", function(names)
    if type(names) == "table" then
      return opts.project and { project_file } or {}
    end
    return {}
  end)
  T.stub(vim.fn, "filereadable", function(path)
    return ((opts.poetry and path == lock_file) or (opts.project and path == project_file)) and 1
      or 0
  end)
  T.stub(vim.fn, "readfile", function()
    if not opts.poetry_header then
      return {}
    end
    return { opts.poetry_header == true and "[tool.poetry]" or opts.poetry_header }
  end)
  T.stub(vim.fn, "isdirectory", function(path)
    if path == poetry_env then
      return opts.poetry_env_dir and 1 or 0
    end
    if path == venv then
      return opts.venv_dir and 1 or 0
    end
    return 0
  end)
  T.stub(vim.fn, "executable", function(path)
    return opts.executables[path] and 1 or 0
  end)
  T.stub(vim.fn, "system", function()
    system(opts.shell_error and "false" or "true")
    return opts.poetry_path or ""
  end)

  callback({
    poetry_env = poetry_env,
    python = venv .. "/bin/python",
    pylint = venv .. "/bin/pylint",
    poetry_python = poetry_env .. "/bin/python",
    poetry_pylint = poetry_env .. "/bin/pylint",
  })
end

return M
