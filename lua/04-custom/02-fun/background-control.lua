---@class BackgroundStripper
---@field enabled boolean Whether the background is currently enabled or not, true by default.
---@field persist boolean Whether or not a change in colorscheme should re-apply the changes.
---@field hibackup table A copy of the stripped background colors in order to re-enable them.
---@field hitargets table The highlight groups that will have their backgrounds stripped.
local BackgroundStripper = {
  enabled = true,
  persist = false,
  hibackup = {},
  hitargets = {
    "ColorColumn",
    "CursorColumn",
    "CursorLine",
    "CursorLineNr",
    "Float",
    "FloatBorder",
    "FloatShadow",
    "FloatShadowThrough",
    "FloatTitle",
    "LineNr",
    "LineNrAbove",
    "LineNrAboveBelow",
    "Normal",
    "NormalFloat",
    "NormalNC",
    "NvimFloat",
    "SignColumn",
    "StatusLine",
    "StatusLineNC",
    "TabLine",
    "TabLineFill",
    "TabLineSel",
    "WinBar",
    "WinBarNC",
    "WinSeparator",
  },
}

---@param newstate boolean Set the state of the background, true=enabled, false=disabled.
---@return boolean: Whether the state was changed.
function BackgroundStripper:set_state(newstate)
  -- No point in changing the state if it's identical to the old state.
  if self.enabled == newstate then return false end

  if newstate == true then -- Enable the background.
    if type(self.hibackup) ~= "table" then
      PrintDbg("Cannot restore highlights, because no backup exists!", LL_ERROR)
      return false
    end

    for _, higroup in ipairs(self.hibackup) do
      Safe.try_catch(function()
        vim.api.nvim_set_hl(0, higroup.name, higroup.values)
      end, function(e)
        PrintDbg("Cannot restore highlight group! Err: %s", LL_ERROR, { higroup }, e)
      end)
    end
  else -- Disable the background.
    self.hibackup = {}

    if type(self.hitargets) ~= "table" then
      PrintDbg("Cannot disable background, because no targets are defined!", LL_ERROR)
      return false
    end

    for _, higroup in ipairs(self.hitargets) do
      local original = vim.api.nvim_get_hl(0, { name = higroup })
      local modified = vim.deepcopy(original)

      -- Strip the background from the highlight group.
      modified.bg = "None"

      -- Apply the new values.
      vim.api.nvim_set_hl(0, higroup, modified)

      -- Store the original values for later restoration.
      table.insert(self.hibackup, { name = higroup, values = original })
      Safe.try_catch(function()
      end, function(e)
        PrintDbg("Cannot override highlight group! Err: %s", LL_ERROR, { higroup }, e)
      end)
    end
  end

  self.enabled = newstate
  return true
end

--- Resets the internal state to assume the background is enabled,
--- and clears the backup. Doesn't change the actual background state.
--- Called when the colorscheme changes.
function BackgroundStripper:reset()
  self.enabled = true
  self.hibackup = {}
end

vim.api.nvim_create_autocmd({ "Colorscheme" }, {
  callback = function()
    local redisable = BackgroundStripper.persist and not BackgroundStripper.enabled
    BackgroundStripper:reset()

    if redisable then
      BackgroundStripper:set_state(false)
    end
  end,
})

vim.api.nvim_create_user_command("BgsReset", function()
  BackgroundStripper:reset()
end, {})

vim.api.nvim_create_user_command("BgsDisable", function()
  BackgroundStripper:set_state(false)
end, {})

vim.api.nvim_create_user_command("BgsEnable", function()
  BackgroundStripper:set_state(true)
end, {})

vim.api.nvim_create_user_command("BgsState", function()
  local text = BackgroundStripper.enabled and "enabled" or "disabled"
  vim.notify("Background is: " .. text)
end, {})

vim.api.nvim_create_user_command("BgsPersist", function()
  BackgroundStripper.persist = true
end, {})

vim.api.nvim_create_user_command("BgsDontPersist", function()
  BackgroundStripper.persist = false
end, {})

return BackgroundStripper
