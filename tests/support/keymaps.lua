local T = require("test_helper")

local M = {}

-- Loads a fresh copy of the mappings module while recording every vim.keymap.set call.
-- Returns a list of { mode, lhs, rhs, opts }; the stub and module cache are restored after the test.
function M.load_mappings()
  local maps = {}
  T.stub(vim.keymap, "set", function(mode, lhs, rhs, opts)
    maps[#maps + 1] = { mode = mode, lhs = lhs, rhs = rhs, opts = opts }
  end)
  package.loaded.mappings = nil
  require("mappings")
  return maps
end

return M
