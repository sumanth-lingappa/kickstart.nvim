vim.pack.add { 'https://github.com/folke/snacks.nvim' }

require('snacks').setup {
  explorer = { layout = { preset = 'default' } },
  lazygit = {},
  gitbrowse = {},
  gh = {},
  picker = {
    sources = {
      explorer = { jump = { close = true } },
      gh_issue = {},
      gh_pr = {},
    },
  },
}

vim.keymap.set('n', '<leader>gi', function() Snacks.picker.gh_issue() end, { desc = 'GitHub Issues (open)' })
vim.keymap.set('n', '<leader>gI', function() Snacks.picker.gh_issue({ state = 'all' }) end, { desc = 'GitHub Issues (all)' })
vim.keymap.set('n', '<leader>gp', function() Snacks.picker.gh_pr() end, { desc = 'GitHub Pull Requests (open)' })
vim.keymap.set('n', '<leader>gP', function() Snacks.picker.gh_pr({ state = 'all' }) end, { desc = 'GitHub Pull Requests (all)' })
vim.keymap.set('n', '<leader>lg', function() Snacks.lazygit.open() end, { desc = 'LazyGit' })
vim.keymap.set('n', '<leader>gf', function() Snacks.lazygit.log_file() end, { desc = 'Lazygit Current File History' })
vim.keymap.set('n', '<leader>gl', function() Snacks.lazygit.log() end, { desc = 'LazyGit Repo Log' })
vim.keymap.set('n', '<leader>e', function()
  local explorer = Snacks.picker.get { source = 'explorer' }[1]
  if explorer then
    explorer:close()
  else
    Snacks.explorer { layout = { preset = 'default' } }
  end
end, { desc = 'Toggle file explorer' })
