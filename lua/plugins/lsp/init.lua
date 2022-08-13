local status_ok_lspconfig, lspconfig = pcall(require, "lspconfig")
if not status_ok_lspconfig then
  return
end

require "plugins.lsp.lsp-installer"
require ("plugins.lsp.handlers").setup()
require "plugins.lsp.null-ls"

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
	properties = { "documentation", "detail", "additionalTextEdits" },
}

local cmp_capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

local clangd_capabilities = cmp_capabilities
clangd_capabilities.textDocument.semanticHighlighting = true
clangd_capabilities.offsetEncoding = "utf-8"

lspconfig.clangd.setup {
    capabilities = clangd_capabilities,
    cmd = {
    	"clangd",
    	"--background-index",
    	"--pch-storage=memory",
    	"--clang-tidy",
    	"--suggest-missing-includes",
    	"--cross-file-rename",
    	"--completion-style=detailed",
    },
    init_options = {
    	clangdFileStatus = true,
    	usePlaceholders = true,
    	completeUnimported = true,
    	semanticHighlighting = true,
    }
}
