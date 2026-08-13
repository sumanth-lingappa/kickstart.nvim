vim.pack.add { 'https://github.com/folke/snacks.nvim' }

require('snacks').setup {
  explorer = { layout = { preset = 'default' } },
  lazygit = {},
  gitbrowse = {},
  gh = {},
  picker = {
    sources = {
      explorer = {
        jump = { close = true },
        actions = {
          diff_selected = function(picker)
            local items = picker:selected()
            if #items ~= 2 then
              vim.notify('Select exactly two files with <Tab> before diffing', vim.log.levels.WARN)
              return
            end

            local paths = vim.tbl_map(function(item)
              return require('snacks.picker.util').path(item)
            end, items)
            if not paths[1] or not paths[2] or vim.fn.filereadable(paths[1]) ~= 1 or vim.fn.filereadable(paths[2]) ~= 1 then
              vim.notify('Only files can be diffed', vim.log.levels.WARN)
              return
            end

            picker:close()
            vim.cmd.tabnew()
            vim.cmd.edit(vim.fn.fnameescape(paths[1]))
            vim.cmd('vert diffsplit ' .. vim.fn.fnameescape(paths[2]))
          end,
        },
        win = {
          list = {
            keys = {
              ['D'] = 'diff_selected',
            },
          },
        },
      },
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
