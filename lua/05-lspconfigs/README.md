# LSP Configs

Language servers that aren't handled through Mason go here. Typically this just means inserting an entry into `lspconfig.configs`, and creating an autocmd to set it up when the appropriate file type is loaded.

Something important to note is the fact that the `custom_on_attach` function is defined in `lsp.lua`, and the extended capabilities are also generated there.

This is why any language servers defined here that want to use the `custom_on_attach` function or the extended capabilities, are able to use the event system to await for this event.

```lua
Events.await_event {
  actor = "lspconfig",
  event = "custom",
  retroactive = true,
  callback = function(data)
    local capabilities = data.capabilities or nil
    local custom_on_attach = data.custom_on_attach or nil
    -- rest of config 
  end
}
```

However I do not want to make the assumption that both the capabilities and the `custom_on_attach` will necessarily be provided. The language server should be able to launch regardless, so the following pattern is encouraged:

```lua
local setup_opts = {}

if capabilities then
  setup_opts.capabilities = capabilities
else
  PrintDbg("No extended capabilities provided for hyuga", LL_WARN)
end

if custom_on_attach then
  setup_opts.on_attach = custom_on_attach
else
  PrintDbg("No custom_on_attach function provided for hyuga", LL_WARN)
end

ls_entry.setup(setup_opts)
```

Add the entries if they're available, but it's not an error if they aren't.
