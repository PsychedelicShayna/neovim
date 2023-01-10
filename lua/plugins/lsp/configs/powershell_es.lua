return function(lspconfig, on_attach, default_capabilities)
  if not lspconfig.powershell_es then
    vim.notify("Cannot setup powershell_es because lspconfig does not define it.")
    return
  end

  return lspconfig.powershell_es.setup {
    bundle_path  = "~/Documents/PowerShell/EditorServices/",
    shell        = "pwsh.exe",
    on_attach    = on_attach,
    capabilities = default_capabilities
  }
end
