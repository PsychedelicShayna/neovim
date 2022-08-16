local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_ok then
  vim.notify("Could not import lspconfig from lsp/lsp.lua")
  return
end

require "plugins.lsp.lsp-installer"
require "plugins.lsp.handlers".setup()
require "plugins.lsp.null-ls"
require "plugins.lsp.lsp-signature"

local capabilities = vim.lsp.protocol.make_client_capabilities()

capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
	properties = { "documentation", "detail", "additionalTextEdits" },
}

require("cmp_nvim_lsp").update_capabilities(capabilities)
