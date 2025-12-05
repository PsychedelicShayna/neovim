vim.g.keylogger_on = false
vim.g.normal_keys = {}

-- Function to log keys
local function log_key(key)
  table.insert(vim.g.normal_keys, key)
end

-- Attach the logger
vim.on_key(function(key)
  if vim.g.keylogger_on then
    -- Only log in normal mode
    if vim.fn.mode() == "n" then
      log_key(key)
    end
  end
end, vim.api.nvim_create_namespace("KeyLogger"))

vim.api.nvim_create_user_command("KeyloggerOn", function(args)
  vim.g.normal_keys = {}
  vim.g.keylogger_on = not vim.g.keylogger_on
end, {})

vim.api.nvim_create_user_command("KeyloggerOff", function(args)
  vim.g.keylogger_on = not vim.g.keylogger_on
  vim.notify(vim.inspect(vim.g.normal_keys))
end, {})


