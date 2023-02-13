local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
  return
end
local hide_in_width = function()
  return vim.fn.winwidth(0) > 80
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

  -- "   כּ ךּ    落   ﯽ  ﱴ"
  -- symbols = { added = " 落", modified = "  ", removed = "  " }, -- changes diff symbols

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

-- cool function for progress
local progress = function()
  local current_line = vim.fn.line(".")
  local total_lines = vim.fn.line("$")

  local chars_original = { "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" }
  local chars = { "██", "▇▇", "▆▆", "▅▅", "▄▄", "▃▃", "▂▂", "▁▁" }

  local line_ratio = current_line / total_lines
  local index = math.ceil(line_ratio * #chars)
  return chars[index]
end

local spaces = function()
  return "spaces: " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

lualine.setup({
  options = {
    icons_enabled = true,
    theme = "auto",
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    disabled_filetypes = { "dashboard", "NvimTree", "Outline", "alpha" },
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
})
