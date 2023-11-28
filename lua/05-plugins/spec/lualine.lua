-- "   כּ ךּ    落   ﯽ  ﱴ"

local function config()
  local lualine = require("lualine")
  local symbols = Data.symbols


  local symbols = Safe.try_catch(function() return Data.symbols end,
    function(okv, mod)
      PrintDbg("ERROR: Lualine cannot find Data.symbols!", LL_ERROR, { okv, mod })
      return nil
    end)


  if not symbols then
    return nil
  end

  vim.o.showmode = false

  local hide_in_width = function()
    return vim.fn.winwidth(0) > 80
  end

  local spaces = function()
    return "spaces: " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
  end

  local function winbar_separator(foreground, background)
    return {
      function() return symbols.slant_left_2 end,
      color = {
        fg = foreground,
        bg = background
      },
      separator = "",
      padding = 0
    }
  end

  local diagnostics = {
    "diagnostics",
    sources = { "nvim_diagnostic" },
    sections = { "error", "warn" },
    symbols = { error = " ", warn = " " },
    colored = false,
    update_in_insert = false,
    always_visible = true,
  }

  local diff = {
    "diff",
    colored = false,
    symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
    cond = hide_in_width
  }

  local mode = {
    "mode",
    fmt = function(str)
      return "-- " .. str .. " --"
    end,
  }

  local filetype = {
    "filetype",
    icons_enabled = false,
    icon = nil,
  }

  local branch = {
    "branch",
    icons_enabled = true,
    icon = "",
  }

  local location = {
    "location",
    padding = 0,
  }

  local progress = {
    "progress",
    padding = 1,
  }

  lualine.setup {
    options = {
      icons_enabled = true,
      theme = "auto",
      component_separators = { left = "", right = "" },
      section_separators = { left = symbols.right_filled, right = symbols.left_filled },
      disabled_filetypes = { "dashboard", "neo-tree", "Outline", "alpha" },
      always_divide_middle = true,
      globalstatus = true
    },

    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000
    },
    -- normal = {
    --   a = {
    --     bg = "#7aa2f7",
    --     fg = "#15161e"
    --   },
    --   b = {
    --     bg = "#3b4261",
    --     fg = "#7aa2f7"
    --   },
    --   c = {
    --     bg = "#16161e",
    --     fg = "#a9b1d6"
    --   }
    -- },
    winbar = {
      lualine_a = { "filename" },
      lualine_b = { "filetype" },
      lualine_c = {},
      lualine_x = {
      },
      lualine_y = { diff, "diagnostics" },
      lualine_z = {
        progress,
        {
          'location',

          fmt = function(s)
            return '' .. s
          end,

          padding = 0
        }
      }
    },

    inactive_winbar = {
      lualine_a = {
        {
          "filename",
          fmt = function(s)
            return s .. ' '
          end
        },
      },
      lualine_b = {
        { "filetype", padding = 0 }
      },
      lualine_c = {},
      lualine_x = {
      },
      lualine_y = { diff, { "diagnostics", padding = 0 } },
      lualine_z = {
        {
          "progress",
          fmt = function(s)
            return ' ' .. s
          end,
        },
        {
          'location',
          fmt = function(s)
            return '' .. s
          end,
          padding = 0
        }
      }
    },

    sections = {
      lualine_a = { mode },
      lualine_b = { branch },
      lualine_c = {},
      -- lualine_x = { "encoding", "fileformat", "filetype" },
      lualine_x = {},
      lualine_y = {},
      -- lualine_y = { filetype, "encoding" },
      lualine_z = { "tabs" }, -- progress
      -- lualine_z = { location, }, -- progress
    },

    inactive_sections = {
      lualine_a = { "filename" },
      lualine_b = { "filetype" },
      lualine_c = {},
      lualine_x = { "location" },
      lualine_y = {},
      lualine_z = {},
    },

    -- tabline = {
    -- lualine_a = { "buffers" },
    -- lualine_b = { "branch" },
    -- lualine_c = { "buffers" }
    -- },
    extensions = {},
  }
end

return {
  "nvim-lualine/lualine.nvim",
  -- event = function(_, _)
  --   if UsrLib.check_greeter_skip() then
  --     return { "VimEnter" }
  --   end
  --
  --   return { "BufAdd" }
  -- end,
  lazy = true,
  config = function()
    config()

    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function()
        config()
      end
    })
  end,
  init = function()
    vim.o.laststatus = 0
  end,
}
