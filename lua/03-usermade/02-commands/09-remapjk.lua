local M = {}

function M.gmovement()
  vim.keymap.set('n', 'k', 'gk')
  vim.keymap.set('n', 'j', 'gj')
end

function M.nogmovement()
  vim.keymap.set('n', 'k', 'k')
  vim.keymap.set('n', 'j', 'j')
end

vim.api.nvim_create_user_command("ModeGMovement", function(opts)
  M.gmovement()
end, {})

vim.api.nvim_create_user_command("NoModeGMovement", function(opts)
  M.nogmovement()
end, {})

vim.api.nvim_create_user_command("ModeText", function(opts)
  M.gmovement()
  vim.cmd("set wrap")
  vim.cmd("set colorcolumn=")
  vim.cmd("set ve=all")
  vim.cmd("set ve=all")
  vim.cmd("set cursorcolumn")
  vim.cmd("set cursorline")
end, {})

vim.api.nvim_create_user_command("NoModeText", function(opts)
  M.nogmovement()
  vim.cmd("set nowrap")
  vim.cmd("set colorcolumn=80,120")
  vim.cmd("set ve=none")
  vim.cmd("set nocursorcolumn")
  vim.cmd("set nocursorline")
end, {})
