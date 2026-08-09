local M = {}

local terminal_bufnr

-- Toggle a persistent terminal in a bottom split. Hiding its window preserves
-- the shell process and scrollback for the next time it is opened.
function M.toggle()
  if terminal_bufnr and vim.api.nvim_buf_is_valid(terminal_bufnr) then
    local terminal_win = vim.fn.bufwinid(terminal_bufnr)
    if terminal_win ~= -1 then
      vim.api.nvim_win_close(terminal_win, false)
      return
    end
  end

  vim.cmd 'botright new'
  vim.cmd('resize ' .. math.floor(vim.o.lines * 0.25))

  if terminal_bufnr and vim.api.nvim_buf_is_valid(terminal_bufnr) then
    vim.api.nvim_win_set_buf(0, terminal_bufnr)
  else
    vim.cmd.terminal()
    terminal_bufnr = vim.api.nvim_get_current_buf()
    vim.bo[terminal_bufnr].bufhidden = 'hide'
    vim.bo[terminal_bufnr].buflisted = false
  end

  vim.cmd.startinsert()
end

function M.setup()
  -- Exit terminal mode with a discoverable shortcut. The native alternative is
  -- <C-\\><C-n>, which is less memorable.
  vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
  vim.keymap.set({ 'n', 't' }, '<C-j>', M.toggle, { desc = 'Toggle terminal' })
end

return M
