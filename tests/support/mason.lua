local M = {}

-- Runs `run` with `mason` and `mason-registry` replaced by stubs, restoring the originals after.
function M.with_mason_mocks(registry, run)
  local original_mason = package.loaded.mason
  local original_registry = package.loaded["mason-registry"]
  package.loaded.mason = { setup = function() end }
  package.loaded["mason-registry"] = registry

  local ok, err = pcall(run)
  package.loaded.mason = original_mason
  package.loaded["mason-registry"] = original_registry
  assert(ok, err)
end

return M
