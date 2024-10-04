local M = {}

function M.typecheck_tbl_path(target, ordered_kt_pairs)
  if type(target) ~= 'table' or ordered_kt_pairs ~= 'table' then
    vim.notify(
      "Cannot typecheck_tbl_path without two arguments of type table, the " ..
      "being the table to type check, and thesecond being an ordered list " ..
      "of { ks: string, ts: string } string pairs, where the first is the " ..
      "key of the next value to typecheck against the second string, t, " ..
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

-- Check if the value is in the table
function M.v_in(value, table)
  for _, v in ipairs(table) do
    if v == value then
      return true
    end
  end

  return false
end

function M.t_is(value, types)
  if type(types) ~= 'table' then
    types = { types }
  end

  for _, t in ipairs(types) do
    if type(value) == t then
      return true
    end
  end

  return false
end

M.type_is = M.t_is

function M.t_not(value, types)
  return not M.t_is(value, types)
end

M.type_is = M.type_isnt

function M.try(fn, ...)
  local ok, result = pcall(fn, (...))

  if not ok then
    return nil
  end

  return result
end

--- --------------------------------------------------------------------------
--  Incomplete, just scribbling down an idea I had.
--- --------------------------------------------------------------------------
-- This function is a curried function, taking a table and returning another
-- function that also takes a tbale. It can be used in a couple of ways, but
-- the essence is to validate that values are of a certain type in a more
-- ergonomic way by leveraging Lua's syntax for passing tables as arguments.
--
-- Examples:
--
-- 1 - Positional Checking
--  true := typecheck { 1, 'hello' } { 'number', 'string' }
--  or
--  true := typecheck { 1, 2 } { 'number' , { 'string', 'number' } }
--
--  This simply checks if the types of the values in the first table match the
--  type strings at the same indices in the second table. If the second table
--  has a table rather than a type string, then any of the types in the table
--  can be valid for the value at that index.
--
--  2 - Positional + Tagged Checking
--  true := typecheck { 1, 'two', x = { 'three', 'four' } } { 'number', x = {'number', 'string'} }
--
-- This will still match by indices, but groups of types can be given a key,
-- and values assigned to the same key will be checked against those types.
-- If a value has no key, its index will still be used instead, even if the
-- element at the same index in the second table does have a key.
--
-- This is why three elements in the first, with two in the second, is still
-- valid. As long as any first table values beyond the length of the second
-- table are assigned a key present in the second table, they will be checked
-- against the type or type group assigned to that key in the second table.
--
--- --------------------------------------------------------------------------
--   ^ Incomplete, just scribbling down an idea I had.
--- --------------------------------------------------------------------------

function M.typecheck(value)
  return function(whitelist)
    local valid1 = M.t_is(value, whitelist)

    if not valid1 then
      return false
    end

    return function(blacklist)
      local valid2 = M.t_not(value, blacklist)

      return valid1 or false and valid2 or false
    end
  end
end

M.typecheck { 1 } { 'table' } { 'string', 'number' }

function M.partial(fn, ...)
  local args = { ... }

  return function(...)
    return fn(unpack(args), ...)
  end
end

---@param name string Module name to import.
---@param default any Default value to return if cannot import.
function M.import_or(name, default)
  local ok, module = pcall(require, name)

  if ok then
    return module
  else
    return default
  end
end

---@param name string Module name to import.
---@param or_else function Function to compute the return value if import fails. Both return values of pcall are passed to or_else.
---@return any
function M.import_or_else(name, or_else)
  local ok, module = pcall(require, name)

  if ok then
    return module
  else
    return or_else(ok, module)
  end
end

---@class DbgOpts
---@field trace number|nil  If 1, will print debug information upon import failure.
---@field handle function|nil  Custom function to pass the values returned by pcall to if import fails.
local ImportThenOpts = {}

---@param name string Module name to import.
---@param fn function Function to pass te module to if import is successful.
---@param dbg? DbgOpts Option table with flags to aid with debugging import failures.
---@param ...? any Additional arguments to pass to fn, besides the module.
---@return any, any?, any?
function M.import_then(name, fn, dbg, ...)
  local ok, module = pcall(require, name)

  if not dbg then
    dbg = {
      trace = 1,
      handle = nil
    }
  end

  if ok then
    return fn(module, ...), true
  else
    if dbg then
      local info = debug.getinfo((dbg.trace or 1) + 1, "Sl")

      local src = info.short_src
      local line = info.currentline

      PrintDbg(string.format('%s:%d - Failed to import module "%s", received type "%s" with value..%s',
        src or '?', line or '?', name or '?', type(module),
        module and vim.inspect(module) or '?'

      ), LL_ERROR)
    end

    if type(dbg.handle) == 'function' then
      dbg.handle(module)
    end
  end

  return ok, module, false
end

function M.import_then_or_else(name, fn_ok, fn_err, dbg, ...)
  local rv = M.import_then(name, fn_ok, dbg, ...) or {}
  local ok, module, problem = rv[1], rv[2], rv[3]

  if problem then
    return fn_err(ok, module), problem
  end
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

---@param fn function
---@param errv any
---@
function M.ok_or(fn, errv, ...)
  local ok, result = pcall(fn, (...))

  if not ok then
    return errv
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

function M.is_lib(name)
  local ok, _ = pcall(require, name)
  return ok
end

Safe = M

return M
