local M = {
  _exported = {}

  namespace = 'lib',

  ensure = { 'events' },

  available = {
    'mapkey',
    'filesystem',
    'functools',
    'startcheck',
  },
}

function M.export_module(name)
  -- Ensure that the mandatory modules have already been exported,
  -- then check if this module itself has already ben exported.
  
  -- Why Lua?!
  local function _contains(table, element) 
    for _, ielement in ipairs(table) do
      if element == ielement then
        return true
      end
    end

    return false
  end

  for _, ensured_module_name in ipairs(M.ensure) do

  end
end

function M.export_defaults()
  
end


M.namespace = "lib"

-- These modules will be exported first before all other modules, even if not
-- explicitly requested, as other modules may depend on them.
M.mandatory_modules = { 'events' }

-- This table registers what modules are available in the current namespace.
M.available_modules = {
  'mapkey', 'filesystem', 'functools', 'startcheck',
}

function M.expand_path(short_name)
  return M.export_prefix .. short_name
end

t xt-k                       w                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              sadspo   lction M.add_export(module_name)
  local module_path = M.expand_path(module_name)
  local module_ok, module = pcall(require, module_path)

  if module_ok then
    vim.notify('Module ' .. module_path .. ' was ok')
    M[module_name] = module
  else
    vim.notify('Module ' .. module_path .. ' was not ok')
    M[module_name] = nil
  end
end

function M.export_modules(module_names)
  for _, module_name in ipairs(module_names) do
    M.add_export(module_name)
  end
end


return M
