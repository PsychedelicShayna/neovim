local lsp_enable_autoformat = true

vim.api.nvim_create_user_command(
  "ToggleAutoFormat",
  function(msg)
    lsp_enable_autoformat = not lsp_enable_autoformat

    if msg then
      vim.notify("Toggled autoformat " ..
        ({ [true] = "on", [false] = "off" })[lsp_enable_autoformat])
    end
  end,
  {}
)

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  callback = function()
    if lsp_enable_autoformat then
      vim.lsp.buf.format { async = true }
    end
  end
})
