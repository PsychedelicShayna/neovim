-- We want to cache the results of checking scheme backgrounds, because doing
-- so takes a moment to cycle through every scheme and extract the background
-- highlight. That means when schemes are added or removed, we need to update
-- the cache. We can handle this by creating an autocommand that runs when a
-- colorscheme is loaded that isn't in the cache, and passively update it as
-- new schemes are added and the user loads them. However if the user removes
-- a scheme, we can't really detect that, so the user will have to manually
-- invoke a function that checks the cache and removes any schemes that aren't
-- installed anymore. This is a bit of a pain, but it's better than nothing.

local M = {
  cache = {
    dir = nil,
    file = nil,

    schemes = {
      dark = {},
      light = {},
      other = {}
    }
  }
}

vim.defer_fn(function()
  local _, _ = pcall(M.load_cache_file, M.cache.file)
end, 1500)

M.cache.dir  = vim.fn.stdpath('data') .. '/custom/flashbang/'
M.cache.file = M.cache.dir .. 'flashbang.cache'

-- Returns a list of currently loaded colorschemes.
function M.get_all_schemes()
  return vim.fn.getcompletion('', 'color')
end

-- This will go through every installed colorscheme, mark it as dark or light
-- and cache the result so we don't have to do this again. It will also find
-- any schemes that are no longer installed and remove them from the cache.
-- While the most thorough, and should be run initially, or occasionally,
-- the autocommand will keep the cache up to date for the most part.
function M.update_scheme_cache()
  local initial_scheme       = vim.g.colors_name
  local dark_schemes         = {}
  local light_schemes        = {}
  local other_schemes        = {}

  local _update_scheme_cache = function()
    local all_schemes = M.get_all_schemes()

    for _, scheme in ipairs(all_schemes) do
      local ok, result = pcall(M.test_scheme, scheme)

      if ok then
        if result == 0 then
          table.insert(dark_schemes, scheme)
        elseif result == 1 then
          table.insert(light_schemes, scheme)
        else
          table.insert(other_schemes, scheme)
        end
      end
    end
  end

  vim.cmd('colorscheme ' .. initial_scheme)
  local ok, e = pcall(_update_scheme_cache)

  if ok then
    M.cache.schemes.dark  = dark_schemes
    M.cache.schemes.light = light_schemes
    M.cache.schemes.other = other_schemes
    M.write_cache_file(M.cache.file)
    return
  end

  PrintDbg("Error updating scheme cache", LL_ERROR, { ok, e, dark_schemes, light_schemes, other_schemes })
end

-- Returns a table of colorscheme names that are dark.
function M.get_dark_schemes()
  return M.cache.schemes.dark
end

-- Returns a table of colorscheme names that are light.
function M.get_light_schemes()
  return M.cache.schemes.light
end

-- Returns a table of colorscheme names that are neither dark nor light.
function M.get_other_schemes()
  return M.cache
end

function M.test_current_scheme()
  local normal = vim.api.nvim_get_hl(0, { name = 'Normal' })
  if Safe.t_not(normal, 'table') then return nil end

  local bg = normal.bg
  if Safe.t_is(bg, 'nil') then return -1 end
  if Safe.t_not(bg, 'number') then return nil end

  local hex = string.format("%x", bg)
  if #hex < 6 then return nil end

  local r, g, b

  r = tonumber(hex:sub(1, 2), 16)
  g = tonumber(hex:sub(3, 4), 16)
  b = tonumber(hex:sub(5, 6), 16)

  if r > 0x80 or g > 0x80 or b > 0x80 then
    return 1
  else
    return 0
  end
end

