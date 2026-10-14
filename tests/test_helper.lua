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

function M.test(name, fn)
  M.cases[#M.cases + 1] = { name = name, run = fn }
end

function M.eq(actual, expected, message)
  if actual ~= expected then
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

  local ok, err = pcall(fn)
  for _, name in ipairs(names) do
    package.loaded[name] = previous[name]
  end
  assert(ok, err)
end

function M.run()
  for _, case in ipairs(M.cases) do
    local ok, err = pcall(case.run)
    for i = #M._stubs, 1, -1 do
      pcall(M._stubs[i])
      M._stubs[i] = nil
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
