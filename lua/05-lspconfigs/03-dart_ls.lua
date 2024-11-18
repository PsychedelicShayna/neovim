local ok, lspconfig = pcall(require, "lspconfig")

if not ok then
  PrintDbg(
    string.format("Import failure, lspconfig: %s", ok and "ok" or "failed"), LL_ERROR)
  return false
end

-- lspconfig actually includes dartls, but we need to set it up manually,
-- because Mason doesn't include / cannot manage it, so it will never be
-- listed in the installed servers list. Likely because it's a part of Dart
-- itself, which is part of the SDK and.. I don't think I need to elaborate.

vim.api.nvim_create_autocmd("FileType", {
  once = true,
  pattern = 'dart',
  callback = function(_)
    Events.await_event {
      actor = "lspconfig",
      event = "custom",
      retroactive = true,
      callback = function(data)
        local setup_opts = {
          cmd = { "dart", "language-server", "--protocol=lsp" }
        }

        local capabilities = data.capabilities or nil
        local custom_on_attach = data.custom_on_attach or nil

        if capabilities then
          setup_opts.capabilities = capabilities
        else
          PrintDbg("No extended capabilities provided for dartls", LL_WARN)
        end

        if custom_on_attach then
          setup_opts.on_attach = custom_on_attach
        else
          PrintDbg("No custom_on_attach function provided for dartls", LL_WARN)
        end

        lspconfig.dartls.setup(setup_opts)
      end
    }
  end
})
