local diagnostic_signs = {
  { name = 'DiagnosticSignError', text = '' },
  { name = 'DiagnosticSignWarn',  text = '' },
  { name = 'DiagnosticSignHint',  text = '' },
  { name = 'DiagnosticSignInfo',  text = '' },
}

for _, sign in ipairs(diagnostic_signs) do
  vim.fn.sign_define(sign.name, {
    texthl = sign.name,
    text = sign.text,
    numhl = ''
  })
end

vim.diagnostic.config {
  virtual_text = {
    severity = "error"
  },
  signs = { active = diagnostic_signs },
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = {
    focusable = false,
    -- style = 'minimal',
    border = 'single',
    source = 'always',
    header = '',
    prefix = '',
  },
}
