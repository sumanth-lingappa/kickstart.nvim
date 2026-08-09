local M = {}

function M.setup()
  require('custom.options').setup()
  require('custom.ui').setup()
  require('custom.telescope').setup()
  require('custom.plugin_setup').setup()
  require('custom.keymaps').setup()
  require('custom.open_under_cursor').setup()
  require('custom.terminal').setup()
end

return M
