return function(yamlls, caps, on_attach)
  local config = {
    on_attach = on_attach,
    capabilities = caps,
    settings = {
      yaml = {
        completion = true,
        editor.tabSize = 2,
        format.enable = true,
        format.singleQuote =false,
        hover = true,
        keyOrdering = false,
        schemaStore.enable = true,
        validate = true,
      }
    }
  }

  vim.notify("Setup yamlls")
  print("Setup yamlls")

  return yamlls.setup(config)
end
