return function(lua_ls, caps, on_attach)
  local nodev_ok, neodev = pcall(require, "neodev")

  if neodev_ok then
    vim.notify("Ran neodev setup")
    neodev.setup()
  end

  lua_ls.setup {
    on_attach    = on_attach,
    capabilities = caps,
    settings     = {
      Lua = {
        telemetry = { enable = false, },
        diagnostics = {
          disable = {
            items = {
             "luadoc-miss-module-name"
            }
          }
        }
      },
    }
  }
end
