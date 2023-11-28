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

  local mapper_ok, mapper = pcall(require, 'keybindings.lsp_dynmic_keymaps')

  if mapper_ok and type(mapper) == 'function' then
    mapper(client, bufnr)
  else
    vim.notify(
      'No "keybindings.lsp_dynmic_keymaps" module/function exported from module needed to create buffer-local keybindings for this LSP client.')
  end
end

local function try_custom_setup(ls_name, ls_entry, capabilities, on_attach)
  local custom_setup_path = 'lsp-custom-setup.' .. ls_name
  local has_custom_setup, custom_setup = pcall(require, custom_setup_path)

  if has_custom_setup and type(custom_setup) == 'function' then
    return custom_setup(ls_entry, capabilities, on_attach)
  end

  return false
end

local registered = false

local function register_hyuga()
  if registered then
    return
  end


  vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = { ".hy" },
    callbak = function()
      vim.lsp.start({
        cmd = { 'hyuga' },
        filetypes = 'hy',
        name = 'hyuga',
        root_dir = vim.fn.getcwd()
      })
    end
  })

  registered = true
end

return {
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
        end
      end
    end
  },
  {
    "simrat39/rust-tools.nvim",
    config = true,
    lazy = true,
  },

  {
    "MrcJkb/haskell-tools.nvim",
    config = false,
    lazy = true,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim', -- Optional
    },
  },

  {
    "p00f/clangd_extensions.nvim",
    config = true,
    lazy = true,
  },

  {
    "folke/neodev.nvim",
    lazy = false,
    config = false
  },

  {
    "manicmaniac/coconut.vim",
    ft = { ".coco", ".co", ".coconut" },
    lazy = true
  },

  {
    "j-hui/fidget.nvim",
    dependencies = { "neovim/nvim-lspconfig" },
    tag = "legacy",
    config = true
  },

  {
    "udalov/kotlin-vim",
    config = false,
    lazy = false
  },
}