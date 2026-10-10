local codecompanion = require("codecompanion")
local adapters = require("codecompanion.adapters")

codecompanion.setup({
  adapters = {
    acp = {
      codex = function()
        return adapters.extend("codex", {
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
})
