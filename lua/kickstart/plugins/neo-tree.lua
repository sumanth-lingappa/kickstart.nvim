-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

vim.pack.add {
  { src = 'https://github.com/nvim-neo-tree/neo-tree.nvim', version = vim.version.range '*' },
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/MunifTanjim/nui.nvim',
}

vim.keymap.set('n', '\\', '<Cmd>Neotree toggle<CR>', { desc = 'NeoTree reveal', silent = true })
vim.keymap.set('n', '<leader>e', '<Cmd>Neotree float<CR>', { desc = 'NeoTree toggle', silent = true })

require('neo-tree').setup {
  source_selector = {
    -- statusline = true,
    winbar = true,
    truncation_character = "…",
  },
  filesystem = {
    window = {
      position = "right",
      mappings = {
        ["<F5>"] = "refresh",
        ["o"] = "open",
        ['\\'] = 'close_window',
        ['h'] = 'close_node',
        ['l'] = 'open',
        ['/'] = "fuzzy_sorter",
        -- ['<Tab>'] = "next_source",
        -- ['<S-Tab>'] = "prev_source",
      },
    },
  },
}
