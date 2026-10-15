local M = { cases = {} }
M._stubs = {}

function M.stub(target, key, replacement)
  local original = target[key]
  target[key] = replacement
  M._stubs[#M._stubs + 1] = function()
    target[key] = original
  end
  return original
end

function M.cleanup(fn)
  M._stubs[#M._stubs + 1] = fn
end

function M.test(name, fn)
  M.cases[#M.cases + 1] = { name = name, run = fn }
end

function M.eq(actual, expected, message)
  if not vim.deep_equal(actual, expected) then
    error(message or ("expected %s, got %s"):format(vim.inspect(expected), vim.inspect(actual)), 2)
  end
end

function M.with_modules(modules, fn)
  local previous, names = {}, {}
  for name, module in pairs(modules) do
    names[#names + 1] = name
    previous[name] = package.loaded[name]
    package.loaded[name] = module
  end

  local ok, err = xpcall(fn, debug.traceback)
  for _, name in ipairs(names) do
    package.loaded[name] = previous[name]
  end
  if not ok then
    error(err, 0)
  end
end

local function snapshot_globals()
  local values = {}
  for key, value in pairs(vim.g) do
    values[key] = vim.deepcopy(value)
  end
  return values
end

local function restore_globals(values)
  local current = {}
  for key in pairs(vim.g) do
    current[#current + 1] = key
  end
  for _, key in ipairs(current) do
    if values[key] == nil then
      vim.g[key] = nil
    end
  end
  for key, value in pairs(values) do
    vim.g[key] = value
  end
end

local function is_config_module(name)
  return name == "mappings"
    or name == "options"
    or name == "chadrc"
    or name == "autocmds"
    or name:match("^configs\\.")
    or name:match("^plugins\\.")
    or name:match("^utils\\.")
end

function M.run()
  assert(#M.cases > 0, "no tests registered")
  for _, case in ipairs(M.cases) do
    local globals = snapshot_globals()
    local modules = {}
    for name, module in pairs(package.loaded) do
      modules[name] = module
    end
    local ok, err = xpcall(case.run, debug.traceback)
    for i = #M._stubs, 1, -1 do
      pcall(M._stubs[i])
      M._stubs[i] = nil
    end
    restore_globals(globals)
    for name in pairs(package.loaded) do
      if modules[name] == nil and is_config_module(name) then
        package.loaded[name] = nil
      end
    end
    for name, module in pairs(modules) do
      package.loaded[name] = module
    end
    if not ok then
      io.stderr:write(("FAIL: %s\n%s\n"):format(case.name, tostring(err)))
      M.failures = (M.failures or 0) + 1
    else
      print("PASS: " .. case.name)
    end
  end

  local failures = M.failures or 0
  print(("%d tests passed, %d failed"):format(#M.cases - failures, failures))
  if failures > 0 then
    os.exit(1)
  end
end

return M
