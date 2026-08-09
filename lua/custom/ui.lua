local M = {}

function M.setup()
  vim.opt.fillchars = {
    vert = '│',
    horiz = '─',
    vertleft = '┤',
    vertright = '├',
    verthoriz = '┼',
    horizup = '┴',
    horizdown = '┬',
  }
  vim.api.nvim_set_hl(0, 'WinSeparator', { fg = '#7aa2f7', bold = true })

  vim.o.laststatus = 3
  _G.kickstart_winbar = function()
    if vim.bo.buftype == 'terminal' then return ' Terminal' end

    local name = vim.api.nvim_buf_get_name(0)
    if name == '' then return ' [No Name]' end

    local home = vim.fn.expand '~'
    name = vim.fn.fnamemodify(name, ':p')
    if vim.startswith(name, home) then name = '~' .. name:sub(#home + 1) end

    local parts = vim.split(name, '/', { plain = true, trimempty = true })
    return ' ' .. table.concat(parts, ' › ')
  end
  vim.o.winbar = '%<%{%v:lua.kickstart_winbar()%}'
  vim.api.nvim_set_hl(0, 'WinBar', { fg = '#c0caf5', bg = '#1f2335', bold = true })
  vim.api.nvim_set_hl(0, 'WinBarNC', { fg = '#565f89', bg = '#1f2335' })

  require('tokyonight').setup {
    styles = { comments = { italic = true } },
  }
  vim.cmd.colorscheme 'tokyonight-night'
end

return M
