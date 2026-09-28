-- Prefer a plain ANTHROPIC_API_KEY when present; otherwise fall back to the
-- Claude Code Pro OAuth token stored in the macOS Keychain.
local has_api_key = vim.env.ANTHROPIC_API_KEY ~= nil and vim.env.ANTHROPIC_API_KEY ~= ""
local chat_adapter = has_api_key and "anthropic" or "claude_code"

require("codecompanion").setup {
  adapters = {
    acp = {
      claude_code = function()
        return require("codecompanion.adapters").extend("claude_code", {
          env = {
            -- Read fresh from Keychain each call; Claude Code rotates the access token silently, so a static env var would go stale mid-session
            CLAUDE_CODE_OAUTH_TOKEN = [[cmd:security find-generic-password -s 'Claude Code-credentials' -a panos -w 2>/dev/null | python3 -c "import sys,json; print(json.loads(sys.stdin.read())['claudeAiOauth']['accessToken'])"]],
          },
        })
      end,
    },
  },
  interactions = {
    chat = {
      adapter = chat_adapter,
      roles = {
        user = "Claude Code",
      },
    },
  },
}
