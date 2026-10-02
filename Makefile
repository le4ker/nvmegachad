.PHONY: install install-macos check-macos check-homebrew
.PHONY: install-homebrew-dependencies install-claude-acp install-terraform
.PHONY: hooks help
.NOTPARALLEL: install-macos

install: install-macos

# macOS installation using Homebrew
install-macos: check-macos check-homebrew install-homebrew-dependencies install-claude-acp install-terraform

check-macos:
	@test "$(shell uname -s)" = "Darwin" || { echo "The Makefile installer supports macOS only."; exit 1; }

check-homebrew:
	@command -v brew >/dev/null 2>&1 || { echo "Homebrew not found. Please install Homebrew first: https://brew.sh"; exit 1; }

install-homebrew-dependencies:
	@echo "Installing dependencies for macOS..."
	brew install font-hack-nerd-font
	brew install ripgrep
	brew install tree-sitter-cli
	brew install neovim

install-claude-acp:
	@command -v claude >/dev/null 2>&1 || echo "Claude Code not found. Please install it first: https://docs.anthropic.com/en/docs/claude-code/quickstart"
	npm install -g @agentclientprotocol/claude-agent-acp

install-terraform:
	brew tap hashicorp/tap
	brew install hashicorp/tap/terraform

# Install git hooks
hooks:
	@echo "Installing git hooks..."
	@cp scripts/commit-msg .git/hooks/commit-msg
	@chmod +x .git/hooks/commit-msg
	@echo "Git hooks installed successfully."

# Help target
help:
	@echo "Available targets:"
	@echo "  install         - Install dependencies for macOS"
	@echo "  hooks           - Install git hooks for conventional commits"
	@echo "  help            - Show this help message"
