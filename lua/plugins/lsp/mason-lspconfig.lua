return function(mason_lspconfig, lsp_server_list)
  mason_lspconfig.setup {
    ensure_installed       = lsp_server_list,
    automatic_installation = true
  }
end
