local M = {
  registered_callbacks = {},
  event_database = {},
}

M.forget = {
  name = 1,
  group = 2
}

function M.has_fired(name, group)
  if M.event_database[name] and M.event_database[name][group] then
    return M.event_database[name][group].fires ~= 0
  end

  return nil
end

function M.add_callback(name, group, callback)
  group = group or "default"

  if not M.registered_callbacks[name] then
    M.registered_callbacks[name] = { [group] = { callback } }
    M.event_database[name] = { [group] = { fires = 0 } }
    return
  end

  if not M.registered_callbacks[name][group] then
    M.registered_callbacks[name][group] = { callback }
    M.event_database[name] = { [group] = { fires = 0 } }
    return
  end

  table.insert(M.registered_callbacks[name][group], callback)
end

-- Run a wired callback after an event has been fired, whether that be before
-- or after the callback has been registered; if the event has already fired,
-- then the callback will be called immediately.
function M.run_after(name, group, callback, call_on_nil)
  local has_fired = M.has_fired(name, group)

  if has_fired or (has_fired == nil and call_on_nil) then
    callback()
  else
    M.add_callback(name, group, callback)
  end

  return has_fired
end

--- Fires a somewhat complex event to the event system.
-- This is the more compliated of the two "fire" functions, as it takes in a
-- table where various kinds of information can be attached to the event. This
-- level of verbosity may not be necessary for simple events, yet, in certain
-- cases, the flexibility can be very much appreciated.
--
-- @param opts
--  A table of options for the event
--
--   @param opts.name
--    The name of the event to fire.
--
--   @param opts.group
--    The event group/family.
--
--   @param opts.forget
--    The forget level of this event, leave it nil unless you actually have a use
--    case for it. A value of 1 will cause any callbacks that have subscribed to
--    the event to be eliminated from the callback store. A value of 2 will result
--    in both the event and the entire event's group to be eliminated from the
--    callback store. That means that any other callbacks subscribed to this event
--    that exist within the same group will also get eliminated.
--
--   @param opts.data
--    An optional table of data to be passed over to the callback function. This
--    can be anything you want. The callback is ultimately in charge of what it
--    does using that data.
--
--  @usage
--    -- Every key, except name, is optional. The rest can be left nil.
--    -- All callbacks waiting for this event will be called, and then
--    -- eliminated, meaning, firing this event again will not trigger
--    -- the same callbacks, as forget has been set to 1.
--
--    local event = require("event")
--
--    event.fire {
--      name = "attached",
--      group = "lsp",
--      forget = 1,
--      data = {
--        server_name = "rust-analyzer",
--        buffer_name = "pumpkin.rs",
--        bufnr = 1979
--      },
--    }

function M.delete_groups(group_name)
  for _, cb_name in ipairs(M.registered_callbacks) do
    for _, cb_group_name in cb_name do
      if cb_group_name == group_name then
        M.registered_callbacks[cb_name][cb_group_name] = nil
      end
    end
  end
end

function M.fire(opts)
  if not opts or type(opts) ~= 'table' then
    return
  end

  local name   = opts.name
  local group  = opts.group or "default"
  local forget = opts.forget or {}
  local data   = opts.data

  if not M.event_database[name] then
    M.event_database[name] = { [group] = { fires = 0 } }
  elseif M.event_database[name] and not M.event_database[name][group] then
    M.event_database[name][group] = { fires = 0 }
  end

  local event_database = M.event_database[name][group]
  event_database.fires = (event_database.fires or 0) + 1

  local callbacks

  if M.registered_callbacks[name] and M.registered_callbacks[name][group] then
    callbacks = M.registered_callbacks[name][group]
  end

  if not callbacks then
    return false
  end

  -- Index of callbacks that will be removed once finished processing the
  -- registered callbacks. Only callbacks that return true will end up here.
  local marked_for_removal = {}

  -- Process all the callbacks; call and mark for removal if applicable.
  for index, callback in ipairs(callbacks) do
    if callback(name, group, data) == true then
      table.insert(marked_for_removal, index)
    end
  end

  -- Removed callbacks that have been marked for removal.
  for _, index in ipairs(marked_for_removal) do
    table.remove(callbacks, index)
  end

  if #forget > 0 then
    for _, selector in ipairs(M.registered_callbacks) do

      local name_selector = selector.name
      local group_selector = selector.group

      if type(group_selector) == 'string' then
      end

      if type(name_selector) == 'string' then
      end
    end
  end

  if forget == 1 then
    M.registered_callbacks[name] = nil
  elseif forget == 2 then
    M.registered_callbacks[name][group] = nil
  end

  return true
end

return M
