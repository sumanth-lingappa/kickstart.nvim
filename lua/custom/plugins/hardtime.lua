vim.pack.add {
  'https://github.com/m4xshen/hardtime.nvim',
  'https://github.com/MunifTanjim/nui.nvim',
}

require('hardtime').setup {
  restriction_mode = 'block',
  max_count = 3,
  max_time = 1000,
}
