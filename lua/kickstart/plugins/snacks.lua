-- 1. Load the plugin using vim.pack.add
vim.pack.add { 'https://github.com/folke/snacks.nvim' }

-- 2. Configure and initialize the plugin (replacing lazy's 'opts')
require("snacks").setup({
  explorer = {
    layout = { preset = 'default' },
  },
  lazygit = {

  },
  gitbrowse = {
    -- open = function(url)
    --   vim.fn.setreg("+", url)
    --   vim.notify("Copied Git URL to clipboard!", vim.log.levels.INFO, {title = "Snacks Gitbrowse"})
    -- end,
  },
  gh = {
    -- your gh configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  },
  picker = {
    sources = {
      gh_issue = {
        -- your gh_issue picker configuration comes here
        -- or leave it empty to use the default settings
      },
      gh_pr = {
        -- your gh_pr picker configuration comes here
        -- or leave it empty to use the default settings
      }
    }
  },
})

-- 3. GitHub
vim.keymap.set("n", "<leader>gi", function() Snacks.picker.gh_issue() end, { desc = "GitHub Issues (open)" })
vim.keymap.set("n", "<leader>gI", function() Snacks.picker.gh_issue({ state = "all" }) end, { desc = "GitHub Issues (all)" })
vim.keymap.set("n", "<leader>gp", function() Snacks.picker.gh_pr() end, { desc = "GitHub Pull Requests (open)" })
vim.keymap.set("n", "<leader>gP", function() Snacks.picker.gh_pr({ state = "all" }) end, { desc = "GitHub Pull Requests (all)" })

-- LazyGit
vim.keymap.set("n", "<leader>lg", function() Snacks.lazygit.open() end, { desc = "LazyGit" })
vim.keymap.set("n", "<leader>gf", function() Snacks.lazygit.log_file() end, { desc = "Lazygit Current File History" })
vim.keymap.set("n", "<leader>gl", function() Snacks.lazygit.log() end, { desc = "LazyGit Repo Log" })

vim.keymap.set('n', '<leader>e', function()
  local explorer = Snacks.picker.get { source = 'explorer' }[1]

  if explorer then
    explorer:close()
  else
    Snacks.explorer {
      layout = { preset = 'default' },
    }
  end
end, { desc = 'Toggle file explorer' })
