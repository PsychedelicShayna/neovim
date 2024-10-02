-- Add cmp_nvim_lsp capabilities to the standard nvim client capabilities.
-- Since clean nvim itself rightfully does not advertise these capabilities.

local function extend_client_capabilities(capabilities)
  local extended_capabilities = vim.deepcopy(capabilities)

  local cmp_nvim_lsp_ok,
  cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')

  if cmp_nvim_lsp_ok then
    -- Add cmp_nvim_lsp capabilities to the extended client capabilities.
    extended_capabilities = vim.tbl_deep_extend(
      'force',
      extended_capabilities,
      cmp_nvim_lsp.default_capabilities()
    )
  end

  return extended_capabilities
end

local function custom_on_attach(client, bufnr)
  if not client then
    vim.notify('Client attached to buffer ' .. bufnr .. ' but client was falsey')
    return
  end

  -- TODO:
  -- local mapper_ok, mapper = pcall(require, 'keybindings.lsp_dynmic_keymaps')
  --
  -- if mapper_ok and type(mapper) == 'function' then
  --   mapper(client, bufnr)
  -- end
end

-- Attempts to find a lua module with the same name as the language server
-- under 06-lspconf/ and will try to import it, expecting it to return a
-- function. That function will then receive all of the context and take
-- care of setting up the language server.

local function try_custom_setup(ls_name, ls_entry, capabilities, on_attach)
  local custom_setup_path = '06-lspconf.' .. ls_name
  local return_value, setup_fn = pcall(require, custom_setup_path)
  if return_value then return setup_fn(ls_entry, capabilities, on_attach) end
  return return_value
end

return {

  -- Optional plugins that enhance the LSP experience, or provide their own.
  -------------------------------------------------------------------------------
  {
    "simrat39/rust-tools.nvim", -- No longer maintained.
    -- "mrcjkb/rustaceanvim", -- Fork of rust-tools.nvim; spiritual successor.
    version = '^3',        -- Pin to version 3.x.x.
    ft = { 'rust' },       -- Lazy load on Rust files.
  },

  {
    "MrcJkb/haskell-tools.nvim",
    version = '^3',
    ft = { 'haskell', 'lhaskell', 'cabal', 'cabalproject' },
  },

  { "p00f/clangd_extensions.nvim", config = true,                      lazy = false },
  { "folke/neodev.nvim",           lazy = false,                       config = true },
  { "manicmaniac/coconut.vim",     ft = { ".coco", ".co", ".coconut" } },
  { "j-hui/fidget.nvim",           tag = "legacy",                     config = true },
  { "udalov/kotlin-vim",           config = false,                     lazy = false },


  -- The meat of the LSP setup..
  -------------------------------------------------------------------------------
  {
    'williamboman/mason.nvim',
    lazy = true,
    config = true
  },

  {
    'williamboman/mason-lspconfig.nvim',
    lazy = true,
    dependencies = {
      'williamboman/mason.nvim'
    },
    config = function()
      require('mason-lspconfig').setup()
    end
  },

  {
    'neovim/nvim-lspconfig',
    lazy = false,
    dependencies = 'williamboman/mason-lspconfig.nvim',
    event = 'FileType',
    config = function()
      local neodev_ok, neodev = pcall(require, 'neodev')
      if not neodev_ok then
        vim.notify('Failed to import neodev')
      else
        neodev.setup()
      end

      local lspconfig = require('lspconfig')
      local mason_lspconfig = require('mason-lspconfig')

      -- Extend the default client capabilities.
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = extend_client_capabilities(capabilities)

      -- Get the installed language servers.
      local installed_ls_names = mason_lspconfig.get_installed_servers()

      if not Safe.t_is(_G.lspconf_overrides, 'table') then
        _G.lspconf_overrides = {}
      end

      -- Setup all of the installed langauge servers.
      for _, ls_name in ipairs(installed_ls_names) do
        local ls_entry = lspconfig[ls_name]

        -- Try setting the server up using the user-provided custom setup
        -- function. These are stored under "lsp-custom-setup"
        local custom_config_ok = try_custom_setup(
          ls_name, ls_entry, capabilities, custom_on_attach
        )

        -- If that fails, then just use the default setup function.
        if not custom_config_ok then
          ls_entry.setup {
            capabilities = capabilities,
            on_attach = custom_on_attach
          }
        else
          _G.lspconf_overrides[ls_name] = custom_config_ok
        end
      end

      -- Regsiter a user command to view the loaded custom LSP config overrides.
      vim.api.nvim_create_user_command("LspListLoadedSetups", function(opts)
        Safe.try(function()
          PrintDbg('Dumping successfully loaded custom LSP config overrides..',
            LL_INFO, { _G.lspconf_overrides }
          )
        end)
      end, {})

      Events.fire_event {
        actor = "lspconfig",
        event = "configured"
      }
    end
  },
}
