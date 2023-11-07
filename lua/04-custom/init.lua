local library_modules = {
  check_greeter_skip = '04-custom.01-lib.check_greeter_skip',
  functional         = '04-custom.01-lib.functional',
  shell_precedence   = '04-custom.01-lib.shell_precedence',
  smart_key_mapper   = '04-custom.01-lib.smart_key_mapper',
  typecheck          = '04-custom.01-lib.typecheck',
  window_sizer       = '04-custom.01-lib.window_sizer',
}

CustomLib = library_modules

local auto_load_libraries = {
  CustomLib.smart_key_mapper
}

local functionality_modules = {
  background_control = '04-custom.02-lib.background-control',
  autocomment 	     = "04-custom.02-fun.autocomment",
  auto_diag_loclist  = "04-custom.02-fun.auto-diag-loclist",
  autorunner 	       = "04-custom.02-fun.autorunner",
  cdtracker 	       = "04-custom.02-fun.cdtracker",
  lsp_auto_format    = "04-custom.02-fun.lsp-auto-format",
  spellcheck 	       = "04-custom.02-fun.spellcheck",
  yank_highlighter   = "04-custom.02-fun.yank-highlighter",
}

CustomFun = functionality_modules

local auto_load_functionality = {
  CustomFun.lsp_auto_format,
  CustomFun.yank_highlighter,
  CustomFun.auto_diag_loclist,
  CustomFun.spellcheck,
  CustomFun.autorunner
}

for name, path in pairs(auto_load_functionality) do
  local module_ok, module = pcall(require, path)

  if not module_ok or type(module) ~= 'string' then
    eprint('Failed to autoload module "' .. name
      .. '" using path "' .. path .. '"', LL_ERROR, {module_ok, module})
  else
    eprint('Autoloaded module "' .. name .. '" @ "' .. path .. '"', LL_TRACE)
  end
end

 -- require 'lib.lsp_auto_format'
 -- require 'lib.spellcheck'
 -- require 'lib.yank_highlighter'
 -- require 'lib.cdtracker'
 -- require 'lib.background_control'
 -- require 'lib.auto_diag_loclist'




