local M = {}

local function export(export_table)
  local exported = {}

  for module_name, module_path in pairs(export_table) do
    if type(module_name) == 'string' and type(module_path) == 'string' then
      local module_ok, module = pcall(require, module_path)

      if not module_ok then
        PrintDbg('Failed to export module "' .. module_path .. '"', LL_ERROR, { module_ok, module })
      else
        exported[module_name] = module
      end
    end
  end

  return exported
end

local lib_modules = {
  check_greeter_skip = '04-custom.01-lib.check-greeter-skip',
  functional         = '04-custom.01-lib.functional',
  shell_precedence   = '04-custom.01-lib.shell-precedence',
  smart_key_mapper   = '04-custom.01-lib.keymap_nx',
  typecheck          = '04-custom.01-lib.typecheck',
  window_sizer       = '04-custom.01-lib.window-sizer',
  error_handler      = '04-custom.01-lib.error-handler',
  map_key            = '04-custom.01-lib.mapkey',
}

UsrLib = export({
  check_greeter_skip = lib_modules.check_greeter_skip,
  map_key = lib_modules.map_key,
  error_handler = lib_modules.error_handler
})


local functionality_modules = {
  -- background_control = '04-custom.02-fun.background-control',
  autocomment          = "04-custom.02-fun.autocomment",
  auto_diag_loclist    = "04-custom.02-fun.auto-diag-loclist",
  autorunner           = "04-custom.02-fun.autorunner",
  cdtracker            = "04-custom.02-fun.cdtracker",
  lsp_auto_format      = "04-custom.02-fun.lsp-auto-format",
  spellcheck           = "04-custom.02-fun.spellcheck",
  yank_highlighter     = "04-custom.02-fun.yank-highlighter",
  scratch_pad          = "04-custom.02-fun.scratch-pad",
  toggle_diagnostics   = "04-custom.02-fun.toggle-diagnostics",
  switch_header_source = "04-custom.02-fun.switch_header_source",
  flashbang            = "04-custom.02-fun.flashbang"
}

UsrFun = functionality_modules

local auto_load_functionality = {
  -- UsrFun.lsp_auto_format,
  UsrFun.yank_highlighter,
  UsrFun.auto_diag_loclist,
  UsrFun.background_control,
  UsrFun.scratch_pad,
  UsrFun.spellcheck,
  UsrFun.autorunner,
  UsrFun.toggle_diagnostics,
  UsrFun.switch_header_source,
  UsrFun.flashbang,
}

for name, path in pairs(auto_load_functionality) do
  local module_ok, module = pcall(require, path)

  if not module_ok then
    PrintDbg('Failed to autoload module "' .. name
      .. '" using path "' .. vim.inspect(path) .. '"', LL_ERROR, { module_ok, module })
  end
end

-- require 'lib.lsp_auto_format'
-- require 'lib.spellcheck'
-- require 'lib.yank_highlighter'
-- require 'lib.cdtracker'
-- require 'lib.background_control'
-- require 'lib.auto_diag_loclist'
-- require 'lib.auto_diag_loclist'
