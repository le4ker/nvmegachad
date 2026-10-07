local M = {}

function M.update_mason_packages()
  local mason_registry = require("mason-registry")
  vim.cmd("Mason")
  mason_registry.update(function(success)
    if not success then
      vim.notify("Mason registry update failed", vim.log.levels.ERROR)
      return
    end

    local outdated = {}
    for _, package in ipairs(mason_registry.get_installed_packages()) do
      local latest_version = package:get_latest_version()
      if
        package:get_installed_version() ~= latest_version
        and package:is_installable({ version = latest_version })
      then
        table.insert(outdated, package)
      end
    end

    if #outdated == 0 then
      vim.notify("Mason packages are up to date")
      return
    end

    for _, package in ipairs(outdated) do
      package:install()
    end
    vim.notify(("Updating %d Mason package(s)"):format(#outdated))
  end)
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
  require("nvchad.term").new({ pos = "sp", size = 0.5 })
end

M.close_terminal = close_terminal

function M.previous_diagnostic()
  vim.diagnostic.jump({ count = -1 })
end

function M.next_diagnostic()
  vim.diagnostic.jump({ count = 1 })
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

return M
