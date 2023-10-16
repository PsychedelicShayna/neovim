local events = require('lib.events')

return function(hls, caps, on_attach)
  -- Attempt to use haskell-tools if available.
  local ht_present, ht = pcall(require, "haskell-tools")

  -- If available, haskell-tools will handle the rest
  if ht_present then
    -- Older versions require a call to setup.
    if type(ht) == 'table' and type(ht['setup']) == 'function' then
      ht['setup']()
    end

    return
  end

  -- If haskell-tools isn't available, go through the manual
  -- lspconfig setup.

  local config = {
    on_attach    = on_attach,
    capabilities = caps,
  }

  hls.setup(config)

  return true
end
