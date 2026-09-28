# Playground

Minimal per-language projects for manually testing NvMegaChad changes. Every
file is deliberately messy (bad formatting, lint warnings, a type error) so that
a working setup visibly reacts.

## Per-file checklist

For each language, open the main file and check:

1. **LSP attached**: `:checkhealth lsp`, hover with `K`, go to definition into
   the sibling file.
2. **Diagnostics**: the marked lint or type errors show up.
3. **Format**: save or run the format mapping; the file should be rewritten
   cleanly.
4. **Debug** (Go and Python only): set a breakpoint at the marked line and start
   DAP.

## Layout

| Directory     | Open this                           | Exercises                              |
| ------------- | ----------------------------------- | -------------------------------------- |
| `go/`         | `main.go`                           | gopls, goimports, golangci-lint, delve |
| `python/`     | `main.py`                           | pyright, black, isort, pylint, debugpy |
| `c/`          | `main.c`                            | clangd, clang-format                   |
| `cpp/`        | `main.cpp`                          | clangd, clang-format                   |
| `lua/`        | `main.lua`                          | lua-language-server, stylua            |
| `ruby/`       | `main.rb`                           | ruby-lsp, rubocop                      |
| `typescript/` | `src/index.ts`, `src/legacy.js`     | typescript-language-server, prettier   |
| `web/`        | `index.html`, `styles.css`, `.scss` | html-lsp, css-lsp, prettier            |
| `json/`       | `sample.json`, `broken.json`        | json-language-server, prettier         |
| `graphql/`    | `schema.graphql`                    | prettier                               |
| `yaml/`       | `config.yaml`, `broken.yaml`        | yaml-language-server, prettier         |
| `markdown/`   | `index.md`                          | marksman, markdownlint, prettier       |
| `bash/`       | `script.sh`                         | bash-language-server, shfmt            |
| `docker/`     | `Dockerfile`                        | dockerfile-language-server             |
| `terraform/`  | `main.tf`                           | terraform-ls, terraform_fmt, tflint    |
| `toml/`       | `config.toml`                       | taplo                                  |
| `makefile/`   | `Makefile`                          | bake, checkmake                        |
| `vim/`        | `hello.vim`                         | vim-language-server                    |
| `sql/`        | `queries.sql`, `schema.sql`         | sql-formatter                          |

## Resetting

Formatting rewrites these files, so restore them with
`git checkout -- playground`.
