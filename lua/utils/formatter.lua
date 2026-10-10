local M = {}

function M.format_on_save()
  if not vim.g.format_on_save then
    return
  end

  return {
    lsp_format = "fallback",
    timeout_ms = 1000,
  }
end

return M
