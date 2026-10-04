---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "flex-light",
}

M.ui = {
  tabufline = {
    order = { "treeOffset", "buffers", "tabs" },
  },
  statusline = {
    theme = "default",
    separator_style = "block",
  },
}

M.cheatsheet = {
  theme = "grid",
}

return M
