local M = {}

local terminal_bufnr

-- Toggle a persistent terminal in a centered floating window. Hiding it
-- preserves the shell process and scrollback for the next time it is opened.
function M.toggle()
  if terminal_bufnr and vim.api.nvim_buf_is_valid(terminal_bufnr) then
    local terminal_win = vim.fn.bufwinid(terminal_bufnr)
    if terminal_win ~= -1 then
      vim.api.nvim_win_close(terminal_win, false)
      return
    end
  end

  local width = math.floor(vim.o.columns * 0.85)
  local height = math.floor(vim.o.lines * 0.70)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  if not (terminal_bufnr and vim.api.nvim_buf_is_valid(terminal_bufnr)) then
    terminal_bufnr = vim.api.nvim_create_buf(false, false)
  end

  vim.api.nvim_open_win(terminal_bufnr, true, {
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    style = 'minimal',
    border = 'rounded',
  })

  if vim.bo[terminal_bufnr].buftype ~= 'terminal' then
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
