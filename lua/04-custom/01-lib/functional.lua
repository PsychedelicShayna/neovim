local M = {}

function M.tbl_all(table)
  if type(table) ~= 'table' then
    return false
  end

  for _, e in ipairs(table) do
    if not e then
      return false
    end
  end

  return true
end

function M.tbl_any(table)
  if type(table) ~= 'table' then
    return false
  end

  for _, e in ipairs(table) do
    if e then
      return true
    end
  end

  return false
end

return M
