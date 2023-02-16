return function(clangd, capabilities, on_attach)
  local root_pattern = require("lspconfig.util").root_pattern

  local config = {
    on_attach           = on_attach,
    capabilities        = capabilities,
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
    root_dir            = root_pattern(
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

  local clangd_ext_present, clangd_ext = pcall(require, "clangd_extensions")

  if clangd_ext_present then
    clangd_ext.setup { server = config }
  else
    clangd.setup(config)
  end
end
