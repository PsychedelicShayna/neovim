local highlight_overrides = {
  { name = "Normal",             replace = { ["bg"] = "NONE" }, restore = nil },
  { name = "NormalNC",           replace = { ["bg"] = "NONE" }, restore = nil },
  { name = "SignColumn",         replace = { ["bg"] = "NONE" }, restore = nil },
  { name = "SignColumn",         replace = { ["bg"] = "NONE" }, restore = nil },
  { name = "LineNr",             replace = { ["bg"] = "NONE" }, restore = nil },
  { name = "LineNrAbove",        replace = { ["bg"] = "NONE" }, restore = nil },
  { name = "LineNrAboveBelow",   replace = { ["bg"] = "NONE" }, restore = nil },
  { name = "LineNrAboveBelow",   replace = { ["bg"] = "NONE" }, restore = nil },
  { name = "CursorLineNr",       replace = { ["bg"] = "NONE" }, restore = nil },
  { name = "CursorColumn",       replace = { ["bg"] = "NONE" }, restore = nil },
  { name = "CursorLine",         replace = { ["bg"] = "NONE" }, restore = nil },
  { name = "ColorColumn",        replace = { ["bg"] = "NONE" }, restore = nil },
  { name = "ColorColumn",        replace = { ["bg"] = "NONE" }, restore = nil },
  { name = "TabLine",            replace = { ["bg"] = "NONE" }, restore = nil },
  { name = "TabLineSel",         replace = { ["bg"] = "NONE" }, restore = nil },
  { name = "TabLineSel",         replace = { ["bg"] = "NONE" }, restore = nil },
  { name = "TabLineFill",        replace = { ["bg"] = "NONE" }, restore = nil },
  { name = "WinBar",             replace = { ["bg"] = "NONE" }, restore = nil },
  { name = "WinBarNC",           replace = { ["bg"] = "NONE" }, restore = nil },
  { name = "WinSeparator",       replace = { ["bg"] = "NONE" }, restore = nil },
  { name = "Float",              replace = { ["bg"] = "NONE" }, restore = nil },
  { name = "NormalFloat",        replace = { ["bg"] = "NONE" }, restore = nil },
  { name = "NvimFloat",          replace = { ["bg"] = "NONE" }, restore = nil },
  { name = "FloatBorder",        replace = { ["bg"] = "NONE" }, restore = nil },
  { name = "FloatTitle",         replace = { ["bg"] = "NONE" }, restore = nil },
  { name = "FloatShadow",        replace = { ["bg"] = "NONE" }, restore = nil },
  { name = "FloatShadowThrough", replace = { ["bg"] = "NONE" }, restore = nil },
  { name = "StatusLine",         replace = { ["bg"] = "NONE" }, restore = nil },
  { name = "StatusLineNC",       replace = { ["bg"] = "NONE" }, restore = nil },
}

local persist = false
local disabled_state = false

local function set_disabled_state(new_disabled_state)
  if disabled_state == new_disabled_state then
    return
  end

  highlight_overrides = vim.tbl_map(function(override)
    if not new_disabled_state then
      vim.api.nvim_set_hl(0, override.name, override.restore)
      override.restore = {}
      return override
    else
      local current = vim.api.nvim_get_hl(0, { name = override.name })
      local modified = vim.deepcopy(current)

      for k, v in pairs(override.replace) do
        modified[k] = v
      end

      vim.api.nvim_set_hl(0, override.name, modified)

      override.restore = current
      return override
    end
  end, highlight_overrides)


  disabled_state = new_disabled_state
end

vim.api.nvim_create_autocmd({ "Colorscheme" }, {
  callback = function()
    disabled_state = false

    highlight_overrides = vim.tbl_map(function(override)
      override.restore = nil
      return override
    end, highlight_overrides)

    if persist then
      set_disabled_state(true)
    end
  end
})

vim.api.nvim_create_user_command("DisabledBackgroundReset", function()
  disabled_state = false
end, {})

vim.api.nvim_create_user_command("SetDisableBackgroundTrue", function()
  set_disabled_state(true)
end, {})

vim.api.nvim_create_user_command("SetDisableBackgroundFalse", function()
  set_disabled_state(false)
end, {})

vim.api.nvim_create_user_command("GetDisableBackgroundState", function()
  print(disabled_state)
end, {})

vim.api.nvim_create_user_command("SetDisableBackgroundPersistOn", function()
  persist = true
end, {})

vim.api.nvim_create_user_command("SetDisableBackgroundPersistOff", function()
  persist = false
end, {})
