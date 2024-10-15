local M = {}

function M.str_split(str, delimiter)
  if not str then
    return {}
  end

  if not delimiter or delimiter == "" then
    return { str }
  end

  local gsub_pattern = string.format("([^%s]+)", delimiter)

  local entries = {}

  str:gsub(gsub_pattern, function(element)
    entries[#entries + 1] = element
  end)

  return entries
end

function M.zip(...)
  local args = { ... }

  local zipped = {}

  for i = 1, #args[1] do
    local entry = {}

    for _, arg in ipairs(args) do
      entry[#entry + 1] = arg[i]
    end

    zipped[#zipped + 1] = entry
  end

  return zipped
end

function M.path_basename(path)
  if not path then
    return nil
  end

  local parts = M.str_split(path, "/")
  return parts[#parts]
end

local test_path = "/home/username/.config/nvim/init.lua"
assert(M.path_basename(test_path) == "init.lua")

function M.path_dirname(path)
  if not path then
    return nil
  end

  local reversed = string.reverse(path)
  local first_slash = string.find(reversed, "/")
  local distance = #reversed - first_slash

  local dirname = string.sub(path, 1, distance)

  return dirname
end

function M.path_join(...)
  local parts = { ... }

  local path = ""

  for _, part in ipairs(parts) do
    path = path .. part .. "/"
  end

  return path
end

function M.path_extension(path)
  if not path then
    return nil
  end

  local parts = M.str_split(path, ".")
  return parts[#parts]
end

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
