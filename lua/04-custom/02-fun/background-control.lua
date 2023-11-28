local M = {}

M = {
  -- The (A)uto (C)ommand (ID) of the autocmd responsible for keeping enabled
  -- overrides applied across colorscheme changes. This is set when the first
  -- rule is enabled, and deleted when the last rule is disabled, to prevent
  -- code from being unnecessarily evaluated when no override is enabled.
  --
  --                                (ok fine, I found the name funny, sue me)

  acid_applier = nil,

  -- Stores each highlight name that has been overridden by an override rule as
  -- the key, and stores a table containing the name of the rule that overrode
  -- it in the `overrider` key, a complete copy of the original highlights in
  -- the `original` key, and a copy of the modified values in the `modified`
  -- key. This is primarily used to restore highlights, and keep track of what
  -- was overridden, by who, and with what.

  overridden = {},

  -- A table of tables, each containing a list of highlights, keys, and what
  -- value to overwrite them with. An entry in the list of highlights can be a
  -- string, or another table, in which case, the table must specify a `name`
  -- to refer to the highlight. Unlike a string, a table can specify its own
  -- `override` key, wich will be used in place of the global override key,
  -- where more specific overrides are needed, rather than a blanket override.
  -- An `aliases` key can also be provided for shorter invocations. They will
  -- also show up during tab completion.

  overrides = {
    foo = {
      enabled = false,
      alias = {},
      replace = {},
      targets = {},
    },

    -- rulename = {            ----EXAMPLE--------DEFINE-LOWER-DOWN------------
    --      enabled = true,
    --      values = { guibg = "None", ctermbg = "None" },
    --      aliases = { "ruln", "rnam" },
    --      highlights = {
    --          "Normal",
    --          "NormalNC",
    --          "NormalFloat",
    --          { "Normal",
    --            { ctermbg = "#2CB46C" , ctermfg = "#69FE3F" }
    --          }
    --      },
    -- }
  },
}

