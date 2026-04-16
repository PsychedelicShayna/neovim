vim.lsp.config.fennel_language_server.settings = {
  fennel = {
    workspace = {
      library = vim.api.nvim_list_runtime_paths(),
    },
    diagnostics = {
      globals = { "vimm" },
    },
  },
}
