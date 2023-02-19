local function which_key_mappings()
  require("which-key").register({
    ["f"] = {
      "<Plug>(cokeline-pick-focus)",
      "Focus (Letter)"
    },
    ["F"] = {
      "<Plug>(cokeline-pick-close)",
      "Delete Focus (Letter)"
    }
  }, {
    mode = "n",
    prefix = "<leader>n"
  })
end

-- This table contains functions that should be called in place of setting the
-- bright/grey/dark locals to the TablineSel/Tabline/TablineFill highlights,
-- for colorschemes that improperly define them.
local overrides = {
  onedark = function()
  end,
  aurora = function()
  end
}

local bright_text

local bright
local grey
local grey_text

local dark
local dark_text

-- Tabline/TablineSel/TablineFill colors by default. This should be
-- defined in most themes, and in cases where it isn't, or is improperly
-- defined, then the values should be given manually in the table.
function update_highlights()
  local get_hex = require("cokeline/utils").get_hex

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

local function get_cokeline_setup_table()
  local ok, symbols = pcall(require, "global.tables.symbols")
  if not ok then
    vim.notify("WARNING: Cokeline setup table defaulting due to missing import global.tables.symbols")
    return {}
  end

  return {
    buffers = {
      filter_valid = function(buffer)
        local disabled_filetypes = { "dashboard", "neo-tree", "Outline", "alpha", "Alpha" }
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
      filetype = "neo-tree",
      components = {
        {
          text = "         NeoTree",
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
      { text = function(buffer) return " [" .. buffer.pick_letter .. "] " end },
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

      { text = function(buffer) return buffer.unique_prefix end },
      { text = function(buffer) return buffer.filename end },
      { text = function(buffer) return ' ' .. buffer.devicon.icon end, },

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
end

return {
  "noib3/nvim-cokeline",
  dependencies = "nvim-tree/nvim-web-devicons",
  lazy = true,
  event = { "BufRead", "BufAdd", "BufNewFile", },
  init = function()
    vim.o.showtabline = 0
  end,
  config = function()
    require("global.control.events").new_cb_or_call("colorscheme", "loaded", function()
      require("cokeline").setup(get_cokeline_setup_table())

      update_highlights()
      vim.api.nvim_create_autocmd({ "ColorScheme" }, { callback = update_highlights })

      vim.api.nvim_set_keymap("n", "<S-h>", "<Plug>(cokeline-focus-prev)", { silent = true, nowait = true })
      vim.api.nvim_set_keymap("n", "<S-l>", "<Plug>(cokeline-focus-next)", { silent = true, nowait = true })
      vim.api.nvim_set_keymap("n", "<A-H>", "<Plug>(cokeline-switch-prev)", { silent = true, nowait = true })
      vim.api.nvim_set_keymap("n", "<A-L>", "<Plug>(cokeline-switch-next)", { silent = true, nowait = true })

      require("global.control.events").new_cb_or_call(
        "plugin-loaded",
        "which-key",
        function()
          which_key_mappings()
        end)
    end)
  end,
}
