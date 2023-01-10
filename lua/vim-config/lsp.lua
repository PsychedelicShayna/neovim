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

local diagnostic_signs = {
  { name = "DiagnosticSignError", text = "" },
  { name = "DiagnosticSignWarn", text = "" },
  { name = "DiagnosticSignHint", text = "" },
  { name = "DiagnosticSignInfo", text = "" },
}

for _, sign in ipairs(diagnostic_signs) do
  vim.fn.sign_define(sign.name, {
    texthl = sign.name,
    text = sign.text,
    numhl = ""
  })
end

vim.diagnostic.config {
  virtual_text = true,
  signs = { active = diagnostic_signs },
  update_in_insert = true,
  underline = true,
  severity_sort = true,
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
}

-- Give rounded borders to the "hover" window.
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover, { border = "rounded", }
)

-- Give rounded borders to the function signature help window.
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
  vim.lsp.handlers.signature_help, { border = "rounded", }
)
