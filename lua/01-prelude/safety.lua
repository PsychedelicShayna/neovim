Safe = {}


-- A more ergonomic way to typecheck multtiple values or possible valid types.
-- The first argument can be a table of multiple values, or a single value.
--
-- true := typecheck('s', { 'number', 'string' })
-- true := typecheck({ 1, 's' }, { 'number', 'string' })
-- true := typecheck({ 1, 's' }, { 'number', { 'string', 'number' } })
--
---@param values any Any value or table of values to typecheck against.
---@param types table A table of type names (or sub-tables of type names) representing the valid types for values at the corresponding indices.
---@param report boolean? -- If true, return a detailed table of mismatches instead of false on a failed check.
---@return boolean|table -- True if all types ok. Otherwise, either false, or a table with mismatches if report argument was given.
function Safe.typecheck(values, types, report)
    if type(values) ~= 'table' then
        values = { values }
    end

    local mismatches = {}

    for index, value in ipairs(values) do
        ---@type string|table
        local valid_types = types[index]
        local value_type_ok = false

        if type(valid_types) == 'table' then
            for _, valid_type in ipairs(valid_types) do
                if type(value) == valid_type then
                    value_type_ok = true
                    break
                end
            end
        elseif type(valid_types) == 'string' then
            value_type_ok = type(value) == valid_types
        end

        if not value_type_ok and not report then
            return false
        elseif not value_type_ok then
            table.insert(mismatches, {
                index    = index,
                value    = value,
                type     = type(value),
                expected = valid_types
            })
        end
    end

    if not report then
        return #mismatches == 0
    else
        return mismatches
    end
end


-- Check if the value is in the table
function Safe.v_in(value, table)
    for _, v in ipairs(table) do
        if v == value then
            return true
        end
    end

    return false
end

function Safe.t_is(value, types)
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

Safe.type_is = Safe.t_is

function Safe.t_not(value, types)
    return not Safe.t_is(value, types)
end

Safe.type_is = Safe.type_isnt

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

-- function Safe.typecheck(value)
--     return function(whitelist)
--         local valid1 = Safe.t_is(value, whitelist)
--
--         if not valid1 then
--             return false
--         end
--
--         return function(blacklist)
--             local valid2 = Safe.t_not(value, blacklist)
--
--             return valid1 or false and valid2 or false
--         end
--     end
-- end

-- Partial function application.
--- @param fn function The function to partially apply.
--- @param ... any The values to partially apply it with.
function Safe.partial(fn, ...)
    local args = { ... }

    return function(...)
        return fn(unpack(args), ...)
    end
end

----- Safely importing modules ------------------------------------------------

---@param name string Module name to import.
---@param default any Default return value when import unsuccessful.
---@return any -- The module if successful, the default value if unsuccessful.
function Safe.import_or(name, default)
    local ok, module = pcall(require, name)

    if ok then
        return module
    end

    return default
end

---@param name string Module name to import.
---@param fn_err function Function called with fn_err(<pcall_return_values{1}, {2}>, ...) on unsuccessful import.
---@return any -- Module if successful, return value of fn_err(<pcall_return_values{1}, {2}>, ...) if unsuccessful.
function Safe.import_or_else(name, fn_err, ...)
    local ok, module = pcall(require, name)

    if ok then
        return module
    else
        return fn_err(ok, module, ...)
    end
end

---@param name string Module name to import.
---@param fn function Function to pass te module to if import is successful.
---@param ...? any Additional arguments to pass to fn, besides the module.
---@return any -- Return value of fn(mod, ...) on successful import, nil otherwise.
function Safe.import_then(name, fn, ...)
    local ok, mod = pcall(require, name)
    if ok then return fn(mod, ...) end
    return nil
end

---@param name string Module name to import.
---@param fn function Function called with fn(module, ...) on successful import.
---@param default any Default return value when import unsuccessful.
---@param ...? any Additional arguments to pass to fn, besides the module.
---@return any -- Return value of fn(mod, ...) on successful import, default otherwise.
function Safe.import_then_or(name, fn, default, ...)
    local ok, mod = pcall(require, name)
    if not ok then return default end
    return fn(mod, ...)
end

---@param name string Module name to import.
---@param fn_ok function Function called with fn_ok(module, ...) on successful import.
---@param fn_err function Function called with fn_err(<pcall_return_values{1}, {2}>, ...) on unsuccessful import.
---@param ...? any Additional arguments to pass to fn_ok or fn_err.
---@return any -- Return value of fn(mod, ...) on successful import, default otherwise.
function Safe.import_then_or_else(name, fn_ok, fn_err, ...)
    local ok, mod = pcall(require, name)
    if not ok then return fn_err(ok, mod, ...) end
    return fn_ok(mod, ...)
end

-------------------------------------------------------------------------------


---- Simple try/catch system --------------------------------------------------
---@param fn_try_block function Function to attempt calling with args (...)
---@param fn_catch_block? function If provided, function called on error with args (<pcall_return_values{1}, {2}>, ...)
---@param ...? any Additional parameters that get passed to either try/catch function.
---@return any -- Return value of fn_try_block(...) or fn_catch_block(<pcall_return_values{1}, {2}>, ...) if provided, nil otherwise.
function Safe.try(fn_try_block, fn_catch_block, ...)
    local ok, result = pcall(fn_try_block, ...)

    if ok then return result end

    if fn_catch_block then
        return fn_catch_block(ok, result, ...)
    end

    return nil
end

-------------------------------------------------------------------------------

return Safe
