local M = {
  events = {},
  event_data = {},
}

function M.has_fired(name, category)
  if M.event_data[name] and M.event_data[name][category] then
    return M.event_data[name][category].fires ~= 0
  end

  return nil
end

function M.new_cb(name, category, callback)
  category = category or "default"

  if not M.events[name] then
    M.events[name] = { [category] = { callback } }
    M.event_data[name] = { [category] = { fires = 0 } }
    return
  end

  if not M.events[name][category] then
    M.events[name][category] = { callback }
    M.event_data[name] = { [category] = { fires = 0 } }
    return
  end

  table.insert(M.events[name][category], callback)
end

function M.new_cb_or_call(name, category, callback)
  if M.has_fired(name, category) then
    callback()
  else
    M.new_cb(name, category, callback)
  end
end

function M.new_cb_ret_unfired(name, category, callback)
  if M.has_fired(name, category) then
    return false
  end

  M.new_cb(name, category, callback)

  return true
end

function M.fire(name, category, forget, data)
  category = category or "default"

  if M.events[name] and M.events[name][category] then
    local event_callbacks = M.events[name][category]
    local event_data = M.event_data[name][category]

    local remove_indices = {}

    for index, callback in ipairs(event_callbacks) do
      if callback(name, category, data) == true then
        table.insert(remove_indices, index)
      end
    end

    for _, index in ipairs(remove_indices) do
      table.remove(event_callbacks, index)
    end

    event_data.fires = event_data.fires + 1

    if forget == 1 then
      M.events[name] = nil
    elseif forget == 2 then
      M.events[name][category] = nil
    end

    return true
  end

  return false
end

return M
