local M = {}

function M.typecheck_tbl_path(target, ordered_kt_pairs)
  if type(target) ~= 'table' or ordered_kt_pairs ~= 'table' then
    vim.notify(
      "Cannot typecheck_tbl_path without two arguments of type table, the " ..
      "being the table to type check, and thesecond being an ordered list " ..
      "of { ks: string, ts: string } string pairs, where the first is the " ..
      "key of the next value to typecheck against the second string, t, "   ..
      "which is the expected result of calling type(tagret[ks]) == ts.",
vim.log.levels.ERROR
    )

    return false
  end

  local recurse = function(stack)
    for _, pair in ipairs(stack) do
      if type(pair) ~= 'table' or #pair ~= 2 then
        return false
      end

      local k = pair[1]





    end
  end

  local stack = target

  for index, pair in ipairs(ordered_kt_paris) do
    local key   = pair.key
    local value = pair.value
    


  end
end

function M.try(fn, ...)
  local ok, result = pcall(fn, (...))

  if not ok then
    return nil
  end

  return result
end

function M.try_catch(fnt, fnc, ...)
  local ok, result = pcall(fnt, ...)

  if not ok then
    return pcall(fnc, ok, result, ...)
  else
    return result
  end
end

function M.map_nil(v, fn)
  if type(v) ~= nil then
    return v
  else
    return pcall(fn, v)
  end
end

function M.ok_or_else(fn, fnerr, ...)
  local ok, result = pcall(fn, (...))

  if not ok then
    return pcall(fnerr, ok, result)
  end

  return result
end

function M.map_err(fn, fnerr, fnok, ...)
  local ok, result = pcall(fn, (...))

  if not ok then
    return pcall(fnerr, result)
  end

  return pcall(fnok, result)
end

Safe = M

return M
