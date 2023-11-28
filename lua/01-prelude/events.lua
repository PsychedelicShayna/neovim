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
  if type(opts) ~= 'table' then
    return nil
  end

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
    return id
  end

  -- Storing Repetitive Conditional Expressions --
  ------------------------------------------------

  -- Table under this event's ID must be present.
  local event_exists = type(M.database[id]) == 'table' or false
  -----------------------------------------


  local data_exists = (event_exists
    and type(M.database[id]['data']) == 'table')
  ---------------------------------------------
  -- Does the event table have a data table? --
  ---------------------------------------------


  local queue_exists = (type(M.awaiting) == 'table'
    and type(M.awaiting[id]) == 'table')
  --                  ------------------------------------
  --
  local others_awaiting = (queue_exists and #M.awaiting[id] > 0)
  --                        --------------------------------------
  --                        -- Is there at least one calback in --
  --                        -- the awaiting queue?              --
  --                        ------------------------------------


  local data = {}

  if data_exists then
    data = M.database[id]['data']
  end

  -- If true, don't schedule the event, just bypass and invoke the callback
  -- immediatlely when this funciton is called.

  local dont_wait = (
    opts['or_never'] and (
    -- Table has never been defined.
      (not event_exists)

      -- Table has been defined, but times_fired is 0.
      or (type(M.database[id].times_fired) == 'number'
        and M.database[id].times_fired == 0)
    )
  ) or (
    opts['or_previously'] and (
    -- Table is defined, has a times_fired int, and fired at least once.
      (type(M.database[id]) == 'table' and
        type(M.database[id].times_fired) == 'number' and
        M.database[id].times_fired >= 1)
    )
  )

  if dont_wait then
    return opts['callback']()
  end

  if not event_exists then
    M.database[id] = { times_fired = 0, data = {} }
  end

  if type(M.awaiting[id]) ~= 'table' then
    M.awaiting[id] = {}
  end

  table.insert(M.awaiting[id], opts['callback'])
  return id
end

-------------------------------------------------------------------------------
--
-- When a responder attached to an event (callback), is called because an actor
-- fired an event (transmitter), something interesting can happen.
--
-- The event has an ID, which can be used to look-up a table of arbitrary data
-- attached to the event. This table is passed to the callback as an argument,
-- containing previous state.
--
-- The return value of the callback, if a table or function returning a table,
-- will replace the previous table associated with that event ID; an update.
--
-- Why is that interesting? Because when the actor fires the event, it too can
-- update the table by providing a table *or a function*, accepting a table
-- as an argument. The existing table will be passed to it, and just like the
-- callback, it can return a new table used to replace the existing one.
--
-- The key point: the actor's function that receives the previous responders'
-- table, is called BEFORE any responder scheduled for the event being fired
-- at the moment is called.
--
-- In other words, the actor can update the data based on the previous update
-- by a receiver, then update it before it reaches the current receiver, and
-- the receiver can then update it for the future actor to receive, again,
-- updating it and passing it to the future receiver.
--
--                             .                 .
--                        .         .       .        .
--
--                    @     ||__________*__________||     .
--       Transmitter        |-----------------------|        Ping
--  ~~~~~~~~~~~~~~~~~~~~~~~~||  Yes. Pong. Ping.   ||~~~~~~~~~~~~~~~~~~~~~~
--          Pong            ||                     ||       Receiver
--                                 See Below.
--
--
--
-------------------------------  Single Receiver  -----------------------------
--
--
--   |v----------------------<|
--   |> = {} => T = {} => R =^|
--   ---------!---------!------
--            !         !  Present R receives {} assigned by past T
--            !         !   .. R assigns {} for future T
--            !
--            !  Present T receives {}, assigned by past R
--            !   .. assigns {} for future R
--
--
-----------------------------  Multiple Receivers  ----------------------------
--
--     database
--     {
--       [event_id] ={R3} <----{=}      {v} <----{=}
--     }          ^        3rd>|R|  2nd>|R|  1st>|R|
--                ^            {^} <----{=}      {^}<-------{t}
--                ^                                          ^
--                ? > ----------------------- > T > fn({R3}) ^
--
--
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

    local set_data_t = type(opts['data'])

    if set_data_t == 'table' then
      M.database[id].data = opts['data']
    elseif set_data_t == 'function' then
      local new_data = opts['data'](M.database[id].data)
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
    table.remove(M.awaiting[id], index)
  end
end

Events = M

return M
