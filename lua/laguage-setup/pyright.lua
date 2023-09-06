return function(pyright, caps, on_attach)
  pyright.setup {
    on_attach = on_attach,
    capabilities = caps
  }
end
