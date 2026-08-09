local M = {}

-- Open the file under the cursor, or offer to create a missing file and its
-- parent directories. Set prefer_existing_buffer to false to open it in a new
-- split even if the file is already visible elsewhere.
function M.open(prefer_existing_buffer)
  local target = vim.fn.expand '<cfile>'
  if target == '' then return end

  if target:match '^https?://' then
    local _, err = vim.ui.open(target)
    if err then vim.notify('Could not open URL: ' .. err, vim.log.levels.ERROR) end
    return
  end

  -- Expand environment variables. For shell scripts, also use simple variable
  -- assignments declared above the cursor (for example, DOTFILES_PATH="$HOME/dotfiles").
  local shell_variables = {}
  for _, line in ipairs(vim.api.nvim_buf_get_lines(0, 0, vim.fn.line '.', false)) do
    line = line:gsub('^%s*export%s+', '')
    local name, value = line:match '^%s*([%a_][%w_]*)%s*=%s*"(.-)"%s*$'
    if not name then name, value = line:match "^%s*([%a_][%w_]*)%s*=%s*'(.-)'%s*$" end
    if not name then name, value = line:match '^%s*([%a_][%w_]*)%s*=%s*([^%s#]+)' end
    if name then shell_variables[name] = value end
  end

  -- Expand nested variables too: DOTFILES_PATH="$HOME/code/dotfiles" needs
  -- one pass for $DOTFILES_PATH and a second pass for $HOME. Ten passes cap
  -- circular definitions such as A="$B" and B="$A".
  for _ = 1, 10 do
    local replaced = false
    -- Support the braced shell form: ${DOTFILES_PATH}.
    target = target:gsub('%${([%a_][%w_]*)}', function(name)
      local value = vim.env[name] or shell_variables[name]
      if value then replaced = true return value end
      return '${' .. name .. '}'
    end)
    -- Support the usual shell form: $DOTFILES_PATH.
    target = target:gsub('%$([%a_][%w_]*)', function(name)
      local value = vim.env[name] or shell_variables[name]
      if value then replaced = true return value end
      return '$' .. name
    end)
    -- No replacement means every variable was fully expanded (or unknown).
    if not replaced then break end
  end
  if target:match '%$[%a_]' or target:match '%${[%a_]' then
    vim.notify('Cannot resolve variable in path: ' .. target, vim.log.levels.WARN)
    return
  end

  local function open_file(path)
    path = vim.fs.normalize(vim.fn.fnamemodify(path, ':p'))
    local bufnr
    for _, candidate in ipairs(vim.api.nvim_list_bufs()) do
      local name = vim.api.nvim_buf_get_name(candidate)
      if name ~= '' and vim.fs.normalize(name) == path then
        bufnr = candidate
        break
      end
    end

    if bufnr and prefer_existing_buffer ~= false then
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_buf(win) == bufnr then
          vim.api.nvim_set_current_win(win)
          return
        end
      end
      vim.api.nvim_set_current_buf(bufnr)
      return
    end

    vim.cmd.edit(vim.fn.fnameescape(path))
  end

  if vim.fn.filereadable(target) == 1 or vim.fn.isdirectory(target) == 1 then
    open_file(target)
    return
  end

  local found = vim.fn.findfile(target, vim.o.path)
  if found ~= '' then
    open_file(found)
    return
  end

  if not vim.startswith(target, '/') then
    local buffer_dir = vim.fn.expand '%:p:h'
    if buffer_dir ~= '' then target = buffer_dir .. '/' .. target end
  end
  target = vim.fs.normalize(target)

  local choice = vim.fn.confirm(
    ('File does not exist:\n%s\n\nCreate it and its parent directories?'):format(target),
    '&Yes\n&No',
    2
  )
  if choice ~= 1 then return end

  vim.fn.mkdir(vim.fn.fnamemodify(target, ':h'), 'p')
  vim.fn.writefile({}, target)
  open_file(target)
end

function M.setup()
  vim.keymap.set('n', 'gf', M.open, { desc = 'Open or create file under cursor' })
  vim.keymap.set('n', '<leader>gv', function()
    vim.cmd.vsplit()
    M.open(false)
  end, { desc = 'Open path in [V]ertical split' })
  vim.keymap.set('n', '<leader>gh', function()
    vim.cmd.split()
    M.open(false)
  end, { desc = 'Open path in [H]orizontal split' })
end

return M
