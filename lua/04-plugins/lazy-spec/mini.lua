return {
  "echasnovski/mini.nvim",
  version = '*',
  config = function()
    local enabled_modules = {
      -- Adds ge, gx, gr, gm, gs
      -- Eval, exange, replace, multiply, sort operators.
      ["mini.operators"] = nil,

      -- Adds more textobjects and enhacces existing ones.
      ["mini.ai"] = nil,

      -- Allows you to perform operations on surrounding motions.
      ["mini.surround"] = {
        mappings = {
          add = 'gsa',            -- Add surrounding in Normal and Visual modes
          delete = 'gsd',         -- Delete surrounding
          find = 'gsf',           -- Find surrounding (to the right)
          find_left = 'gsF',      -- Find surrounding (to the left)
          highlight = 'gsh',      -- Highlight surrounding
          replace = 'gsr',        -- Replace surrounding
          update_n_lines = 'gsn', -- Update `n_lines`
          suffix_last = 'l',      -- Suffix to search with "prev" method
          suffix_next = 'n',      -- Suffix to search with "next" method
        }
      }
    }

    for module, opts in pairs(enabled_modules) do
      Safe.import_then(module, function(m)
        m.setup(opts)
      end)
    end
  end
}
