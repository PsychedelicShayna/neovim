local cokeline_ok, cokeline = pcall(require, "cokeline")
if not cokeline_ok then
  vim.notify("Ignored cokeline config, because cokeline could not be found.")
  return
end

local get_hex = require("cokeline/utils").get_hex


local bright
local bright_text

local grey
local grey_text

local dark
local dark_text


-- This table contains functions that should be called in place of setting the
-- bright/grey/dark locals to the TablineSel/Tabline/TablineFill highlights,
-- for colorschemes that improperly define them.
local overrides = {
  onedark = function()
    -- Example
  end,

  aurora = function()
    -- Example
  end
}

-- Uses Tabline/TablineSel/TablineFill colors by default. This should be
-- defined in most themes, and in cases where it isn't, or is improperly
-- defined, then the values should be given manually in the table.
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
    filetype = "NvimTree",
    components = {
      {
        text = "          NvimTree",
        fg = function(buffer) return bright_text end,
        bg = function(buffer) return bright end,
        style = "bold"
      }
    }
  },

  components = {
    {
      text = "",
      fg = function(buffer)
        if buffer.is_focused then
          return bright
        end

        return grey
      end,

      bg = function(buffer)
        if buffer.is_first and buffer.is_focused then
          return bright
        else
          return grey
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

        if string.len(text) == 0 then
          return " "
        end

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
      text = function(buffer) return ' ' .. buffer.devicon.icon end
    },
    {
      text = function(buffer)
        return ""
      end,
      fg = function(buffer)
        if buffer.is_last then
          return dark
        else
          return grey
        end
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
