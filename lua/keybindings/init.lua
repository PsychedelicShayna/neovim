--    |                                     |  Mode Characters Quick Reference
--    | N | Normal           | I | Insert   |
--    | V | Visual           | X | Vblock   |
--    | C | Command          | T | Terminal |
--    |_____________________________________|

function MapKey(binding)
  if (type(binding) ~= 'table'
        or not binding.key
        or not binding.does
        or type(binding.key) ~= 'string'
        or type(binding.does) ~= 'string'
      ) then
    return false
  end

  if not binding.in_mode or type(binding.in_mode) ~= 'string' then
    binding.in_mode = 'n'
  end

  if not binding.with_options or type(binding.with_options) ~= 'table' then
    binding.with_options = {
      noremap = true,
      silent = true
    }
  end

  vim.api.nvim_set_keymap(
    binding.in_mode,
    binding.key,
    binding.does,
    binding.with_options
  )

  -- which_key.register(mappings, {
  --   prefix = "<leader>l",
  --   mode = "n",
  --   buffer = bufnr
  -- })

  if binding.with_wk and type(binding.with_wk) == 'table' then
    events.run_after("configured", "which-key", function()
      local wk_ok, wk = pcall(require, 'which-key')

      if not wk_ok then
        return 1
      end

      -- if type(w) 

      if (wk_ok and (type(wk['register']) == 'function')) then
        local mapping = {

        }

        wk.register(mappings, {
          prefix = wK_leader,
          binding.in_mode,
        })
      elseif type(wk.register) == 'table' then

      end
    end)
  end
end


require 'keybindings.default_keybindings'
require 'keybindings.lsp_dynamic_keymaps'
