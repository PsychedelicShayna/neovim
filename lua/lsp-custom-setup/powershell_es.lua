return function(powershell_es, caps, on_attach)
  return powershell_es.setup {
    bundle_path  = "~/Documents/PowerShell/EditorServices/",
    shell        = "pwsh.exe",
    on_attach    = on_attach,
    capabilities = caps
  }
end

f
