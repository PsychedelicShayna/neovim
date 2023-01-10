local cokeline_ok, cokeline = pcall(require, "cokeline")
if not cokeline_ok then
  vim.notify("Ignored cokeline config, because cokeline could not be found.")
  return
end

local get_hex = require("cokeline/utils").get_hex

local dark = get_hex("Normal", "bg")
local text = get_hex("Comment", "fg")
local grey = get_hex("ColorColumn", "bg")
local light = get_hex("Comment", "fg")

local ll_bright = get_hex("lualine_a_inactive", "fg")
local ll_bright_text = get_hex("lualine_a_replace", "fg")
local ll_grey = get_hex("lualine_b_command", "bg")
local ll_grey_text = get_hex("lualine_b_command", "fg")
local ll_dark = get_hex("lualine_a_inactive", "bg")

--   

cokeline.setup {
  default_hl = {
    fg = function(buffer)
      if buffer.is_focused then
        return ll_bright_text
      end

      return ll_grey_text
    end,

    bg = function(buffer)
      if buffer.is_focused then
        return ll_bright
      end

      return ll_grey
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
        fg = ll_bright_text,
        -- bg = get_hex("NvimTreeNormal", "bg"),
        bg = ll_bright,
        style = "bold"
      }
    }
  },

  components = {
    {
      text = "",
      fg = function(buffer)
        if buffer.is_focused then
          return ll_bright
        end

        return ll_grey
      end,

      bg = function(buffer)
        if buffer.is_first and buffer.is_focused then
          return ll_bright
        else
          return ll_grey
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
          return ll_dark
        else
          return ll_grey
        end
      end,
      bg = function(buffer)
        if buffer.is_focused then
          return ll_bright
        end

        return ll_grey
      end
    }
  }
}

vim.api.nvim_set_keymap("n", "<S-h>", "<Plug>(cokeline-focus-prev)", { silent = true })
vim.api.nvim_set_keymap("n", "<S-l>", "<Plug>(cokeline-focus-next)", { silent = true })
vim.api.nvim_set_keymap("n", "<A-H>", "<Plug>(cokeline-switch-prev)", { silent = true })
vim.api.nvim_set_keymap("n", "<A-L>", "<Plug>(cokeline-switch-next)", { silent = true })
