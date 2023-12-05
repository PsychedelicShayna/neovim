local autocmd_id = nil

vim.api.nvim_create_user_command("ToggleAutoDiagLocList", function()
  if type(_G.autocmd_id_toggle_auto_diagnostic_llist) == "number" then
    vim.api.nvim_del_autocmd(_G.autocmd_id_toggle_auto_diagnostic_llist)
    _G.autocmd_id_toggle_auto_diagnostic_llist = nil
    vim.notify("Toggled off.")
  else
    _G.autocmd_id_toggle_auto_diagnostic_llist = vim.api.nvim_create_autocmd({ "BufWrite" }, {
      callback = function()
        vim.diagnostic.setloclist()
      end,
    })

    vim.notify("Toggled on.")
  end
end, {})