M.overrides = {
  disable_backgrounds = {
    enabled = false,
    aliases = { "nobg" },
    override = { guibg = "None", ctermbg = "None" },
    highlights = {
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
  },
}

function M.enable_override(override_name)
  local override = M.overrides[override_name]

  if type(override) ~= "table" then
    local message = string.format(
      'The override "%s" does not exist, or has the wrong type (expect table, got "%s")',
      override_name,
      type(override)
    )

    vim.notify(message)
    return
  end

  if override.enabled then
    vim.notify('The rule "' .. override_name .. '" is already enabled.')
    return
  end

  local default_replace = M.compose_replace_string(override.replace)

  for _, target in ipairs(override.targets) do
    local conflicts_with = nil
    local command = nil
    local hl_name = nil

    if type(target) == "table" then
      if type(target[1]) == "string" then
        hl_name = target[1]
      else
        local message = string.format(
          'The override "%s" targets an invalidly named highlight (expected string, got "%s").',
          override_name,
          type(target[1])
        )

        PrintDbg(message, LL_WARN, { override, target })
      end

      if hl_name and M.overridden[hl_name] then
        conflicts_with = M.overridden[hl_name]
      elseif hl_name then
        local replacement = {}

        for k, v in pairs(target[2]) do
          table.insert(replacement, string.format("%s=%s", k, v))
        end

        command = string.format("highlight %s %s", hl_name, table.concat(replacement, " "))
      end
    elseif type(target) == "string" then
      hl_name = target

      if M.overridden[hl_name] then
        conflicts_with = M.overridden[hl_name]
      else
        if type(default_replace) == "string" then
          command = string.format("highlight %s %s", hl_name, default_replace)
        end
      end
    end

    if type(conflicts_with) then
      local message =
      'Conflicting override rules! Override "%s" wants to override highlight "%s", but "%s" already overrode it first!'

      PrintDbg(
        string.format(message, override_name, vim.inspect(hl_name), vim.inspect(conflicts_with)),
        LL_WARN,
        { hl_name, override, conflicts_with }
      )
    elseif command then
      local original_values = vim.api.nvim_get_hl(0, { name = hl_name })

      if original_values and hl_name then
        M.overridden[hl_name] = {
          overrider = override_name,
          overrode = original_values,
        }

        override.enabled = true
        vim.cmd(command)
      else
        local message =
        'Failed to override highlight "%s" as part of override "%s" because the original values could not be retrieved! You dun goofed.'

        PrintDbg(string.format(message, hl_name, override_name), LL_ERROR, { override, hl_name, original_values })
      end
    elseif type(command) ~= "string" then
      local message =
      'A command to set override the highlight "%s" as part of override "%s" could not be generated (unexpected type "%s", expecting string). You dun goofed.'

      PrintDbg(string.format(message, hl_name, override_name, type(command)), LL_ERROR, { override, command })
    end
  end
end

function M.disable_override(override_name)
  local override = M.overrides[overrides_name]

  if not override then
    vim.notify('The override "' .. override_name .. '" does not exist.')
    return
  end

  if not override.enabled then
    vim.notify('The override "' .. override_name .. '" is already disabled.')
    return
  end

  local affected_hls = {}

  for _, entry in ipairs(override) do
    if type(entry) == "table" and type(entry[1]) == "string" and type(entry[2]) == "table" then
      table.insert(affected_hls, entry[1])
    elseif type(entry) == "string" then
      table.insert(affected_hls, entry)
    end
  end

  for _, hl in ipairs(affected_hls) do
    local overridden = M.overridden[hl]

    if overridden and overridden.overrider == override_name then
      im.api.nvim_set_hl(0, hl, M.overridden.original)
    elseif overridden then
      local message =
      'While disabling override "%s", found that the highlight "%s" was overridden by a different overrider "%s" - you dun goofed.'

      PrintDbg(
        string.format(message, override_name, hl, overridden.overrider),
        LL_ERROR,
        { override_name, override, overridden }
      )
    else
      local message =
      'While disabling override "%s", found that the highlight "%s" has suposedly not even been overridden - you dun goofed.'

      PrintDbg(string.format(message, override_name, hl), LL_ERROR, { override_name, override, overridden })
    end
  end
end

function M.disable_rule(rule_name)
  if not M.overrides[rule_name] then
    vim.notify('The rule "' .. rule_name .. '" does not exist.')
    return
  end

  if not M.overrides[rule_name].enabled then
    vim.notify('The rule "' .. rule_name .. '" is already disabled.')
    return
  end

  M.set_rule_enabled({ name = rule_name, enabled = false })
end

function M.apply_rule(rule_name)
  if not M.overrides[rule_name] then
    vim.notify('The rule "' .. rule_name .. '" does not exist.')
    return
  end

  if M.overrides[rule_name].enabled then
    vim.notify('The rule "' .. rule_name .. '" is already enabled.')
    return
  end

  M.set_rule_enabled({ name = rule_name, enabled = true })
end

function M.reset_rule(rule_name)
  if not M.overrides[rule_name] then
    vim.notify('The rule "' .. rule_name .. '" does not exist.')
    return
  end

  if not M.overrides[rule_name].enabled then
    vim.notify('The rule "' .. rule_name .. '" is already disabled.')
    return
  end

  M.set_rule_enabled({ name = rule_name, enabled = false })
end

function M.compose_replace_string(replacement)
  local kv_pairs = {}

  for k, v in pairs(replacement) do
    table.insert(kv_pairs, string.format("%s=%s", k, v))
  end

  return table.concat(kv_pairs, " ")
end

-- function M.set_rule_enabled(opts)
--   local rl_name = opts.name
--   local enable = opts.enabled
--
--   local rule = M.overrides[rl_name]
--
--   if not rule then
--     vim.notify('The rule "' .. rl_name .. '" does not exist.')
--     return
--   end
--
--   if rule.enabled == enable then
--     local already_what = enable and "enabled" or "disabled"
--     vim.notify('The rule "' .. rl_name .. '" is already ' .. already_what .. ".")
--     return
--   end
--
--   local any_changed = false
--
--   if type(rule.for_highlights) ~= "table" then
--     local message = string.format("The rule '%s' has an invalid 'for_highlights' key; expected table, got '%s'.")
--
--     PrintDbg(message, LL_ERROR, { rule.for_highlights })
--     return
--   end
--
--   if enable then
--     for _, hl_name in ipairs(rule.for_highlights) do
--       if M.changed[hl_name] then
--         local conflicting_rule = M.changed[hl_name].by or "UNKNOWN"
--
--         local message = string.format(
--           'Ignoring conflicting override; rule "%s" overrides "%s" but "%s" already overrode it.',
--           rl_name,
--           hl_name,
--           conflicting_rule
--         )
--
--         PrintDbg(message, LL_WARN)
--       else
--         local original = vim.api.nvim_get_hl(0, { name = hl_name })
--         local command = string.format(
--           "highlight %s %s=%s",
--           hl_name,
--           table.concat(rule.set_keys, "=" .. rule.to_value .. " "),
--           rule.to_value
--         )
--
--         vim.cmd(command)
--
--         local modified = vim.api.nvim_get_hl(0, { name = hl_name })
--
--         M.changed[hl_name] = {
--           by = rl_name,
--           from = original,
--           to = modified,
--         }
--
--         any_changed = true
--       end
--     end
--
--     if any_changed then
--       M.overrides[rl_name].enabled = true
--     end
--   else
--     local restored = 0
--     local total = #rule.for_highlights
--
--     for _, hl_name in ipairs(rule.for_highlights) do
--       local changed_entry = M.changed[hl_name]
--
--       if type(changed_entry) ~= "table" or type(changed_entry.from) ~= "table" then
--         local message = string.format(
--           'Failed to restore highlight "%s" when disabling rule "%s"; expected table from `M.changed[hl_name].from`, but value had type "%s" instead.',
--           hl_name,
--           rl_name,
--           type(changed_entry and changed_entry.from)
--         )
--
--         PrintDbg(message, LL_ERROR, { M.changed })
--       else
--         vim.api.nvim_set_hl(0, hl_name, M.changed[hl_name].from)
--         restored = restored + 1
--         M.changed[hl_name] = nil
--       end
--     end
--
--     local prefix = restored == total and "[OK]" or "[PROBLEMS]"
--
--     vim.notify(string.format('%s Restored %d/%d highlights overridden by "%s"', prefix, restored, total, rl_name))
--
--     rule.enabled = false
--   end
-- end
--
-- function M.restore_highlights()
--   for rule_name, rule in pairs(M.overrides) do
--     if rule.enabled then
--       vim.notify('Disabling rule "' .. rule_name .. '"')
--       M.set_rule_enabled({ name = rule_name, enabled = false })
--     end
--   end
--
--   if #M.changed == 0 then
--     vim.notify("Done. Nothing left to restore.")
--     return
--   end
--
--   vim.notify("Checking for orphan overrides..")
--
--   for hl_name, changed_entry in pairs(M.changed) do
--     if type(changed_entry.from) ~= "table" then
--       local message = string.format(
--         'Failed to restore orphan "%s" because the backup table ws invalid (was "%s", expected table)',
--         hl_name,
--         type(changed_entry.from)
--       )
--
--       PrintDbg(message, LL_ERROR, { changed_entry })
--     end
--
--     vim.api.nvim_set_hl(0, hl_name, changed_entry.from)
--     M.changed[hl_name] = nil
--
--     local message =
--         string.format('Restored orphan "%s" belonging to rule "%s".', hl_name, changed_entry.by or "UNKNOWN")
--
--     PrintDbg(message, LL_WARN)
--   end
--
--   vim.notify('Done.')
-- end
--
-- function M.cmd_set_rule_sate(opts)
--   local rule_name = opts.rule
--   local desired_state = opts.state
--
--   if not M.overrides[rule_name] then
--     vim.notify('The override rule "' .. rule_name .. '" does not exist.')
--     return
--   end
--
--
--
--   M.set_rule_enabled({ name = rule_name, enabled = desired_state })
-- end
--
function M.set_sync_state(state, rule_names)
  if not type(state) == "boolean" and not type(state) == "nil" then
    local message = 'To avoid truthy value confusion, state must be a boolean or nil, not "%s"'
    PrintDbg(string.format(message, type(state)), LL_ERROR, { state })
    return
  end

  local state_str = state and "enabled" or "disabled"
  state = state and true or nil -- Collapse state from truthy/falsey into true/nil

  --  Tracks the amount of changes made to M.synced_rules, to compare against
  --  the total number of rules later on, or against the total number of rules
  --  requested be changed by rule_names (that maybe weren't) to spot issues.
  local change_count = 0

  -- If specific override rule names were specified with `rule_names`, only
  -- target those rules, and ignore the rest.
  if type(rule_names) == "table" then
    for rule_name in ipairs(rule_names) do
      -- Ignore non-existent rules.
      if not M.overrides[rule_name] then
        vim.notify('The rule "' .. rule_name .. '" does not exist. Ignoring.')

        -- Ignore if the rule is already in the desired state.
      elseif M.overrides[rule_name] == state then
        local message = string.format('The rule "%s" already has sync %s', rule_name, state_str)
        vim.notify(message)

        -- If everything checks out, set the new enabled/disabled state for rule.
      else
        M.synced_rules[rule_name] = state
        change_count = change_count + 1
      end
    end

    -- Since rule_names was not specified (or isn't a table), target all rules.
  else
    -- Iterate over every rule.
    for rule_name, _ in pairs(M.overrides) do
      -- Check if the rule is slready in the desired state, and skip it true.
      if M.overrides[rule_name] ~= state then
        M.synced_rules[rule_name] = state
        change_count = change_count + 1
      end
    end

    local message = string.format(
      "Sync %s for %d/%d rules, the rest were already %s",
      state_str,
      change_count,
      #M.overrides,
      state_str
    )

    vim.notify(message)
  end

  -- If sync is disabled for all rules, delete the autocmd; prevents needless
  -- code that isn't needed from being evaluated, and saves a bit of memory.
  if #M.synced_rules == 0 and type(M.sync_autocmd_id) == "number" then
    vim.api.nvim_del_autocmd(M.sync_autocmd_id)
    M.sync_autocmd_id = nil
  end

  -- If the autocmd is not yet created, and there are rules to sync, create it.
  if #M.synced_rules > 0 and type(M.sync_autocmd_id) ~= "number" then
    M.sync_autocmd_id = vim.api.nvim_create_autocmd({ "ColorScheme" }, {
      callback = function()
        for rule_name, _ in pairs(M.synced_rules) do
          local rule = M.overrides[rule_name]

          if not rule then
            local message = string.format(
              'The rule "%s" does not exist, but was requested to be synced. Ignoring.',
              rule_name
            )

            PrintDbg(message, LL_WARN, { rule_name })
          else
            M.set_rule_enabled({ name = rule_name, enabled = state })
          end
        end
      end,
    })
  end

  if type(M.sync_autocmd_id) ~= "number" and type(sync_autocmd_id) ~= "nil" then
    M.sync_autocmd_id = nil

    local message = string.format(
      'Clearing sync_autocmd_id; should only be a number or nil, but was "%s" - this could lead to problems.',
      type(M.sync_autocmd_id)
    )

    PrintDbg(message, LL_ERROR, { M.sync_autocmd_id })
    vim.notify(message)
  end
end

vim.api.nvim_create_user_command("Hiride", function(opts)
  local args = opts.fargs

  local recognized = { "enable", "disable", "reset", "sync", "nosync", "rules" }

  if #args < 1 or type(args) ~= "table" or type(args[1]) ~= "string" or not vim.tbl_contains(recognized, args[1]) then
    vim.notify(
      'Bad invocation, require argument "action", of which '
      .. table.concat(recognized, ", ")
      .. " are recognized."
    )

    return
  end

  local action = args[1]

  if action == "enable" or action == "disable" then
    if #args < 2 then
      vim.notify("Missing rule name. Specify the rule to enable/disable as the second argument.")
      return
    end

    local desired_state = (action == "enable") or (action == "disable" or nil)
    local rule_name = args[2]

    if not M.overrides[rule_name] then
      vim.notify('The rule "' .. rule_name .. '" does not exist.')
      return
    end

    M.set_rule_enabled({ rule = rule_name, state = desired_state })
    return
  end

  if action == "restore" then
    M.restore_highlights()
    return
  end

  if action == "sync" then
    if #args < 2 then
      vim.notify('Missing argument: STATE (on/off), call with "sync on" or "sync off"')
      return
    end

    local rules = nil

    if #args >= 3 then
      rules = vim.list_slice(args, 3, #args)
    end
  end
end, {
  nargs = "*",
  complete = function(lead, cmdline, pos) end,
})

function M.set_bg_enabled(enable)
  -- If the background is already enabled, or disabled, short circuit.
  if bg_currently_enabled == enable then
    return
  end

  if enable then
    highlight_overrides = vim.tbl_map(function(highlight)
      if highlight.backup == nil then
        return highlight
      end

      vim.api.nvim_set_hl(0, highlight.name, highlight.backup)
      highlight.backup = nil
      return highlight
    end, highlight_overrides)
  else
  end

  highlight_overrides = vim.tbl_map(function(override)
    if enable then
      if override.restore == nil then
        return override
      end

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

  bg_currently_enabled = enable
end

-- vim.api.nvim_create_autocmd({ "Colorscheme" }, {
--   callback = function()
--     bg_currently_enabled = false
--
--     highlight_overrides = vim.tbl_map(function(override)
--       override.restore = nil
--       return override
--     end, highlight_overrides)
--
--     if persist then
--       set_bg_enabled(true)
--     end
--   end,
-- })

-- vim.api.nvim_create_user_command("BgReset", function()
--   bg_currently_enabled = false
-- end, {})
--
-- vim.api.nvim_create_user_command("BgDisable", function()
--   set_bg_enabled(true)
-- end, {})
--
-- vim.api.nvim_create_user_command("BgEnable", function()
--   set_bg_enabled(false)
-- end, {})
--
-- vim.api.nvim_create_user_command("BgState", function()
--   vim.notify("Background Disabled: " .. vim.inspect(bg_currently_enabled))
-- end, {})
--
-- vim.api.nvim_create_user_command("BgEnablePersist", function()
--   persist = true
-- end, {})
--
-- vim.api.nvim_create_user_command("BgDisablePersist", function()
--   persist = false
-- end, {})
-- vim.api.nvim_create_user_command("BgDisablePersist", function()
--   persist = false
-- end, {})
-- end, {})
-- end, {})
-- end, {})
-- end, {})
-- end, {})
-- end, {})
-- end, {})
