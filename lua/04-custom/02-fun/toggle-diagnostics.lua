function _G.toggle_diagnostics()
  if vim.diagnostic.is_disabled() then
    vim.diagnostic.enable()
  else
    vim.diagnostic.disable()
  end
end

vim.api.nvim_create_user_command("ToggleDiagnostics", ":lua _G.toggle_diagnostics()", {})
