return function(lua_ls, capabilities, on_attach)
  lua_ls.setup {
    on_attach    = on_attach,
    capabilities = capabilities,
    settings     = {
      Lua = {
        telemetry = { enable = false, },
      },
    }
  }
end
