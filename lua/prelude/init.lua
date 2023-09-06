---- Namespace Table ----------------------------------------------------------

-- You're most likely here to register a new namespace by adding its name
-- to the table. The rest of the module is not intended to be mutated.

local M = {
  _namespaces = {
    'lib'
  }
}

---- Module Description -------------------------------------------------------

--
--   This is the prelude module. Within the prelude folder, subfolders can be
--   created that represent "namespaces", which will, upon inclusion in the
--   _namespaces table down below, become part of the prelude module, accessible
--   by doing require('prelude').namespace1, for instance.
--
--   Each namespace has its own exports.lua file, which governs what modules will
--   be accessible through that namespace, i.e. require('prelude').name1.module
--
--   Likewise, each module is responsible for what functions it exports, just as
--   each namespace is responsible for what modules it exports, and the prelude
--   module itself is responsible for what namespaces it exports.
--
--   Here is a hierarchy to help in visualizing this structure:
--
--  prelude/
--  ├─ init.lua____________You are here.
--  └─lib/_________________This is a namespace called lib.
--    ├─export.lua_________This defines what modules will be exported.
--    └─modules/___________These are its internal modules it can export.
--       ├─events.lua
--       ├─functools.lua
--       ├─startcheck.lua
--       ├─filesystem.lua
--       └─mapkey.lua
--


------------------------ Implementation Details -------------------------------

-- The standard module name to search for when looking for a namespace's
-- exporter, which defines what modules are exported from that namespace.
M._EXPORTER_MODULE_NAME = 'export'

-- Exporters that do not define the optional "defaults()" function are named
-- here. These require manual action in order to export their modules, as no
-- way to automatically export modules has been defined.
M._LACKING_DEFAULTS = {}

-------------------------------------------------------------------------------

-- Define these functions globally, so that they may be accessible down the
-- line by any module or module namespace exporter to standardize where the
-- definitions of these paths are located; each module should not need to
-- re-define this, it should not be hard-coded, but defined once.

function ExpandNamespaceModule(namespace, module_name)
  return 'prelude.' .. namespace .. '.modules.' .. module_name
end

function ExpandNamespaceExporter(namespace)
  return 'prelude.' .. namespace .. '.exports'
end

-------------------------------------------------------------------------------

-- Generic function to invoke an exporter. If no table specifying specific
-- modules that the exporter exports is provided, then the defaults()
-- function will be called instead, and if that does not exist either,
-- then this effectively does nothin more than return the list of
-- available modules that cannot be imported automatically.

local function export_namespace(namespace)
  local inferred_path = table.concat { 'prelude.', namespace,
                                        '.',       M._EXPORTER_MODULE_NAME
                                     }

  local exporter_ok, exporter = pcall(require, inferred_path)

---- Error Handling #1 --------------------------------------------------------

  if not exporter_ok then
    local msg = 'The inferred path to the exporter "' .. inferred_path .. '" '
    msg = msg .. 'did not import successfully. The name might be incorrect.'
    msg = msg .. vim.inspect(exporter)

    return 'error', msg

  elseif type(exporter) ~= 'table' then

    local msg = 'Task failed successfully? The inferred path to the exporter '
    msg = msg .. '"' .. inferred_path .. '" did import successfully, but it '
    msg = msg .. 'returns a "' .. type(exporter) .. '" rather than a table\n.'

    msg = msg .. 'Ignoring the error, and printing the type inspection: \n'
    msg = msg .. vim.inspect(exporter) .. '\n'

    return 'error', msg
  end

---- Error Handling #2 --------------------------------------------------------

  if not exporter.defaults then
    -- Check for the defaults() function within the exporter's table, and call
    -- it, if it is present. If it isn't, then register it as an exporter that
    -- lacks defaults.

    table.insert(M._LACKING_DEFAULTS, { inferred_path, exporter })
    local msg = 'INFO: '
    msg = msg .. 'The exporter "' .. inferred_path .. '" lacks a default() '
    msg = msg .. 'function, and so, no automatic importing can be done. Some '
    msg = msg .. 'manual effort is most likely required to use this it.'

     return 'info', msg
  elseif type(exporter.defaults) ~= 'function' then
    -- If it is defined, but isn't a function, notify the user of a bug in
    -- their configuration; default() should never be anything but a function.

    local msg = 'WARNING: '
    msg = msg .. 'The exporter "' .. inferred_path .. '" defines "defaults"'
    msg = msg .. 'bu t its type is incorrect. It should be a function, but is'
    msg = msg .. ' "' .. type(exporter.defaults) .. '" instead. Ignoring.'

    return 'warning', msg
  end

---- Intended Behavior --------------------------------------------------------
  M[namespace] = exporter.default()
end

for _, namespace in ipairs(M._namespaces) do
  local ok, msg = export_namespace(namespace)

  if not ok then
    vim.notify(msg)
  end

end

return M
