local ok, valerr = pcall(require, 'global.valerr') -- Rusty error handling.

local M = {
  database = {},
  awaiting = {},
}
-------------------------------------------------------------------------------

-- Since the ID derivation logic needs to remain cosnistent across all
-- functions, it makes sense to separate it, even if it's just concat.

function M.get_event_id(actor, event)
  if not actor or not event then
    return nil
  end

  -- return valerr.try(function()
  --   return actor .. '>>>' .. event
  -- end)
  --
  return actor .. '>>>' .. event
end

-------------------------------------------------------------------------------

function M.await_event(opts)
  if type(opts) ~= 'table' then return nil end

  if type(opts['actor']) ~= 'string' or type(opts['event']) ~= 'string' then
    if type(opts['actor']) ~= 'string' then
      vim.notify("The 'actor' was not a string, was " .. type(opts['actor']) .. " instead, as received by await_event",
        vim.log.levels.ERROR)
    else
      vim.notify("The 'actor' was okay, is of type '" .. type(opts['actor']) .. "', with value: " .. opts['actor'],
        vim.log.levels.DEBUG
      )
    end

    if type(opts['event']) ~= 'string' then
      vim.notify("The 'event' was not a string, was " .. type(opts['event']) .. " instead, as received by await_event",
        vim.log.levels.ERROR)
    else
      vim.notify("The 'actor' was okay, is of type '" .. type(opts['actor']) .. "', with value: " .. opts['actor'],
        vim.log.levels.DEBUG
      )
    end

    return nil
  end

  local id = M.get_event_id(opts.actor, opts.event)

  if not id then
    vim.notify('Could not derive the event ID from actor and event names!', vim.log.levels.ERROR)
    return nil
  end

  if type(opts['callback']) ~= 'function' then
    vim.notify('You have to define a callback function in your table when using await_event!', vim.log.levels.ERROR)
    return nil
  end

  if not M.database[id] and opts['ignore_unknown'] then
    M.database[id] = { times_fired = 1, data = opts.callback() }
    return nil
  end

  if not M.database[id] then
    M.database[id] = { times_fired = 0, data = {} }
  end

  if type(M.awaiting[id]) ~= 'table' then
    M.awaiting[id] = {}
  end

  table.insert(M.awaiting[id], opts['callback'])
  return id
end

-------------------------------------------------------------------------------

function M.fire_event(opts)
  if type(opts) ~= 'table' then
    vim.notify(
      'No event data supplied, event ignored. The table is of type ' .. type(opts) .. ', when it should be a table.',
      vim.log.level.WARN)
    return nil
  end

  local id = M.get_event_id(opts.actor, opts.event)

  if not id then
    vim.notify('Could not derive the event ID from actor and event names!', vim.log.levels.ERROR)
    return nil
  end

  -- Update Data Pre-Callback Invocations ---------------------------
  if type(M.database[id]) == "table" then
    M.database[id].times_fired = M.database[id].times_fired + 1

    local set_data_t = type(opts['set_data'])

    if set_data_t == 'table' then
      M.database[id].data = opts['set_data']
    elseif set_data_t == 'function' then
      local new_data = opts['set_data'](M.database[id].data)
      if type(new_data) == 'table' then M.database[id] = new_data end
    end
  else
    M.database[id] = { times_fired = 1, data = opts['data'] }
  end

  -- Zero Callbacks, Return Early ---------------------------------
  if type(M.awaiting[id]) ~= 'table' then
    return nil
  end

  local expired = {}

  -- Handle Callbacks --------------------------------------------
  for i, fn in ipairs(M.awaiting[id]) do
    local result = fn(M.database[id]['data'])

    -- Callback Wants Something ------------------------------------
    if type(result) == 'table' then
      -- To Expire -------------------------------------------------
      if result['expire'] then
        table.insert(expired, i)
      end

      -- To Set Data -----------------------------------------------
      if type(result['set_data']) == 'table' then
        M.database[id]['data'] = result
      elseif type(result['set_data']) == 'function' then
        local new_data = result['set_data'](M.database[id]['data'])
        if type(new_data) == 'table' then
          M.database[id]['data'] = new_data
        end
      end
    end
  end

  -- Removes Expired Callbacks -------------------------------------
  for _, index in ipairs(expired) do
    table.remove(M.await_event[id], index)
  end
end

return M
