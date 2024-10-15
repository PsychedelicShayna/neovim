-------------------------------------------------------------------------------
-- Floating Window Style
-------------------------------------------------------------------------------
local float_border = "single"
local float_style  = "minimal"

vim.api.nvim_create_autocmd({ "ColorScheme" }, {
  callback = function()
    vim.defer_fn(function()
      vim.cmd("highlight NormalFloat ctermbg=None guibg=None cterm=None")
      vim.cmd("highlight FloatBorder ctermbg=None guibg=None cterm=None")
    end, 150)
  end
})



-------------------------------------------------------------------------------
-- Sign Definitions
-------------------------------------------------------------------------------
local diagnostic_signs = {
  { name = 'DiagnosticSignError', text = ' X' }, -- ''
  { name = 'DiagnosticSignWarn',  text = ' !' }, -- ''
  { name = 'DiagnosticSignHint',  text = ' I' }, -- ''
  { name = 'DiagnosticSignInfo',  text = ' ?' }, -- ''
}
for _, sign in ipairs(diagnostic_signs) do
  vim.fn.sign_define(sign.name, {
    texthl = sign.name,
    text = sign.text,
    numhl = ''
  })
end

-------------------------------------------------------------------------------
-- LSP Floating Window Settings
-------------------------------------------------------------------------------

vim.lsp.handlers["textDocument/hover"] =
    vim.lsp.with(vim.lsp.handlers.hover, { border = float_border })


vim.lsp.handlers["textDocument/signatureHelp"] =
    vim.lsp.with(vim.lsp.handlers.signature_help, { border = float_border })


-------------------------------------------------------------------------------
-- Diagnostics Config
-------------------------------------------------------------------------------
vim.diagnostic.config {
  virtual_text = false,
  signs = { active = diagnostic_signs },
  update_in_insert = false,
  underline = false,
  severity_sort = false, -- default: false
  float = {
  virtual_text  = false,
    focusable = true,
    focus = true,
    style = float_style,
    border = float_border,
    source = 'always',
    header = '',
    prefix = '',
  },
}
