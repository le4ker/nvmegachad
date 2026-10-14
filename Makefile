.PHONY: install install-macos check-macos check-homebrew check-nodejs
.PHONY: install-homebrew-dependencies install-codex-acp install-terraform
.PHONY: hooks format test help
.NOTPARALLEL: install-macos

install: install-macos

# macOS installation using Homebrew
install-macos: check-macos check-homebrew check-nodejs install-homebrew-dependencies install-codex-acp install-terraform

check-macos:
	@test "$(shell uname -s)" = "Darwin" || { echo "The Makefile installer supports macOS only." >&2; exit 1; }

check-homebrew:
	@command -v brew >/dev/null 2>&1 || { echo "Homebrew not found. Please install Homebrew first: https://brew.sh" >&2; exit 1; }

check-nodejs:
	@command -v node >/dev/null 2>&1 || { echo "Node.js not found. Please install Node.js first: https://nodejs.org/" >&2; exit 1; }
	@command -v npm >/dev/null 2>&1 || { echo "npm not found. Please install npm with Node.js first: https://nodejs.org/" >&2; exit 1; }

install-homebrew-dependencies:
	brew install font-hack-nerd-font
	brew install ripgrep
	brew install tree-sitter-cli
	brew install neovim

install-codex-acp:
	npm install -g @agentclientprotocol/codex-acp

install-terraform:
	brew tap hashicorp/tap
	brew install hashicorp/tap/terraform

# Install git hooks
hooks:
	@echo "Installing git hooks..."
	@cp scripts/commit-msg .git/hooks/commit-msg
	@cp scripts/pre-commit .git/hooks/pre-commit
	@chmod +x .git/hooks/commit-msg .git/hooks/pre-commit
	@echo "Git hooks installed successfully."

# Format Lua files
format:
	stylua .

# Run isolated Lua tests for config helpers
test:
	XDG_STATE_HOME=/tmp/nvmegachad-test-state nvim --headless -u NONE -i NONE -l tests/run.lua

# Help target
help:
	@echo "Available targets:"
	@echo "  install         - Install dependencies for macOS"
	@echo "  hooks           - Install commit-message and test pre-commit hooks"
	@echo "  format          - Format Lua files with StyLua"
	@echo "  test            - Run config helper tests"
	@echo "  help            - Show this help message"
