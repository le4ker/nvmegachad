local T = require("test_helper")

local with_environment = require("support.python_env").with_environment

T.test("Python environment detection prefers a local venv with an executable Python", function()
  local python_env = require("utils.python_env")
  local root = "/project"
  local project_file = root .. "/pyproject.toml"
  local venv = root .. "/.venv"
  local python = venv .. "/bin/python"

  T.stub(vim.fs, "find", function(names)
    if type(names) == "table" then
      return { project_file }
    end
    return {}
  end)
  T.stub(vim.fn, "filereadable", function(path)
    return path == project_file and 1 or 0
  end)
  T.stub(vim.fn, "readfile", function()
    return {}
  end)
  T.stub(vim.fn, "isdirectory", function(path)
    return path == venv and 1 or 0
  end)
  T.stub(vim.fn, "executable", function(path)
    return path == python and 1 or 0
  end)

  T.eq(python_env.python_path(root, true), python)
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
    local old_system
    old_system = T.stub(vim.fn, "system", function(...)
      calls = calls + 1
      return old_system(...)
    end)
    local python_env = require("utils.python_env")
    T.eq(python_env.python_path(root, true), paths.poetry_python)
    T.eq(python_env.python_path(root, true), paths.poetry_python)
    T.eq(calls, 1)
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
      T.stub(vim.fs, "find", function(names)
        if names == ".git" then
          return { root .. "/.git" }
        end
        return {}
      end)
      T.eq(require("utils.python_env").python_path(root .. "/nested", true), paths.python)
    end
  )
end)

T.test("Poetry pyproject header tolerates surrounding whitespace", function()
  local root = "/tests/poetry-header-whitespace"
  with_environment(root, {
    project = true,
    poetry_header = "  [tool.poetry]  ",
    poetry_env_dir = true,
    poetry_path = root .. "/poetry-env",
    executables = { poetry = true, [root .. "/poetry-env/bin/python"] = true },
  }, function(paths)
    T.eq(require("utils.python_env").python_path(root, true), paths.poetry_python)
  end)
end)

T.test("other Poetry tables in pyproject.toml do not make a Poetry project", function()
  local root = "/tests/poetry-subtable"
  with_environment(root, {
    project = true,
    poetry_header = "[tool.poetry.dependencies]",
    poetry_env_dir = true,
    venv_dir = true,
    poetry_path = root .. "/poetry-env",
    executables = {
      poetry = true,
      [root .. "/poetry-env/bin/python"] = true,
      [root .. "/.venv/bin/python"] = true,
    },
  }, function(paths)
    T.eq(require("utils.python_env").python_path(root, true), paths.python)
  end)
end)

T.test("an environment with both Python and Pylint wins over one with only Python", function()
  local root = "/tests/pylint-preference"
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
      [root .. "/.venv/bin/pylint"] = true,
    },
  }, function(paths)
    local env = require("utils.python_env")
    T.eq(env.python_path(root, true), paths.python)
    T.eq(env.pylint_command(root, true), paths.pylint)
  end)
end)

T.test("Windows uses the Scripts directory and .exe executables", function()
  local has = vim.fn.has
  T.stub(vim.fn, "has", function(feature)
    if feature == "win32" then
      return 1
    end
    return has(feature)
  end)
  local root = "/tests/windows-venv"
  with_environment(root, {
    venv_dir = true,
    executables = {
      [root .. "/.venv/Scripts/python.exe"] = true,
      [root .. "/.venv/Scripts/pylint.exe"] = true,
    },
  }, function()
    local env = require("utils.python_env")
    T.eq(env.python_path(root, true), root .. "/.venv/Scripts/python.exe")
    T.eq(env.pylint_command(root, true), root .. "/.venv/Scripts/pylint.exe")
  end)
end)
