return function(rust_analyzer, capabilities, on_attach)
  local root_pattern = require("lspconfig.util").root_pattern

  local config = {
    on_attach    = on_attach,
    capabilities = capabilities,
    cmd          = { "rust_analyzer" },
    filetypes    = { "rust" },
    root_dir     = root_pattern("Cargo.toml", "rust-project.json"),
    settings     = {
      ["rust-analyzer"] = {}
    }
  }

  local rust_tools_present, rust_tools = pcall(require, "rust-tools")

  if rust_tools_present then
    rust_tools.setup { server = config }
  else
    rust_analyzer.setup(config)
  end
end
