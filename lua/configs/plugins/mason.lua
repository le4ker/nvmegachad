local M = {}

function M.setup(opts)
  require("mason").setup(opts)

  local mason_registry = require("mason-registry")
  local ensure_installed = opts.ensure_installed or {}

  -- Ensure all listed tools are installed
  mason_registry.refresh(function(success)
    if not success then
      vim.notify("Mason registry refresh failed", vim.log.levels.ERROR)
      return
    end

    for _, tool in ipairs(ensure_installed) do
      local ok, package = pcall(mason_registry.get_package, tool)
      if not ok then
        vim.notify("Mason: unknown package " .. tool, vim.log.levels.ERROR)
      elseif not package:is_installed() then
        package:install():once("closed", function()
          if not package:is_installed() then
            vim.schedule(function()
              vim.notify("Mason: failed to install " .. tool, vim.log.levels.ERROR)
            end)
          end
        end)
      end
    end
  end)
end

return M
