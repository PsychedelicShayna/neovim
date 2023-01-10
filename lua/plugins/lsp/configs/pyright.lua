return function(lspconfig, on_attach, default_capabilities)
  if not lspconfig.pyright then
    vim.notify("Cannot setup pyright because lspconfig does not define it.")
    return
  end

  return lspconfig.pyright.setup {
    on_attach    = on_attach,
    capabilities = default_capabilities
  }
end
