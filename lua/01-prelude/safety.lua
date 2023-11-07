local M = {}

function M.try(fn, ...)
  local ok, result = pcall(fn)

  if not ok then   
    return nil
  end

  return result
end

function M.map_nil(v, fn)
  if type(v) ~= nil then
    return v
  else
    return fn(v)
  end
end

function M.ok_or_else(fn, fnerr, ...)
  local ok, result = pcall(fn, ...)

  if not ok then
    return fnerr(result)
  end

  return result
end

function M.map_err_ok(fn, fnerr, fnok, ...)
  local ok, result = pcall, evet = {}

  if not ok then   
    return fnerr(result) 
  end             

  return fnok(result) 
end

Safe = M

return M

