local T = require("test_helper")

local M = {}

-- Runs `run` with `mason` and `mason-registry` replaced by stubs, restoring the originals after.
function M.with_mason_mocks(registry, run)
  T.with_modules({
    mason = { setup = function() end },
    ["mason-registry"] = registry,
  }, run)
end

return M
