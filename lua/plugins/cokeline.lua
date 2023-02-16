local config = function(plugin)
  local ok, cokeline = pcall(require, "cokeline")

  if not ok then
    vim.notify("Config fail for " .. plugin.name .. " could not find plugin.")
  end

  local symbols_ok, symbols = pcall(require, "tables.symbols")
  if not symbols_ok then
    vim.notify("Ignored cokeline config because tables.symbols could not be found.")
    return
  end

  local bright_text

  local bright
  local grey
  local grey_text

  local dark
  local dark_text

  -- This table contains functions that should be called in place of setting the
  -- bright/grey/dark locals to the TablineSel/Tabline/TablineFill highlights,
  -- for colorschemes that improperly define them.
  local overrides = {
    onedark = function()

    end,
    aurora = function()
      -- Example
    end
  }

  -- Tabline/TablineSel/TablineFill colors by default. This should be
  -- defined in most themes, and in cases where it isn't, or is improperly
  -- defined, then the values should be given manually in the table.

  local get_hex = require("cokeline/utils").get_hex

  function update_highlights()
    local override_fn = overrides[vim.g.colors_name]

    if override_fn ~= nil then
      return override_fn()
    end

    bright = get_hex("TablineSel", "bg")
    bright_text = get_hex("TablineSel", "fg")

    grey = get_hex("Tabline", "bg")
    grey_text = get_hex("Tabline", "fg")

    dark = get_hex("TablineFill", "bg")
    dark_text = get_hex("TablineFill", "fg")
  end

  update_highlights()

  vim.api.nvim_create_autocmd({ "ColorScheme" }, {
    callback = update_highlights
  })

  --   

  cokeline.setup {
    buffers = {
      filter_valid = function(buffer)
        local disabled_filetypes = { "dashboard", "NvimTree", "Outline", "alpha" }
        return disabled_filetypes[buffer.filetype] == nil
      end
    },

    default_hl = {
      fg = function(buffer)
        if buffer.is_focused then
          return bright_text
        end

        return grey_text
      end,

      bg = function(buffer)
        if buffer.is_focused then
          return bright
        end

        return grey
      end,

      style = function(buffer)
        if buffer.is_focused then
          return "bold"
        end
      end
    },

    sidebar = {
      filetype = "NeoTree",
      components = {
        {
          text = "          NeoTree",
          fg = function(buffer) return bright_text end,
          bg = function(buffer) return bright end,
          style = "bold"
        }
      }
    },

    components = {
      {
        text = symbols.slant_left,
        fg = function(buffer)
          if buffer.is_focused then
            return bright
          end

          return grey
        end,

        bg = function(buffer)
          if buffer.is_first and buffer.is_focused then
            return bright
          elseif buffer.is_first then
            return grey
          else
            return dark
          end
        end
      },
      {
        text = function(buffer) return ' [' .. buffer.index .. '] ' end,
      },
      {
        text = function(buffer)
          local text = ""
          --    

          local warnings = buffer.diagnostics.warnings
          local errors = buffer.diagnostics.errors

          if warnings ~= 0 then
            text = text .. string.format(" %s ", warnings)
          end

          if errors ~= 0 then
            text = text .. string.format(" %s ", errors)
          end

          -- if string.len(text) == 0 then
          --   -- return " "
          -- end

          return text
        end
      },
      {
        text = function(buffer) return buffer.unique_prefix end
      },
      {
        text = function(buffer) return buffer.filename end
      },
      {
        text = function(buffer) return ' ' .. buffer.devicon.icon end,
      },
      {
        text = function(buffer)
          return symbols.slant_left
        end,
        fg = function(buffer)
          return dark
        end,
        bg = function(buffer)
          if buffer.is_focused then
            return bright
          end

          return grey
        end
      }
    }
  }

  vim.api.nvim_set_keymap("n", "<S-h>", "<Plug>(cokeline-focus-prev)", { silent = true })
  vim.api.nvim_set_keymap("n", "<S-l>", "<Plug>(cokeline-focus-next)", { silent = true })
  vim.api.nvim_set_keymap("n", "<A-H>", "<Plug>(cokeline-switch-prev)", { silent = true })
  vim.api.nvim_set_keymap("n", "<A-L>", "<Plug>(cokeline-switch-next)", { silent = true })
end

return {
  "noib3/nvim-cokeline",
  event = function(_, _)
    if require("utils.check_greeter_skip")() then
      return { "VimEnter" }
    end

    return { "BufAdd" }
  end,
  dependencies = "nvim-tree/nvim-web-devicons",
  init = function(plugin)
    vim.o.showtabline = 0
  end,

  config = function(_)
    vim.defer_fn(config, 200)
  end,
}
