--    |                                     |  Mode Characters Quick Reference
--    | N | Normal           | I | Insert   |
--    | V | Visual           | X | Vblock   |
--    | C | Command          | T | Terminal |
--    |_____________________________________|

--  ! Leader Key !
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

function MapKey(binding)
  if Safe.t_not(binding, 'table') then
    PrintDbg("MapKey: binding is not a table, was ", LL_ERROR, { binding })
    return false
  end

  if Safe.t_not(binding, { 'string', 'table' }) then
    PrintDbg("Cannot map key because it wasn't ", LL_ERROR, { binding })
    return false
  end

  if Safe.t_is(binding.modes, 'nil') then
    binding.modes = 'n'
  elseif Safe.t_not(binding.modes, { 'string', 'table' }) then
    PrintDbg("Invalid type for mode to bind key to!", LL_ERROR, { binding })
    return false
  end

  if Safe.t_not(binding.opts, 'table') then
    binding.opts = {
      noremap = true,
      silent = true
    }
  end

  if Safe.t_not(binding.unset, 'nil') then
    vim.unset_keymap(binding.modes, binding.key)
  end

  vim.keymap.set(
    binding.modes,
    binding.key,
    binding.does,
    binding.opts
  )

  if Safe.t_not(binding.description, { 'nil', 'string' }) then
    PrintDbg(
      "Description of keybind has an invalid type.", LL_WARN, {
        binding.description
      }
    )

    binding.description = nil
  end

  Events.fire_event {
    actor = 'MapKey',
    event = 'mapped',
    data  = binding.description or nil
  }
end
