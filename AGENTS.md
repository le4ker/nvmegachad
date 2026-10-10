# NvMegaChad — Codex Instructions

## Project Overview

NvMegaChad is a Neovim configuration built on **NvChad v2.5**, requiring
**Neovim 0.12+**. All configuration is written in Lua and managed via
**Lazy.nvim**.

## Repository Structure

```text
lua/
  chadrc.lua        # NvChad theme/UI overrides (theme, statusline, tabufline)
  options.lua       # vim.opt settings and vim.g feature toggles
  mappings.lua      # All keybindings — single source of truth
  unmappings.lua    # Removes conflicting NvChad defaults via safe_unmap()
  plugins/          # Lazy.nvim plugin specs — one file per plugin
  configs/plugins/  # Plugin setup modules for Lazy.nvim specs
lsp/                # Per-server LSP configs loaded by Neovim (runtimepath)
```

## Code Conventions

### Lua Style

- Formatter: **stylua** — always run before committing
- Local alias for keymaps: `local map = vim.keymap.set`
- All `map()` calls must include a `desc` field following the pattern
  `"Category Action Title"` (e.g. `"LSP Go To Definition"`,
  `"DAP Add Breakpoint At Line"`)

### Plugin Architecture

Plugin specifications live in `lua/plugins/<name>.lua`. Keep declarative
metadata and simple `opts` in the specification. When setup logic is kept in a
separate module, use this pattern:

1. `lua/plugins/<name>.lua` — Lazy.nvim spec and plugin load conditions
2. `lua/configs/plugins/<name>.lua` — plugin setup, required by the spec

Do not split simple declarative options into a separate config module without a
reason.

### LSP Servers

- Server list lives in `lua/configs/plugins/lspconfig.lua` — add new servers to
  the `servers` table and call `vim.lsp.enable(servers)`
- Custom server config goes in `lsp/<server_name>.lua` — return a table merged
  with defaults by Neovim's native LSP loader
- Create an `lsp/<server_name>.lua` file only when a server needs custom
  configuration; servers without custom settings use Neovim's defaults

### Adding a New Language

When adding support for a new language, update all of the following:

1. `lua/configs/plugins/lspconfig.lua` — add the LSP server name to `servers`
2. `lsp/<server>.lua` — create a server config file only if it needs custom
   configuration
3. `lua/configs/plugins/conform.lua` — add `filetype = { "formatter" }` entry
4. `lua/configs/plugins/lint.lua` — add `filetype = { "linter" }` entry if
   applicable
5. `lua/plugins/mason.lua` — add all tools to `ensure_installed`
6. `lua/configs/plugins/treesitter.lua` — add the parser name to the install
   list (parsers are auto-installed at runtime, but explicit listing is
   preferred)
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

- **Blink completion**: `blink.cmp` provides completion UI and keymaps. Keep
  nvim-cmp and its completion sources disabled in `lua/plugins/disabled.lua`.
  LSP capabilities are extended in `lua/configs/plugins/lspconfig.lua`.
- **No null-ls**: formatting is handled by conform.nvim, linting by nvim-lint.
- **Tab/`<S-Tab>` are overloaded**: they navigate buffers in normal mode and
  cycle completions / jump snippets in insert/select mode. Do not remap these
  without accounting for both behaviours.
- **Python environment detection**: pyright and pylint share
  `lua/utils/python_env.lua`, preferring Poetry environments, then project-local
  `.venv` environments. Preserve this logic when modifying Python tooling.
- **LSP defaults**: Servers without custom settings rely on Neovim's built-in
  defaults and do not need an `lsp/<server>.lua` file. `lua_ls` is one such
  server.
- **`disabled.lua` is the kill-switch**: to suppress any upstream NvChad plugin,
  add it to `lua/plugins/disabled.lua` with `enabled = false`. Do not delete or
  comment out entries — the list is intentional and documents what was removed.
- **Makefile formatter uses `bake`**, not `make`. This is intentional — do not
  change the formatter for the `make` filetype in
  `lua/configs/plugins/conform.lua`.
