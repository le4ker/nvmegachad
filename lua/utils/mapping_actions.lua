local M = {}

local mason_registry = require "mason-registry"
local mason_update_pending = false

mason_registry:on("update:success", function()
  if not mason_update_pending then
    return
  end

  mason_update_pending = false
  vim.schedule(function()
    vim.cmd "Mason"
    local key = vim.api.nvim_replace_termcodes("U", true, false, true)
    vim.api.nvim_feedkeys(key, "m", false)
  end)
end)

function M.update_mason_packages()
  local mason_ui_loaded = package.loaded["mason.ui.instance"] ~= nil
  mason_update_pending = true
  vim.cmd "Mason"

  if mason_ui_loaded then
    mason_registry.update()
  end
end

function M.toggle_format_on_save()
  vim.g.format_on_save = not vim.g.format_on_save
  vim.notify(vim.g.format_on_save and "Format on save enabled" or "Format on save disabled")
end

function M.toggle_inlay_hints()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
  vim.notify(vim.lsp.inlay_hint.is_enabled() and "Inlay hints enabled" or "Inlay hints disabled")
end

function M.next_buffer()
  require("nvchad.tabufline").next()
end

function M.previous_buffer()
  require("nvchad.tabufline").prev()
end

function M.close_buffer()
  require("nvchad.tabufline").close_buffer()
end

local function close_terminal()
  local buf = vim.api.nvim_get_current_buf()
  if vim.bo[buf].buftype == "terminal" then
    vim.api.nvim_win_close(vim.api.nvim_get_current_win(), true)
  end
end

function M.new_horizontal_terminal()
  require("nvchad.term").new { pos = "sp", size = 0.5 }
end

M.close_terminal = close_terminal

function M.previous_diagnostic()
  vim.diagnostic.jump { count = -1 }
end

function M.next_diagnostic()
  vim.diagnostic.jump { count = 1 }
end

function M.debug_go_test()
  require("dap-go").debug_test()
end

function M.debug_last_go_test()
  require("dap-go").debug_last_test()
end

function M.debug_python_test()
  require("dap-python").test_method()
end

function M.toggle_dap_ui()
  require("dapui").toggle()
end

local chat_zoomed = false

function M.toggle_chat_zoom()
  vim.cmd(chat_zoomed and "wincmd =" or "wincmd |")
  chat_zoomed = not chat_zoomed
end

return M
