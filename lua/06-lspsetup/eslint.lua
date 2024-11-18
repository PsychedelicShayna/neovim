return function(eslint, capabilities, on_attach)
  local root_pattern = require("lspconfig.util").root_pattern

  return eslint.setup {
    on_attach    = on_attach,
    capabilities = capabilities,
    root_dir     = root_pattern(".git/", "src/", "test/")
  }
end
