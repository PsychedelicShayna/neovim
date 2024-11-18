return function(yamlls, caps, on_attach)
  yamlls.setup {
    on_attach = on_attach,
    capabilities = caps,
    settings = {
      yaml = {
        completion = true,
        editor = {
          tabSize = 2
        },
        format = {
          enable = true,
          singleQuote = false
        },
        hover = true,
        keyOrdering = false,
        schemaStore = {
          enable = true,
        },
        validate = true,
      }
    }
  }

  return true
end
