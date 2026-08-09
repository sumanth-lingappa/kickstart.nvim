local M = {}

function M.setup()
  require 'kickstart.plugins.autopairs'
  require 'kickstart.plugins.gitsigns'
  require 'custom.plugins'
end

return M
