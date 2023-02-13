local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_ok then
  vim.notify("Ignoring plugins.lsp.configs.hyuga because lspconfig could not be imported")
  return
end

local util = lspconfig.util

local default_capabilities = {
  textDocument = {
    completion = {
      editsNearCursor = true,
    },
  },
  offsetEncoding = { 'utf-8', 'utf-16' },
}

local root_files = {
  'pyproject.toml',
  'setup.py',
  'setup.cfg',
  'requirements.txt',
  'Pipfile',
  'pyrightconfig.json',
}

return {
  default_config = {
    cmd = { "hyuga" },
    filetypes = { "hy" },
    root_dir = function(fname)
      return util.root_pattern(unpack(root_files)) or util.find_git_ancestor(fname)
    end,
    single_file_support = true,
    capabilities = default_capabilities,
  },
  commands = {},
  docs = {
    description = [[
    ]],
    default_config = {
      root_dir = [[
        root_pattern(
          '.clangd',
          '.clang-tidy',
          '.clang-format',
          'compile_commands.json',
          'compile_flags.txt',
          'configure.ac',
          '.git'
        )
      ]],
      capabilities = [[default capabilities, with offsetEncoding utf-8]],
    },
  },
}
