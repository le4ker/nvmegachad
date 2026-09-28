# NvMegaChad — Claude Code Instructions

## Project Overview

NvMegaChad is a Neovim configuration built on **NvChad v2.5**, requiring
**Neovim 0.11+**. All configuration is written in Lua and managed via
**Lazy.nvim**.

## Repository Structure

```text
lua/
  chadrc.lua        # NvChad theme/UI overrides (theme, statusline, tabufline)
  options.lua       # vim.opt settings and vim.g feature toggles
  mappings.lua      # All keybindings — single source of truth
  unmappings.lua    # Removes conflicting NvChad defaults via safe_unmap()
  plugins/          # Lazy.nvim plugin specs — one file per plugin
  configs/          # Plugin setup — called by the corresponding plugin spec
lsp/                # Per-server LSP configs loaded by Neovim (runtimepath)
```

## Code Conventions

### Lua Style

- Formatter: **stylua** — always run before committing (`column_width = 120`,
  2-space indent, double quotes, no call parentheses)
- Local alias for keymaps: `local map = vim.keymap.set`
- All `map()` calls must include a `desc` field following the pattern
  `"Category Action Title"` (e.g. `"LSP Go To Definition"`,
  `"DAP Add Breakpoint At Line"`)

### Plugin Architecture

Each plugin follows a two-file pattern:

1. `lua/plugins/<name>.lua` — Lazy.nvim spec (plugin source, lazy-load event,
   calls `require "configs.<name>"`)
2. `lua/configs/<name>.lua` — actual `require("<plugin>").setup { ... }` call

Do not put setup logic in the plugin spec file.

### LSP Servers

- Server list lives in `lua/configs/lspconfig.lua` — add new servers to the
  `servers` table and call `vim.lsp.enable(servers)`
- Custom server config goes in `lsp/<server_name>.lua` — return a table
  merged with defaults by Neovim's native LSP loader
- Minimal servers with no customisation still get a file returning `{}`

### Adding a New Language

When adding support for a new language, update all of the following:

1. `lua/configs/lspconfig.lua` — add the LSP server name to `servers`
2. `lsp/<server>.lua` — create server config file (even if `return {}`)
3. `lua/configs/conform.lua` — add `filetype = { "formatter" }` entry
4. `lua/configs/lint.lua` — add `filetype = { "linter" }` entry if applicable
5. `lua/plugins/mason.lua` — add all tools to `ensure_installed`
6. `lua/plugins/treesitter.lua` — add the parser name to `ensure_installed`
   (parsers are auto-installed at runtime, but explicit listing is preferred)
7. `README.md` — add a row to the Supported Languages table and update the count
   in the Features list

### Keybindings

- All mappings go in `lua/mappings.lua` — never add `vim.keymap.set` calls in
  config or plugin files
- If a new mapping conflicts with an NvChad default, add a `safe_unmap()` call
  to `lua/unmappings.lua`
- Group mappings under a comment header matching their category (General, LSP,
  DAP, AI, etc.)

### Feature Toggles

Global on/off flags use `vim.g.*` and are initialised in `lua/options.lua`.
Example: `vim.g.format_on_save = true`. Toggle keybindings live in
`lua/mappings.lua`.

## Commit Conventions

Enforced via a commit-msg hook (`make hooks`). Format:

```
<type>(<scope>): <description>
```

Allowed types: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`,
`build`, `ci`, `chore`, `revert`

Scopes should reflect the file/subsystem changed (e.g. `conform`, `lsp`,
`mappings`, `mason`, `dap`).

## Key Design Decisions

- **Native LSP completion** (Neovim 0.11+): nvim-cmp and friends are
  intentionally disabled in `lua/plugins/disabled.lua`. Do not re-enable them.
  Per-server completion is wired in `lua/configs/completion.lua` via an
  `LspAttach` autocmd that calls `vim.lsp.completion.enable()`.
- **No null-ls**: formatting is handled by conform.nvim, linting by nvim-lint.
- **Tab/`<S-Tab>` are overloaded**: they navigate buffers in normal mode and
  cycle completions / jump snippets in insert/select mode. Do not remap these
  without accounting for both behaviours.
- **Poetry/venv auto-detection**: pyright and pylint both detect Poetry
  environments at runtime. Preserve this logic when modifying Python tooling.
- **`lua_ls` exception**: `lua_ls` is listed in `lua/configs/lspconfig.lua` but
  has no `lsp/lua_ls.lua` file — it relies entirely on NvChad's built-in
  defaults. All other servers must have a corresponding config file.
- **`disabled.lua` is the kill-switch**: to suppress any upstream NvChad plugin,
  add it to `lua/plugins/disabled.lua` with `enabled = false`. Do not delete or
  comment out entries — the list is intentional and documents what was removed.
- **Makefile formatter uses `bake`**, not `make`. This is intentional — do not
  change the formatter for the `make` filetype in `lua/configs/conform.lua`.
