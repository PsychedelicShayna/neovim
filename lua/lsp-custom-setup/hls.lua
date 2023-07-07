local events = require('lib.events')

return function(hls, caps, on_attach)
  local root_pattern = require("lspconfig.util").root_pattern

  local config = {
    on_attach    = on_attach,
    capabilities = caps,
  }

  local haskell_tools_present, haskell_tools = pcall(require, "haskell-tools")

  if haskell_tools_present then
    haskell_tools.setup {}
  else
    hls.setup(config)
  end

  return true
end
