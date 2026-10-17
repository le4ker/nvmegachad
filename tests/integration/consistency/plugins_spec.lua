local T = require("test_helper")

T.test("every plugin file returns a valid Lazy spec or list of specs", function()
  for _, path in ipairs(vim.fn.glob("lua/plugins/*.lua", false, true)) do
    local result = dofile(path)
    assert(type(result) == "table", path .. " must return a table")
    local specs = result[1] and type(result[1]) == "string" and { result } or result
    assert(#specs > 0, path .. " returned no plugin specs")
    for _, spec in ipairs(specs) do
      assert(type(spec) == "table", path .. " contains a non-table plugin spec")
      assert(type(spec[1]) == "string", path .. " spec is missing its plugin name")
    end
  end
end)

T.test("every disabled plugin spec sets enabled = false", function()
  for _, spec in ipairs(require("plugins.disabled")) do
    assert(spec.enabled == false, "disabled plugin lacks enabled = false")
  end
end)

T.test("every enabled plugin and dependency has an entry in lazy-lock.json", function()
  local lock = vim.json.decode(table.concat(vim.fn.readfile("lazy-lock.json"), "\n"))
  local missing = {}

  local function check(plugin)
    local repo = type(plugin) == "table" and plugin[1] or plugin
    local name = type(plugin) == "table" and plugin.name or repo:gsub("^.*/", "")
    if not lock[name] then
      missing[#missing + 1] = repo
    end
  end

  for _, path in ipairs(vim.fn.glob("lua/plugins/*.lua", false, true)) do
    local result = dofile(path)
    local specs = type(result[1]) == "string" and { result } or result
    for _, spec in ipairs(specs) do
      if spec.enabled ~= false then
        check(spec)
        local dependencies = spec.dependencies
        for _, dependency in
          ipairs(type(dependencies) == "string" and { dependencies } or dependencies or {})
        do
          check(dependency)
        end
      end
    end
  end

  table.sort(missing)
  assert(
    #missing == 0,
    "plugins missing from lazy-lock.json (run :Lazy sync and commit it): "
      .. table.concat(missing, ", ")
  )
end)
