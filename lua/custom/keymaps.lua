local M = {}

function M.setup()
  require('which-key').add {
    { '<leader>g', group = '[G]it & GitHub' },
    { '<leader>l', group = '[L]azyGit' },
  }

  vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
  vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
  vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
  vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')
  vim.keymap.set('n', '<C-S-h>', '<C-w>H', { desc = 'Move window to the left' })
  vim.keymap.set('n', '<C-S-l>', '<C-w>L', { desc = 'Move window to the right' })
  vim.keymap.set('n', '<C-S-j>', '<C-w>J', { desc = 'Move window to the lower' })
  vim.keymap.set('n', '<C-S-k>', '<C-w>K', { desc = 'Move window to the upper' })
  vim.keymap.set('n', '<leader>?', function() require('telescope.builtin').keymaps() end, { desc = 'Search [K]eymaps' })
  vim.keymap.set('n', '<leader>so', function()
    vim.cmd('source ' .. vim.fn.fnameescape(vim.env.MYVIMRC))
    vim.notify('🚀 Reloaded ' .. vim.env.MYVIMRC)
  end, { desc = '[S]ource Neovim [O]ptions' })
end

return M
