return function(lspconfig, on_attach, default_capabilities)
  if not lspconfig.rust_analyzer then
    vim.notify("Cannot setup rust_analyzer because lspconfig does not define it.")
    return
  end

  local default_config = {
    on_attach    = on_attach,
    capabilities = default_capabilities,
    cmd          = { "rust_analyzer" },
    filetypes    = { "rust" },
    root_dir     = lspconfig.util.root_pattern("Cargo.toml", "rust-project.json"),
    settings     = {
      ["rust-analyzer"] = {}
    }
  }

  local rt_ok, rt = pcall(require, "rust-tools")

  if rt_ok then
    rt.setup { server = default_config }
  else
    return lspconfig.rust_analyzer.setup(default_config)
  end
end
