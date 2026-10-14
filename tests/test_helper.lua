local M = { cases = {} }

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
    if not ok then
      io.stderr:write(("FAIL: %s\n%s\n"):format(case.name, tostring(err)))
      os.exit(1)
    end
    print("PASS: " .. case.name)
  end

  print(("%d tests passed"):format(#M.cases))
end

return M
