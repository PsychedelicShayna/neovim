return function(lua_ls, capabilities, on_attach)
  lua_ls.setup {
    on_attach    = on_attach,
    capabilities = capabilities,
    settings     = {
      Lua = {
        runtime = {
          version = 'LuaJIT', -- LuaJIT is the Neovim Lua runtime.
        },
        diagnostics = {
          globals = { 'vim' },
        },

        workspace = {
          library = vim.api.nvim_get_runtime_file("", true),
        },

        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = { enable = false, },
      },
    }
  }
end
