local events = require('lib.events')

return function(hls, caps, on_attach)
  -- Attempt to use haskell-tools if available.
  local ht_present, ht = pcall(require, "haskell-tools")

  if not ht_present then
    local config = {
      on_attach    = on_attach,
      capabilities = caps,
    }

    return hls.setup(config)
  end

  return ht
end
