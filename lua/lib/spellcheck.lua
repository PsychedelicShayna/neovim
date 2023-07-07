-- Enable spell checking automatically for certain filetypes.
vim.api.nvim_create_autocmd({ 'FileType' }, {
  pattern = { 'markdown', 'text' },
  command = 'setlocal spell'
})
