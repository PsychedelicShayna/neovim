vim.api.nvim_create_user_command("ToggleDiagnostics", function()
  if vim.diagnostic.is_enabled() then
    vim.diagnostic.enable()
  else
    vim.diagnostic.enable(false)
  end

  vim.notify("Diagnostics turned " .. ((vim.diagnostic.is_enabled() and "on") or "off"))
end, {})
