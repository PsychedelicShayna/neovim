return function(rome, capabilities, on_attach)
  local extended_caps = capabilities
  local lspconfig = require("lspconfig")

  -- extended_caps = vim.tbl_deep_extend(
  --   "force",
  --   capabilities,
  --   lspconfig.rome
  -- )


  vim.notify(vim.inspect(lspconfig.rome))

  local config = {
    on_attach    = on_attach,
    capabilities = extended_caps,
  }

  rome.setup(config)
end
