return {
  before_init = function(_, config)
    local python = require("utils.python_env").python_path(config.root_dir, true)
    if python then
      config.settings.python.pythonPath = python
    end
  end,
}
