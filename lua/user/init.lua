local M = {}

local keybindings_ok, keybindings = pcall(require, 'user.keybindings')
M.keybindings = keybindings

if not keybindings_ok then
  vim.notify('Failed to import userland keybindings!')
  PrintDbg(keybindings, 'keybindings')
end

local preferences_ok, preferences = pcall(require, 'user.preferences')
M.preferences = preferences

if not preferences_ok then
  vim.notify('Failed to import userland preferences!')
  PrintDbg(preferences, 'preferences')
end

local autocommands_ok, autocommands = pcall(require, 'user.autocommands')
M.autocommands = autocommands

if not autocommands_ok then
  vim.notify('Failed to import userland autocommands!')
  PrintDbg(autocommands, 'autocommands')
end

local usercommands_ok, usercommands = pcall(require, 'user.usercommands')
M.usercommands = usercommands

if not usercommands_ok then
  vim.notify('Failed to import userland usercommands!')
  PrintDbg(usercommands, 'usercommands')
end

local userscripts_ok, userscripts = pcall(require, 'user.userscripts')
M.userscripts = userscripts

if not userscripts_ok then
  vim.notify('Failed to import userland userscripts!')
  PrintDbg(userscripts, 'userscripts')
end


return M
