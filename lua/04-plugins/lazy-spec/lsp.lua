-- Add cmp_nvim_lsp capabilities to the standard nvim client capabilities.
-- Since clean nvim itself rightfully does not advertise these capabilities.

local function cmp_nvim_lsp_extend_caps(capabilities)
  local imported_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
  local newcap = vim.deepcopy(capabilities)

  if imported_ok then
    -- Add cmp_nvim_lsp capabilities to the extended client capabilities.
    newcap = vim.tbl_deep_extend(
      'force',
      newcap,
      cmp_nvim_lsp.default_capabilities()
    )
  end
  -----------------------------------------------
  return newcap
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
-- under 06-lspsetup/ and will try to import it, expecting it to return a
-- function. That function will then receive all of the context and take
-- care of setting up the language server.

local function try_custom_setup(ls_name, ls_entry, capabilities, on_attach)
  local custom_setup_path = '06-lspsetup.' .. ls_name
  local return_value, setup_fn = pcall(require, custom_setup_path)
  if return_value then return setup_fn(ls_entry, capabilities, on_attach) end
  return return_value
end

return {

  -- Optional plugins that enhance the LSP experience, or provide their own.
  -------------------------------------------------------------------------------
  {
    -- "simrat39/rust-tools.nvim", -- No longer maintained.

    "mrcjkb/rustaceanvim", -- Fork of rust-tools.nvim; spiritual successor.
    version = '^5',        -- Pin to version 5.x.x. to avoid breaking changes.
    lazy = false,          -- Does its own lazy loading, leave it alone.
    config = function()
      vim.g.rustaceanvim = {
        tools = {
          float_win_config = {
            border = 'rounded'
          }
        },
      }
    end,
  },

  {
    "hylang/vim-hy",
    ft = { "hy" },
    init = function()
      -- Visualize keywords as unicode, e.g.
      -- sum        ->  ∑
      -- lambda     ->  λ
      -- math.sqrt  ->  √
      -- etc...
      vim.g.hy_enable_conceal = 1
    end
  },

  {
    "MrcJkb/haskell-tools.nvim",
    version = '^3',
    ft = { 'haskell', 'lhaskell', 'cabal', 'cabalproject' },
  },

  { "p00f/clangd_extensions.nvim", enabled = true,  config = true,  ft = { 'cpp', 'c' }, },
  { "manicmaniac/coconut.vim",     enabled = false, config = false, ft = "coconut" },
  { "udalov/kotlin-vim",           enabled = false, config = false, ft = 'kotlin' },
  { "j-hui/fidget.nvim",           enabled = false, config = true,  tag = "legacy" },

  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    },
  },

  { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings

  -- The meat of the LSP setup..
  -------------------------------------------------------------------------------
  {
    'williamboman/mason.nvim',
    -- lazy = true,
    config = true
  },

  {
    'williamboman/mason-lspconfig.nvim',
    -- lazy = true,
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
    dependencies = {
      'williamboman/mason-lspconfig.nvim',
    },

    config = function()
      local lspconfig = require('lspconfig')
      local mason_lspconfig = require('mason-lspconfig')

      local lsp_configs = require("lspconfig.configs")

      -- Extend the default client capabilities.
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = cmp_nvim_lsp_extend_caps(capabilities)

      Events.fire_event {
        actor = "lspconfig",
        event = "custom",
        data = {
          capabilities = capabilities,
          custom_on_attach = custom_on_attach
        }
      }

      -- Get the installed language servers.
      local installed_ls_names = mason_lspconfig.get_installed_servers()

      if not Safe.t_is(_G.lspconf_overrides, 'table') then
        _G.lspconf_overrides = {}
      end

      -- Setup all of the installed langauge servers.
      for _, ls_name in ipairs(installed_ls_names) do
        local filetypes = lspconfig[ls_name].config_def.default_config.filetypes

        vim.api.nvim_create_autocmd("FileType", {
          once = true,
          pattern = filetypes,
          callback = function(_)
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
        })
      end


      -- Regsiter a user command to view the loaded custom LSP config overrides.
      vim.api.nvim_create_user_command("LspListLoadedSetups", function(_)
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
