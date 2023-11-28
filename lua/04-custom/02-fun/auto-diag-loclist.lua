local autocmd_id = nil

vim.api.nvim_create_user_command("ToggleAutoDiagLocList", function()
  if type(autocmd_id) == 'number' then
    vim.api_nvim_del_autocmd(autocmd_id)
    autocmd_id = nil
    vim.notify("Disabled automatic diagnostics location list.")
  else
    autocmd_id = vim.api.nvim_create_autocmd({ "BufWrite" }, {
      callback = function()
        vim.diagnostic.setloclist()
      end
    })

    vim.notify("Enabled automatic diagnostics location list.")
  end
end, {})
