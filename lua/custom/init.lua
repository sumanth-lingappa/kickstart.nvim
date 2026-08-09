local M = {}

function M.setup()
  require('custom.open_under_cursor').setup()
  require('custom.terminal').setup()
end

return M
