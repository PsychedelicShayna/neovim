local on_attach = function(client, bufnr)
  local opts = { noremap = true, silent = true }
  -- vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, "n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>f", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, "n", "[d", '<cmd>lua vim.diagnostic.goto_prev({ border = "rounded" })<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "]d", '<cmd>lua vim.diagnostic.goto_next({ border = "rounded" })<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)

  if client.server_capabilities.documentHighlightProvider then
    vim.api.nvim_create_autocmd({ "CursorHold" }, {
      callback = function()
        vim.lsp.buf.document_highlight()
      end,
      buffer = bufnr
    })

    vim.api.nvim_create_autocmd({ "CursorMoved" }, {
      callback = function()
        vim.lsp.buf.clear_references()
      end,
      buffer = bufnr
    })
  end

  if client.server_capabilities.documentFormattingProvider then
    vim.api.nvim_create_autocmd({ "BufWritePre" }, {
      callback = function()
        if LspEnableAutoFormat then
          vim.lsp.buf.format { async = true }
        end
      end,
    })
  end
end

local default_capabilities = vim.lsp.protocol.make_client_capabilities()

-- If nvim-cmp and cmp-nvim-lsp are present then extend the capabilities
-- that will be provided to each LSP server so that it includes the expanded
-- capabilities of cmp-nvim-lsp; the LSP server will respond with different
-- completion results depending on the client's capabilities, and by default
-- VIM's omnifunc completion client does not advertise the full range of
-- completion capabilities as it does not support them, whereas nvim-cmp does,
-- so the capabilities advertised to the server should be adjusted accordingly.
local cmp_nvim_lsp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
local _, nvim_cmp_ok = pcall(require, "cmp")

if cmp_nvim_lsp_ok and nvim_cmp_ok then
  default_capabilities = vim.tbl_deep_extend(
    "force",
    default_capabilities,
    cmp_nvim_lsp.default_capabilities()
  )
else
  vim.notify("Cannot find \"cmp_nvim_lsp\" and or \"cmp\", and so the default LSP capabilities will not be extended.")
end

return function(lspconfig, lsp_server_list)
  for _, lsp_server_name in ipairs(lsp_server_list) do
    local module_name = "plugins.lsp.configs." .. lsp_server_name
    local module_ok, module = pcall(require, module_name)

    if module_ok then
      module(lspconfig, on_attach, default_capabilities)
    end
  end
end
