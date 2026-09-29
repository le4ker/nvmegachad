.PHONY: install
install:
	@if [ "$(shell uname -s)" != "Darwin" ]; then echo "The Makefile installer supports macOS only."; exit 1; fi
	@$(MAKE) install-macos

# macOS installation using Homebrew
.PHONY: install-macos
install-macos:
	@echo "Installing dependencies for macOS..."
	@command -v brew >/dev/null 2>&1 || { echo "Homebrew not found. Please install Homebrew first: https://brew.sh"; exit 1; }
	# fonts
	brew install font-hack-nerd-font
	# ripgrep
	brew install ripgrep
	# claude code + acp bridge
	@command -v claude >/dev/null 2>&1 || { echo "Claude Code not found. Please install it first: https://docs.anthropic.com/en/docs/claude-code/quickstart"; }
	npm install -g @agentclientprotocol/claude-agent-acp
	# terraform
	brew tap hashicorp/tap
	brew install hashicorp/tap/terraform
	# neovim
	brew install neovim

# Install git hooks
.PHONY: hooks
hooks:
	@echo "Installing git hooks..."
	@cp scripts/commit-msg .git/hooks/commit-msg
	@chmod +x .git/hooks/commit-msg
	@echo "Git hooks installed successfully."

# Help target
.PHONY: help
help:
	@echo "Available targets:"
	@echo "  install         - Install dependencies for macOS"
	@echo "  install-macos   - Install dependencies for macOS (requires Homebrew)"
	@echo "  hooks           - Install git hooks for conventional commits"
	@echo "  help            - Show this help message"
