local M = {}

function M.setup()
  vim.g.have_nerd_font = true
  vim.o.relativenumber = true
  vim.o.undofile = false
end

return M
