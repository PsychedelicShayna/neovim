return function(lspconfig, on_attach, default_capabilities)
  if not lspconfig.elixirls then
    vim.notify("Cannot setup elixirls because lspconfig does not define it.")
    return
  end

  return lspconfig.elixirls.setup {
    on_attach    = on_attach,
    capabilities = default_capabilities,
    cmd          = { "C:/Langs/Elixir/elixir-ls/language_server.bat" }
  }
end

