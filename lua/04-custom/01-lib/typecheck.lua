local M = {}


-- For elem in table,
-- if elem is keyless string,
-- string is a typename that is
-- acceptable for origin to have
-- if elem is keyless table, then
-- origin can be a table, but
-- must be checked against contents
-- of table, where any keyless
-- strings in the table are acceptable
-- types for keyless values,
-- and any keys in the table represent
-- an actual key to index into origin
-- with, and the value of the key can
-- be a string, where again, the string
-- contains a typename which type(origin[key])
-- is checked against, or, the value can be
-- another table. If key has a table as value
-- then a keyless table must be present to
-- check the types of the table members,
-- because the outer table is still used
-- to represent acceptable values.
-- --
--

function M.tcheck(data_table, type_table, nested_path)
  local mismatches        = {}

  local ok_keyless_values = {}
  local ok_keyless_tables = {}
  local expecting_keys    = {}

  -- Separate keyless type names, keyless tables, and keyed types.
  for key, value in pairs(type_table) do
    -- Keyless value, key is an index.
    if type(key) == 'number' then
      -- Could be a typename.
      if type(value) == 'string' then
        table.insert(ok_keyless_values, value)

        -- Or a another table.
      elseif type(value) == 'table' then
        table.insert(ok_keyless_tables, value)
      end
    end

    -- Keyed value, a vau is expected.
    if type(key) == 'string' then
      expecting_keys[key] = value
    end
  end


  for key, value in pairs(data_table) do
    -- Keyless value, key is an index.
    if type(key) == 'number' then
      local value_type = type(value)
    end
  end
end

function M.type_check_table(origin, typetable)
  local tl_elems = {}
  local tl_fields = {}

  local ns_elems = {}
  local ns_fields = {}


  local nested = {}

  for k, top_level_type in pairs(typetable) do
    if not k and type(top_level_type) == 'string' then
      table.insert(tl_elems, top_level_type)
    elseif not k and type(top_level_type) == 'table' then
      table.insert(ns_elems, top_level_type)
    elseif k and type(top_level_type) == 'string' then
      tl_fields[k] = top_level_type
    elseif k and type(top_level_type) == 'table' then
      ns_fields[k] = top_level_type
    end
  end

  local tl_elems_mapped = {}
  local tr_elems_mapped = {}
  local ls_elems_mapped = {}

  for k, v in pairs(origin) do
    if not k and type(v) ~= 'table' then
      local found = false

      for _, t in ipairs(tl_elems) do
        if t == type(v) then
          found = true
          break
        end
      end

      table.insert(tl_elems_mapped, found)
    elseif not k and type(v) == 'table' then
      local found = false

      for _, t in ipairs(ns_elems) do
      end
    end
  end


  for k, v in pairs(origin) do
    if k then
      local ok = type(v) == tl_fields[k]
      table.insert(fields_mapped, ok)
    end
  end

  local rec_elems_maped = {}

  for k, v in pairs(origin) do
    if not k then
      local ok = type(v) == tl_fields[k]
      table.insert(fields_mapped, ok)
    end
  end


  local rec_fields_maped = {}

  table.insert(nested, tl_elems_mapped)



  if not k and type(top_level_type) == 'table' and type(origin) == 'table' then
    local nested_ok = {}

    local recurse = M.type_check_table(origin, top_level_type)
  end
end

local res_orig = {}
local res_tree = {}

for field_name, should_be in pairs(typetable) do
  -- If there's a key/field_name, then don't check origin, check a member of
  -- origin with the name field_name, for having the type should_be
  --
  -- if should_be is a table however, recursively call self, providing that
  -- table as the typemap, and indexing into origin[field_name] as the origin
  if field_name then
    if type(should_be) == 'table' then
      table.insert(res_tree, M.type_check_table(origin[field_name], should_be))
    elseif type(should_be) == 'string' then
      table.insert(res_orig, type(origin[field_name]) == should_be)
    end
  else
    -- If there is no key, then should_be is referring to an acceptable value
    -- of origin.
    if type(should_be) == 'table' and type(origin) == 'table' then
      local rec_orig, rec_tree = M.type_check_table(origin, should_be)
      table.insert(res_orig, rec_orig)
      table.insert(res_tree, rec_tree)
    end

    if type(should_be) == 'string' then
      table.insert(res_orig, type(origin) == should_be)
    end
  end

  return res_orig, res_tree
end




function M.type_check_layer(origin, typemap)
  local incorrect = {}
  local ot = type(origin)

  local checks = {}
  local chkbuf = false

  for key, value in pairs(typemap) do
    if not key and type(value) == 'string' and ot == value then
      return true, ot
    elseif not key and type(value) == 'table' then

    elseif key and type(value) == 'string' then
      if type(origin[key]) == value then
        return true
      end



      local vv = origin[key]
      return M.type_check_layer(vv, value)
    end
  end



  return incorrect
end

return M
