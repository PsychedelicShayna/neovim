local precomp_name = "lsp-ft-precomp"
local precomp_rtp = vim.fn.stdpath("data") .. "/" .. precomp_name

local function update_precomputed_lsp_list(mason_lspconfig)
  local precomp_file = precomp_rtp .. "/lua/" .. precomp_name .. ".lua"
  local installed_servers = mason_lspconfig.get_installed_servers()

  local precomputed = "return{"

  for _, server_name in ipairs(installed_servers) do
    local server = require("lspconfig")[server_name]
    local filetypes = server.document_config.default_config.filetypes

    precomputed = precomputed .. server_name .. "=" .. vim.inspect(filetypes) .. ","
  end

  precomputed = precomputed .. "}"

  local cache_file = io.open(precomp_file, "w+")

  if cache_file then
    cache_file:write(precomputed)
    cache_file:close()
  end
end

local function get_precomputed_lsp_list()
  vim.opt.rtp:prepend(precomp_rtp)

  local ok, file_types = pcall(require, precomp_name)

  if not ok then
    update_precomputed_lsp_list(require("mason-lspconfig"))
    local now_ok, file_types_hopefully = pcall(require, precomp_name)

    if not now_ok then
      return nil
    end

    return file_types_hopefully
  end

  return file_types
end

-- addWorkspaceFolder
-- clearReferences
-- codeAction
-- completion
-- declaration
-- definition
-- documentHighlight
-- documentSymbol
-- executeCommand
-- format
-- hover
-- implementation
-- incomingCalls
-- listWorkspaceFolders
-- outgoingCalls
-- references
-- removeWorkspaceFolder
-- rename
-- serverReady
-- signatureHelp
-- typeDefinition
-- workspaceSymbol

local function which_key_map_capabilities(client, bufnr)
  local scap = client.server_capabilities
  local mappings = {}

  if scap.codeActionProvider then
    mappings["a"] = {
      "<cmd>lua vim.lsp.buf.code_action()<cr>",
      "Code Action",
    }
  end

  if scap.declarationProvider then
    mappings["D"] = {
      "<cmd>lua vim.lsp.buf.declaration()<cr>",
      "View Declaration",
    }
  end

  if scap.definitionProvider then
    mappings["d"] = {
      "<cmd>Telescope lsp_definitions<cr>",
      "View Definition",
    }
  end

  if scap.documentSymbolProvider then
    mappings["s"] = {}
  end

  if scap.documentFormattingProvider then
    mappings["f"] = {
      "<cmd>lua vim.lsp.buf.format { async = true }<cr>",
      "Format",
    }
  end

  if scap.hoverProvider then
    mappings["h"] = {
      "<cmd>lua vim.lsp.buf.hover()<cr>",
      "Hover Over",
    }
  end

  if scap.implementationProvider then
    mappings["i"] = {
      "<cmd>lua vim.lsp.buf.implementation()<cr>",
      "View Implementation",
    }
  end

  if scap.referencesProvider then
    mappings["R"] = {
      "<cmd>Telescope lsp_references<cr>",
      "Find References"
    }
  end

  if scap.renameProvider then
    mappings["r"] = {
      "<cmd>lua vim.lsp.buf.rename()<cr>",
      "Rename Symbol",
    }
  end

  if scap.signatureHelpProvider then
    mappings["s"] = {
      "<cmd>lua vim.lsp.buf.signature_help()<cr>",
      "View Signature",
    }
  end

  if scap.workspaceSymbolProvider then
    mappings["W"] = {
      "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
      "Find Workspace Symbols",
    }
  end

  if scap.documentFormattingProvider then
    mappings["F"] = {
      "<cmd>:ToggleAutoFormat<cr>",
      "Toggle AutoFormat"
    }
  end

  require("global.control.events").new_cb_or_call(
    "plugin-loaded",
    "which-key",
    function()
      require("which-key").register(mappings, {
        prefix = "<leader>l",
        mode = "n",
        buffer = bufnr
      })
    end)
end

local function on_attach(client, bufnr)
  which_key_map_capabilities(client, bufnr)
  local scap = client.server_capabilities

  if scap.documentHighlightProvider then
    vim.api.nvim_create_autocmd({ "CursorHold" }, {
      callback = function()
        vim.lsp.buf.document_highlight()
        vim.api.nvim_create_autocmd({ "CursorMoved" }, {
          callback = function()
            vim.lsp.buf.clear_references()
            return true
          end,
          buffer = bufnr
        })
      end,
      buffer = bufnr
    })
  end

  if scap.documentFormattingProvider then
    vim.api.nvim_create_autocmd({ "BufWritePre" }, {
      callback = function()
        if LspEnableAutoFormat then
          vim.lsp.buf.format { async = true }
        end
      end,
    })
  end
end

return {
  { "williamboman/mason.nvim",
    lazy = true,
    priority = 2000,
    config = true
  },

  { "williamboman/mason-lspconfig.nvim",
    lazy = true,
    dependencies = "williamboman/mason.nvim",
    priority = 1999,
    config = function()
      local mason_lspconfig = require("mason-lspconfig")
      mason_lspconfig.setup()

      vim.defer_fn(function()
        update_precomputed_lsp_list(mason_lspconfig)
      end, 5000) -- Run an update on the precumputed LSP list 5 seconds after Mason starts.
    end
  },

  { "neovim/nvim-lspconfig",
    lazy = true,
    dependencies = "williamboman/mason-lspconfig.nvim",
    priority = 1979, -- ;)
    init = function()
      -- Defer the configuration of lspconfig to 250ms after a file type has been set.
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          vim.defer_fn(function()
            require("lspconfig")

            vim.api.nvim_exec_autocmds({ "FileType" }, {
              pattern = args.match
            })
          end, 250)

          return true
        end
      })
    end,
    config = function()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local cmp_lsp_present, cmp_lsp = pcall(require, "cmp_nvim_lsp")

      if cmp_lsp_present then
        local additional_capabilities = cmp_lsp.default_capabilities()

        capabilities = vim.tbl_deep_extend(
          "force",
          capabilities,
          additional_capabilities
        )
      end

      local lsp_servers = require("mason-lspconfig").get_installed_servers()
      local lsp_servers_ft = get_precomputed_lsp_list()

      local function setup_server(server_name)
        local server = require("lspconfig")[server_name]
        local has_cfg, configurator = pcall(require, "lspconfigs." .. server_name)

        if has_cfg then
          configurator(server, capabilities, on_attach)
        else
          server.setup { capabilities = capabilities, on_attach = on_attach }
        end
      end

      for _, server_name in ipairs(lsp_servers) do
        if lsp_servers_ft and lsp_servers_ft[server_name] then
          vim.api.nvim_create_autocmd({ "FileType" }, {
            pattern = lsp_servers_ft[server_name],
            callback = function()
              setup_server(server_name)

              -- Re-fire the "FileType" event so that LspConfig can detect it,
              -- and correctly start and attach the relevant server.
              vim.api.nvim_exec_autocmds({ "FileType" }, {
                group = "lspconfig",
                pattern = lsp_servers_ft[server_name]
              })

              return true
            end
          })
        else
          setup_server(server_name)
        end
      end
    end
  },

  { "p00f/clangd_extensions.nvim",
    config = true,
    lazy = true,
  },

  { "simrat39/rust-tools.nvim",
    config = true,
    lazy = true,
  },

  { "MrcJkb/haskell-tools.nvim",
    config = true,
    lazy = true,
  }
}
