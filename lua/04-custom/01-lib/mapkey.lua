--    |                                     |  Mode Characters Quick Reference
--    | N | Normal           | I | Insert   |
--    | V | Visual           | X | Vblock   |
--    | C | Command          | T | Terminal |
--    |_____________________________________|

--  ! Leader Key !
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

---@class MapKeySpec
---@field modes table | string | nil Same as vim.keymap.set modes
---@default modes "Nil"
local MapKeySpec = {}


---@param binding table
---@return boolean
--- More convenient way to set keybinds.
function MapKey(binding)
  if type(binding) ~= 'table' then
    PrintDbg("MapKey: binding is not a table, was ", LL_ERROR, { binding })
    return false
  end

  if Safe.t_not(binding, { 'string', 'table' }) then
    PrintDbg("Cannot map key because it wasn't ", LL_ERROR, { binding })
    return false
  end

  if binding.modes == nil then
    binding.modes = 'n'
  elseif Safe.t_not(binding.modes, { 'string', 'table' }) then
    PrintDbg("Invalid type for mode to bind key to!", LL_ERROR, { binding })
    return false
  end

  if type(binding.opts) ~= 'table' then
    binding.opts = {
      noremap = true,
      silent = true
    }
  end

  if binding.unset ~= nil then
    vim.unset_keymap(binding.modes, binding.key)
  end

  if binding.desc ~= nil and type(binding.desc) ~= 'string' then
    PrintDbg(
      "Description of keybind has an invalid type.", LL_WARN, {
        binding,
        binding.desc
      }
    )

    binding.desc = nil
  elseif binding.desc ~= nil then
    binding.opts.desc = binding.desc
  end

  vim.keymap.set(
    binding.modes,
    binding.key,
    binding.does,
    binding.opts
  )

  Events.fire_event {
    actor = 'MapKey',
    event = 'mapped',
    data  = binding.desc
  }
end
