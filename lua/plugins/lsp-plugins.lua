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

local function on_attach(client, bufnr)
  if client.server_capabilities.documentHighlightProvider then
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

return {
  { "williamboman/mason.nvim",
    priority = 2000,
    config = true
  },

  { "williamboman/mason-lspconfig.nvim",
    priority = 1999,
    config = function()
      local mason_lspconfig = require("mason-lspconfig")
      mason_lspconfig.setup()

      vim.defer_fn(function()
        update_precomputed_lsp_list(mason_lspconfig)
      end, 5000)
    end
  },

  { "neovim/nvim-lspconfig",
    priority = 1979, -- ;)
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
    config = {},
    lazy = true,
    -- ft = { "c", "cpp" }
  },

  { "simrat39/rust-tools.nvim",
    config = {},
    lazy = true,
    -- ft = "rust"
  },

  { "MrcJkb/haskell-tools.nvim",
    config = {},
    lazy = true,
    -- ft = "haskell"
  }
}