-- Applies the colorscheme, and returns what kind of colorscheme it is.
-- Return value can be 0 for dark, 1 for light, -1 for other, and nil if
-- if an error occurred. The optional "revert" argument can be set to a
-- truthy value (non-nil) to restore the current scheme after testing.
function M.test_scheme(colorscheme)
  io.read()

  local _test_scheme = function()
    vim.cmd('colorscheme ' .. colorscheme)
    return M.test_current_scheme()
  end

  local ok, result = pcall(_test_scheme)

  -- if revert then
  --   vim.cmd('colorscheme ' .. initial_scheme)
  -- end
  --
  if not ok then return nil end
  return result
end

-- Clears M's cache and loads the cache data located at filepath into M
-- Clearing occurs once the data has been safely loaded to avoid corruption.
-- Cache file is expected to follow a semicolon separated value format, where
-- each line should be a "`dark_scheme;light_scheme`", still preserving the ;
-- even if there aren't two to populate the entry, e.g. "`dark_scheme;`"
--
-- Ret1 `error_message`  (`nil`|`string`),
-- Ret2 `dark_schemes`   (`table`|`nil`),
-- Ret3 `light_schemes`  (`table`|`nil`)
function M.load_cache_file(filepath)
  local file = io.open(filepath, "r")
  local data

  if file then -- Redundant but LSP won't shut up.
    if Safe.t_not(file, 'userdata') then
      local message = "Couldn't open file \"%s\", was tye \"%s\" expected \"userdata\""
      return string.format(message, filepath, type(file)), nil, nil
    end

    data = file:read("*a")
  end

  if Safe.t_not(data, "string") then
    local message = "Unexpected type \"%s\" for data read from file \"%s\""
    return string.format(message, filepath, type(file)), nil, nil
  end

  local iter_line = data:gmatch('([^\n]+)\n')
  local iter_count = 1

  local dark_schemes = {}
  local light_schemes = {}

  while true do
    local line = iter_line()
    if not Safe.t_is(line, 'string') or #line < 2 then break end

    local sep = line:find(";")

    if Safe.t_not(sep, 'number') then
      local message = "Invalid scheme entry (expected ;) on iteration %s, line: %s"
      return string.format(message, iter_count, line), nil, nil
    end

    local dark_scheme = line:sub(1, sep - 1)
    local light_scheme = line:sub(sep + 1)

    if #dark_scheme > 1 then
      table.insert(dark_schemes, dark_scheme)
    end

    if #light_scheme > 1 then
      table.insert(light_schemes, light_scheme)
    end

    iter_count = iter_count + 1
  end

  M.cache.schemes.dark  = dark_schemes
  M.cache.schemes.light = light_schemes

  return nil, dark_schemes, light_schemes
end

-- Writes the cache from M into filepath, as semicolon separated values.
-- This will overwrite the contents of file, so be warned.
function M.write_cache_file(filepath)
  local dark_schemes  = M.cache.schemes.dark
  local light_schemes = M.cache.schemes.light

  local max           = #dark_schemes

  if #dark_schemes < #light_schemes then
    max = #light_schemes
  end

  local cache_lines = {}

  for i = 1, max do
    local entry = string.format("%s;%s", dark_schemes[i] or '', light_schemes[i] or '')
    table.insert(cache_lines, entry)
  end

  local file = io.open(filepath, "w+")

  if file then -- Redundant but LSP won't shut up.
    if Safe.t_not(file, 'userdata') then
      local message = "Couldn't open file \"%s\", was tye \"%s\" expected \"userdata\""
      return string.format(message, filepath, type(file))
    end

    file:write(table.concat(cache_lines, '\n'))
    file:close()
  end
end

function M.add_scheme_to_cache(scheme)
  local result = M.test_current_scheme()

  if result == 0 then
    table.insert(M.cache.schemes.dark, scheme)
  elseif result == 1 then
    table.insert(M.cache.schemes.light, scheme)
  elseif result == -1 then
    table.insert(M.cache.schemes.other, scheme)
  else
    local message = "Error adding scheme %s to cache. Expected -1, 0 or 1, was %s"
    PrintDbg(string.format(message, scheme, result), LL_ERROR)
  end
end

