ModuleResolver = {}

-- This function strips number prefixes from file/dir names.
-- e.g. 01-ascii-art => ascii-art, 02-storage => storage, etc.
---@param name string -- The name to be stripped.
---@return string
function ModuleResolver.purename(name)
  name = name:gsub("^%d+%-", "") or nil
  name = name:gsub("%-", "_") or nil
  return name
end

---@param confrelative boolean? -- Whether to return a config-relative path.
---@return string -- The absolute path of the current module.
function ModuleResolver.whereami(confrelative)
  local reflect = debug.getinfo(2, "S")

  local source_path = reflect.source and reflect.source:gsub("^@", "")
  local working_dir = vim.loop.cwd()

  local is_relative = source_path:sub(1, 1) ~= '/'

  ---@type string
  local return_path

  if is_relative then
    return_path = working_dir .. '/' .. source_path
  else
    return_path = source_path
  end

  if confrelative then
    return_path = return_path:sub(#LuaConfigHome + 1)
  end

  return return_path
end

---@param path string 
---@return string
function ModuleResolver.reqformat(path)
  path = path:gsub("/", ".")
  return path:gsub(".+[^/]+%.lua$", "") or nil
end

---@param path string -- The initial starting path from which to '..'
---@param level number?  -- How many levels to ascend. Default: 1.
---@return string -- The directory path after ascending '..' <level> times.
---@usage
--- ```lua
---  -- Asssuming it's called from /path/to/this/file.lua
---   ModuleResolver.ascend() => '/path/to/this/'
---   ModuleResolver.ascend(2) => '/path/to/'
---
---   -- Explicitly specified path.
---   ModuleResolver.ascend(1, '/path/to/other/file') => '/path/to/other/'
---   ModuleResolver.ascend(2, '/path/to/diectory/') => '/path/'
--- ```
function ModuleResolver.ascend(path, level)
  path = path or ModuleResolver.whereami()
  level = level or 1
  path = path:sub(-1) == '/' and path:sub(1, -2) or path
  for _ = 1, level do path = vim.fs.dirname(path) end
  return path
end

---@return string[]?,string[]|string --- files[],dirs[] on success or nil,err on failure.
-- Returns the surrounding files and directories of the current module, excluding the module itself.
function ModuleResolver.lookaround()
  local current_module_path = ModuleResolver.whereami()
  local current_module_name = vim.fs.basename(current_module_path)

  local parent = ModuleResolver.ascend(current_module_path, 1)
  local handle = vim.loop.fs_opendir(parent)

  if not handle then
    return nil, "Could not open directory: " .. parent
  end

  local files = {}
  local dirs = {}

  local entries = handle:readdir()

  while entries do
    for _, entry in ipairs(entries) do
      if entry.type == 'directory' then
        table.insert(dirs, entry.name)
      elseif current_module_name ~= entry.name then
        table.insert(files, entry.name)
      end
    end
    entries = handle:readdir()
  end

  return files, dirs
end

-- Filters out non-lua files, init.lua files, and directories that don't contain an init.lua file.
---@param files? string[] --- The list of files to filter.
---@param dirs? string[] --- The list of directories to filter.
---@return string[],string[]
function ModuleResolver.find_modules(files, dirs)
  if not files and not dirs then
    return {}, {}
  end

  local module_files = {}
  local module_dirs = {}

  if files then
    for _, file in ipairs(files) do
      if file:match("%.lua$") and file ~= 'init.lua' then
        table.insert(module_files, file)
      end
    end
  end

  if dirs then
    for _, dir in ipairs(dirs) do
      local init_file = dir .. '/init.lua'
      if vim.loop.fs_stat(init_file) then
        table.insert(module_dirs, dir)
      end
    end
  end

  return module_files, module_dirs
end

return ModuleResolver
