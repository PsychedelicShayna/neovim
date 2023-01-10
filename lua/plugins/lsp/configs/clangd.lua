return function(lspconfig, on_attach, default_capabilities)
  if not lspconfig.clangd then
    vim.notify("Cannot setup clangd because lspconfig does not define it.")
    return
  end

  local default_config = {
    on_attach           = on_attach,
    capabilities        = default_capabilities,
    cmd                 = {
      "clangd",
      "--offset-encoding=utf-16",
      "--background-index",
      "--pch-storage=memory",
      "--clang-tidy",
      "--suggest-missing-includes",
      "--cross-file-rename",
      "--completion-style=detailed",
    },
    root_dir            = lspconfig.util.root_pattern(
      ".clangd",
      ".clang-tidy",
      ".clang-format",
      "compile_commands.json",
      "compile_flags.txt",
      "configure.ac",
      ".git"
    ),
    init_options        = {
      clangdFileStatus = true,
      usePlaceholders = true,
      completeUnimported = true,
      semanticHighlighting = true,
    },
    single_file_support = true
  }

  local clangd_ext_ok, clangd_ext = pcall(require, "clangd_extensions")

  if clangd_ext_ok then
    return clangd_ext.setup { server = default_config }
  else
    return lspconfig.clangd.setup(default_config)
  end
end
