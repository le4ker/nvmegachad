return {
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "workspace",
      },
    },
  },
  before_init = function(_, config)
    local util = require "lspconfig.util"
    local poetry_root = util.root_pattern("poetry.lock", "pyproject.toml")(config.root_dir)
    if poetry_root then
      local result = vim.fn.system("cd " .. vim.fn.shellescape(poetry_root) .. " && poetry env info -p 2>/dev/null")
      if vim.v.shell_error == 0 then
        local venv = vim.fn.trim(result)
        if venv ~= "" then
          config.settings.python.pythonPath = venv .. "/bin/python"
        end
      end
    end
  end,
}
