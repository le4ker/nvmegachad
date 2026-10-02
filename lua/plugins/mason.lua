return {
  "williamboman/mason.nvim",
  lazy = false,
  config = function(_, opts)
    require("mason").setup(opts)
    local mason_registry = require "mason-registry"
    local ensure_installed = opts.ensure_installed or {}

    -- Ensure all listed tools are installed
    mason_registry.refresh(function()
      for _, tool in ipairs(ensure_installed) do
        local ok, package = pcall(mason_registry.get_package, tool)
        if ok and not package:is_installed() then
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
  end,
  opts = {
    max_concurrent_installers = 10,
    ensure_installed = {
      "mbake",
      "bash-language-server",
      "black",
      "checkmake",
      "clangd",
      "clang-format",
      "css-lsp",
      "debugpy",
      "delve",
      "dockerfmt",
      "dockerfile-language-server",
      "goimports",
      "golangci-lint",
      "gopls",
      "html-lsp",
      "isort",
      "json-lsp",
      "stylua",
      "taplo",
      "terraform-ls",
      "tflint",
      "typescript-language-server",
      "lua-language-server",
      "markdownlint",
      "marksman",
      "prettier",
      "pylint",
      "pyright",
      "rubocop",
      "ruby-lsp",
      "shfmt",
      "sql-formatter",
      "vim-language-server",
      "yaml-language-server",
    },
  },
}
