-- "   כּ ךּ    落   ﯽ  ﱴ"

local function config(_)
  local lualine = require "lualine"

  local hide_in_width = function()
    return vim.fn.winwidth(0) > 80
  end

  local spaces = function()
    return "spaces: " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
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

  lualine.setup {
    options = {
      icons_enabled = true,
      theme = "auto",
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
      disabled_filetypes = { "dashboard", "neo-tree", "Outline", "alpha" },
      always_divide_middle = true,
    },

    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000
    },

    sections = {
      lualine_a = { branch, diagnostics },
      lualine_b = { mode },
      lualine_c = { "filename" },
      -- lualine_x = { "encoding", "fileformat", "filetype" },
      lualine_x = { diff },
      lualine_y = { filetype, spaces, "encoding" },
      -- lualine_y = { filetype, "encoding" },
      lualine_z = { location, "progress", }, -- progress
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

    tabline = nil,
    -- tabline = {
    --   -- lualine_a = { "buffers" },
    --   -- lualine_b = { "branch" },
    --   -- lualine_c = { "buffers" }
    -- },
    extensions = {},
  }
end

return {
  "nvim-lualine/lualine.nvim",
  event = function(_, _)
    if require("utils.check_greeter_skip")() then
      return { "VimEnter" }
    end

    return { "BufAdd" }
  end,
  config = function(_)
    vim.defer_fn(config, 200)
  end,
  init = function()
    vim.o.laststatus = 0
  end,
}
