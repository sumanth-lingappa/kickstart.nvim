local M = {}

function M.setup()
  vim.pack.add { { src = 'https://github.com/nvim-telescope/telescope-live-grep-args.nvim', version = vim.version.range '1.*' } }

  local actions = require 'telescope-live-grep-args.actions'
  local action_state = require 'telescope.actions.state'
  require('telescope').setup {
    defaults = {
      path_display = { 'filename_first' },
      dynamic_preview_title = true,
    },
    pickers = {
      find_files = { cwd = require('telescope.utils').buffer_dir() },
      live_grep = { cwd = require('telescope.utils').buffer_dir() },
      grep_string = { cwd = require('telescope.utils').buffer_dir() },
    },
    extensions = {
      live_grep_args = {
        auto_quoting = true,
        prompt_title = 'Grep: <C-g> glob; !glob excludes',
        mappings = {
          i = {
            ['<C-g>'] = function(prompt_bufnr)
              local picker = action_state.get_current_picker(prompt_bufnr)
              local prompt = picker:_get_prompt()
              if prompt:find('--iglob', 1, true) or prompt:find('--glob', 1, true) then
                picker:set_prompt(prompt .. ' --iglob ')
              else
                actions.quote_prompt { postfix = ' --iglob ' }(prompt_bufnr)
              end
            end,
          },
        },
      },
    },
  }
  pcall(require('telescope').load_extension, 'live_grep_args')
  vim.keymap.set('n', '<leader>sg', require('telescope').extensions.live_grep_args.live_grep_args, { desc = '[S]earch by [G]rep' })
end

return M