-- Checks if the scheme is already in the cache.
function M.scheme_in_cache(scheme)
  local dark_schemes  = M.cache.schemes.dark
  local light_schemes = M.cache.schemes.light

  if Safe.v_in(scheme, dark_schemes) or Safe.v_in(scheme, light_schemes) then
    return true
  end

  return false
end

function M.enable_autocmd()
  if M.auto_cmd_id then
    vim.api.nvim_del_autocmd(M.auto_cmd_id)
  end

  M.auto_cmd_id = vim.api.nvim_create_autocmd({ "ColorScheme" }, {
    callback = function(opts)
      local scheme = opts.amatch

      if not M.scheme_in_cache(scheme) then
        M.add_scheme_to_cache(scheme)
      end
    end
  })
end

function M.disable_autocmd()
  if M.auto_cmd_id then
    vim.api.nvim_del_autocmd(M.auto_cmd_id)
  end
end

vim.api.nvim_create_user_command('Flashbang', function(opts)
  local recognized = { 'sync', 'clear', 'reload', 'disable_autocmd', 'enable_autocmd' }
  local args = opts.fargs

  if #args == 0 then
    local message = "No arguments provided, expected one of: %s"
    PrintDbg(string.format(message, table.concat(recognized, ', ')), LL_ERROR)
    return
  end

  for i, arg in ipairs(args) do
    -- Error if not recognized
    if not Safe.v_in(arg, recognized) then
      local message = "Unrecognized argument \"%s\" at index %s"
      PrintDbg(string.format(message, arg, i), LL_ERROR)
      return
    end
  end

  if #args == 1 then
    if args[1] == 'sync' then
      M.update_scheme_cache()
      vim.notify("Flashbang cache synced")
    elseif args[1] == 'clear' then
      M.cache.schemes.dark  = {}
      M.cache.schemes.light = {}
      M.cache.schemes.other = {}
      vim.notify("Flashbang cache cleared")
    elseif args[1] == 'reload' then
      M.load_cache_file(M.cache.file)
      vim.notify("Flashbang cache reloaded")
    elseif args[1] == 'disable_autocmd' then
      M.disable_autocmd()
    elseif args[1] == 'enable_autocmd' then
      M.enable_autocmd()
    end
  end
end, {
  nargs = '*',
  complete = function(_, _, _)
    return { 'sync', 'reload', 'clear', 'disable_autocmd', 'enable_autocmd' }
  end,
})

-- Sets the current scheme to one of the dark schemes in the cache.
vim.api.nvim_create_user_command('Coldark', function(opts)
  if #opts.fargs == 0 then
    print("No scheme was provided.", LL_ERROR)
    return
  end

  if #opts.fargs > 1 then
    print("Too many arguments provided.", LL_ERROR)
    return
  end

  local scheme = opts.fargs[1]

  if not Safe.v_in(scheme, M.cache.schemes.dark) then
    local message = "Scheme \"%s\" is not a dark scheme."
    print(string.format(message, scheme), LL_ERROR)
    return
  end

  vim.cmd('colorscheme ' .. scheme)
end, {
  nargs = '*',
  complete = function(_, _, _)
    return M.get_dark_schemes()
  end,
})

-- Sets the current scheme to one of the light schemes in the cache.
vim.api.nvim_create_user_command('Colight', function(opts)
  if #opts.fargs == 0 then
    print("No scheme was provided.", LL_ERROR)
    return
  end

  if #opts.fargs > 1 then
    print("Too many arguments provided.", LL_ERROR)
    return
  end

  local scheme = opts.fargs[1]

  if not Safe.v_in(scheme, M.cache.schemes.light) then
    local message = "Scheme \"%s\" is not a light scheme."
    print(string.format(message, scheme), LL_ERROR)
    return
  end

  vim.cmd('colorscheme ' .. scheme)
end, {
  nargs = '*',
  complete = function(_, _, _)
    return M.get_light_schemes()
  end,
})

return M
