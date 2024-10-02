local enabled = false
local autocmd_id = nil

vim.api.nvim_create_user_command("EnableCursorHoldHighlight", function()
  if enabled then return end

  autocmd_id = vim.api.nvim_create_autocmd("CursorHold", {
    callback = function()
      Safe.try(function()
        vim.lsp.buf.document_highlight()

        vim.api.nvim_create_autocmd("CursorMoved", {
          callback = function()
            Safe.try(function() vim.lsp.buf.clear_references() end)
          end,

          once = true
        })
      end)
    end
  })

  enabled = true
end, {})

vim.api.nvim_create_user_command("DisableCursorHoldHighlight", function()
  if not enabled then return end

  if autocmd_id then
    Safe.try(function()
      vim.api.nvim_del_autocmd(autocmd_id)
      vim.lsp.buf.clear_references()
    end)
  end

  enabled = false
end, {})
