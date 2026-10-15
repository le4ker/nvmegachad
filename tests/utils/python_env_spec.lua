local T = require("test_helper")

local function with_environment(root, opts, callback)
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
    return opts.poetry_header and { "[tool.poetry]" } or {}
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

T.test("Python environment detection prefers a local venv with an executable Python", function()
  local python_env = require("utils.python_env")
  local original_find = vim.fs.find
  local original_executable = vim.fn.executable
  local original_filereadable = vim.fn.filereadable
  local original_isdirectory = vim.fn.isdirectory
  local original_readfile = vim.fn.readfile
  local root = "/project"
  local project_file = root .. "/pyproject.toml"
  local venv = root .. "/.venv"
  local python = venv .. "/bin/python"

  vim.fs.find = function(names)
    if type(names) == "table" then
      return { project_file }
    end
    return {}
  end
  vim.fn.filereadable = function(path)
    return path == project_file and 1 or 0
  end
  vim.fn.readfile = function()
    return {}
  end
  vim.fn.isdirectory = function(path)
    return path == venv and 1 or 0
  end
  vim.fn.executable = function(path)
    return path == python and 1 or 0
  end

  local ok, result = pcall(python_env.python_path, root, true)

  vim.fs.find = original_find
  vim.fn.executable = original_executable
  vim.fn.filereadable = original_filereadable
  vim.fn.isdirectory = original_isdirectory
  vim.fn.readfile = original_readfile

  assert(ok, result)
  T.eq(result, python)
end)

T.test("Python environment detection prefers Poetry over a local venv", function()
  local python_env = require("utils.python_env")
  local root = "/tests/poetry-precedence"
  with_environment(root, {
    project = true,
    poetry = true,
    poetry_env_dir = true,
    venv_dir = true,
    poetry_path = root .. "/poetry-env",
    executables = {
      poetry = true,
      [root .. "/poetry-env/bin/python"] = true,
      [root .. "/.venv/bin/python"] = true,
    },
  }, function(paths)
    T.eq(python_env.python_path(root, true), paths.poetry_python)
  end)
end)

T.test("Python environment detection falls back to the local venv", function()
  local python_env = require("utils.python_env")
  local root = "/tests/poetry-fallback"
  with_environment(root, {
    project = true,
    poetry = true,
    poetry_env_dir = true,
    venv_dir = true,
    poetry_path = root .. "/poetry-env",
    executables = {
      poetry = true,
      [root .. "/.venv/bin/python"] = true,
    },
  }, function(paths)
    T.eq(python_env.python_path(root, true), paths.python)
  end)
end)

T.test("Python environment detection uses system fallback when no venv exists", function()
  local python_env = require("utils.python_env")
  local root = "/tests/system-fallback"
  with_environment(root, { executables = {} }, function()
    T.eq(python_env.python_path(root, true), nil)
    T.eq(python_env.pylint_command(root, true), "pylint")
  end)
end)

T.test("Pylint uses the local venv executable when available", function()
  local python_env = require("utils.python_env")
  local root = "/tests/pylint-venv"
  with_environment(root, {
    project = true,
    venv_dir = true,
    executables = {
      [root .. "/.venv/bin/python"] = true,
      [root .. "/.venv/bin/pylint"] = true,
    },
  }, function(paths)
    T.eq(python_env.pylint_command(root, true), paths.pylint)
  end)
end)

T.test("Poetry environment lookup is cached once per project root", function()
  local root, calls = "/tests/poetry-cache", 0
  with_environment(root, {
    project = true,
    poetry_header = true,
    poetry_env_dir = true,
    poetry_path = root .. "/poetry-env",
    executables = { poetry = true, [root .. "/poetry-env/bin/python"] = true },
  }, function(paths)
    local old_system = vim.fn.system
    vim.fn.system = function(...)
      calls = calls + 1
      return old_system(...)
    end
    local python_env = require("utils.python_env")
    T.eq(python_env.python_path(root, true), paths.poetry_python)
    T.eq(python_env.python_path(root, true), paths.poetry_python)
    T.eq(calls, 1)
    vim.fn.system = old_system
  end)
end)

T.test("failed Poetry lookup falls back to local venv and system pylint", function()
  local root = "/tests/poetry-shell-error"
  with_environment(root, {
    project = true,
    poetry = true,
    shell_error = 1,
    poetry_env_dir = true,
    venv_dir = true,
    poetry_path = root .. "/poetry-env",
    executables = { poetry = true, [root .. "/.venv/bin/python"] = true },
  }, function(paths)
    local env = require("utils.python_env")
    T.eq(env.python_path(root, true), paths.python)
    T.eq(env.pylint_command(root, true), "pylint")
  end)
end)

T.test("Python root detection uses git marker or start directory and accepts file paths", function()
  local root = "/tests/root-detection"
  with_environment(
    root,
    { venv_dir = true, executables = { [root .. "/.venv/bin/python"] = true } },
    function(paths)
      local old_dirname, searched = vim.fs.dirname, nil
      T.stub(vim.fs, "dirname", function(path)
        if path == root .. "/main.py" then
          return root
        end
        return old_dirname(path)
      end)
      T.stub(vim.fs, "find", function(names, opts)
        searched = opts.path
        return {}
      end)
      local env = require("utils.python_env")
      T.eq(env.python_path(root .. "/main.py", false), paths.python)
      T.eq(searched, root)
    end
  )
end)

T.test("Poetry pyproject header is recognized without a lock file", function()
  local root = "/tests/poetry-header"
  with_environment(root, {
    project = true,
    poetry_header = true,
    poetry_env_dir = true,
    poetry_path = root .. "/poetry-env",
    executables = { poetry = true, [root .. "/poetry-env/bin/python"] = true },
  }, function(paths)
    T.eq(require("utils.python_env").python_path(root, true), paths.poetry_python)
  end)
end)

T.test("Python root detection falls back to a git marker", function()
  local root = "/tests/git-root"
  with_environment(
    root,
    { venv_dir = true, executables = { [root .. "/.venv/bin/python"] = true } },
    function(paths)
      local old_find = vim.fs.find
      vim.fs.find = function(names)
        if names == ".git" then
          return { root .. "/.git" }
        end
        return {}
      end
      T.eq(require("utils.python_env").python_path(root .. "/nested", true), paths.python)
      vim.fs.find = old_find
    end
  )
end)
