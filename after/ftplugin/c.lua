vim.cmd([[ match Todo /\(TODO\|NOTE\)/ ]])
vim.lsp.config.clangd.cmd = { "clangd", "-j", "8", "--background-index" }
