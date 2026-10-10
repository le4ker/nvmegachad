return {
  "olimorris/codecompanion.nvim",
  cmd = {
    "CodeCompanion",
    "CodeCompanionChat",
    "CodeCompanionActions",
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    adapters = {
      acp = {
        codex = function()
          return require("codecompanion.adapters").extend("codex", {
            defaults = {
              auth_method = "chat-gpt",
            },
          })
        end,
      },
    },
    interactions = {
      chat = {
        adapter = "codex",
        roles = {
          user = "AI Agent - Codex",
        },
      },
    },
  },
}
