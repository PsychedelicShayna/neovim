Events.await_event {
  actor = "lspconfig",
  event = "configured",
  retroactive = true,
  callback = function()
    Safe.import_then("lspconfig", function(lspconfig)
      lspconfig.dartls.setup {
        cmd = { "dart", "language-server", "--protocol=lsp" }
      }
    end)
  end
}
