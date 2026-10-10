local treesitter = require("nvim-treesitter")

local parsers = {
  "bash",
  "c",
  "cpp",
  "css",
  "csv",
  "diff",
  "dockerfile",
  "go",
  "gosum",
  "gomod",
  "git_config",
  "gitignore",
  "graphql",
  "hcl",
  "html",
  "htmldjango",
  "ini",
  "javascript",
  "json",
  "lua",
  "make",
  "markdown",
  "markdown_inline",
  "mermaid",
  "nginx",
  "python",
  "requirements",
  "ruby",
  "scss",
  "sql",
  "starlark",
  "terraform",
  "toml",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "xml",
  "yaml",
}

treesitter.setup({})
treesitter.install(parsers)

vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    pcall(vim.treesitter.start, args.buf, args.match)
  end,
  desc = "Enable Tree-sitter highlighting",
})
