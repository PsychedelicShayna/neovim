local events = require("prelude").events

return function(client, bufnr)
  local mappings = {}
  local capabilities = client.server_capabilities

  if capabilities == nil then
    vim.notify("Ignoring which-key mappings for LSP client with nil server_capabilities: " .. vim.inspect(client))
    return
  end

  if capabilities.codeActionProvider then
    mappings["a"] = {
      "<cmd>lua vim.lsp.buf.code_action()<cr>",
      "Code Action",
    }
  end

  if capabilities.declarationProvider then
    mappings["D"] = {
      "<cmd>lua vim.lsp.buf.declaration()<cr>",
      "View Declaration",
    }
  end

  if capabilities.definitionProvider then
    mappings["d"] = {
      "<cmd>Telescope lsp_definitions<cr>",
      "View Definition",
    }
  end

  if capabilities.documentSymbolProvider then
    mappings["s"] = {}
  end

  if capabilities.documentFormattingProvider then
    mappings["f"] = {
      "<cmd>lua vim.lsp.buf.format { async = true }<cr>",
      "Format",
    }
  end

  if capabilities.hoverProvider then
    mappings["h"] = {
      "<cmd>lua vim.lsp.buf.hover()<cr>",
      "Hover Over",
    }

    client.config.handlers["textDocument/hover"] = vim.lsp.with(
      vim.lsp.handlers.hover, {
        border = "single",
        title = ' ' .. client.config.name .. ' '
      }
    )
  end

  if capabilities.implementationProvider then
    mappings["i"] = {
      "<cmd>lua vim.lsp.buf.implementation()<cr>",
      "View Implementation",
    }
  end

  if capabilities.referencesProvider then
    mappings["R"] = {
      "<cmd>Telescope lsp_references<cr>",
      "Find References"
    }
  end

  if capabilities.renameProvider then
    mappings["r"] = {
      "<cmd>lua vim.lsp.buf.rename()<cr>",
      "Rename Symbol",
    }
  end

  if capabilities.signatureHelpProvider then
    mappings["s"] = {
      "<cmd>lua vim.lsp.buf.signature_help()<cr>",
      "View Signature",
    }
  end

  if capabilities.workspaceSymbolProvider then
    mappings["W"] = {
      "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
      "Find Workspace Symbols",
    }
  end

  if capabilities.documentFormattingProvider then
    mappings["F"] = {
      "<cmd>:ToggleAutoFormat<cr>",
      "Toggle AutoFormat"
    }
  end

  events.run_after("configured", "which-key", function(data)
    local which_key = require("which-key")

    which_key.register(mappings, {
      prefix = "<leader>l",
      mode = "n",
      buffer = bufnr
    })
  end)
end
