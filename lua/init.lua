-- ----------------------------------------------------------------------------
-- First and foremost, before anything has the chance to crash, crashproof
-- defaults should be set. Actual code execution should come later.
-- ----------------------------------------------------------------------------
vim.g.mapleader      = ' '
vim.g.maplocalleader = ' '
vim.o.cindent        = true
vim.o.clipboard      = 'unnamedplus'
vim.o.cmdheight      = 2
vim.o.colorcolumn    = "80,120"
vim.o.conceallevel   = 0
vim.o.expandtab      = true
vim.o.hlsearch       = true
vim.o.ignorecase     = true
vim.o.laststatus     = 3
vim.o.matchtime      = 1
vim.o.number         = true
vim.o.numberwidth    = 4
vim.o.pumheight      = 5
vim.o.relativenumber = true
vim.o.scrolloff      = 8
vim.o.shiftwidth     = 2
vim.o.shortmess      = "ltToOFIrC"
vim.o.showfulltag    = true
vim.o.showmatch      = true
vim.o.showtabline    = 1
vim.o.sidescrolloff  = 8
vim.o.signcolumn     = "yes"
vim.o.smartcase      = true
vim.o.softtabstop    = -1
vim.o.spelllang      = "en_us"
vim.o.splitbelow     = true
vim.o.splitright     = true
vim.o.swapfile       = false
vim.o.tabstop        = 8
vim.o.termguicolors  = true
vim.o.timeoutlen     = 250
vim.o.undofile       = true
vim.o.updatetime     = 300
vim.o.virtualedit    = "none"
vim.o.winbar         = '%y %t %m > %L > %l:%c > %b @ 0x%O (%o) > %F'
vim.o.wrap           = false
vim.o.writebackup    = false
-------------------------------------------------------------------------------

-- Regardless of the above preference, if something does go wrong, we want to
-- have some "safe mode" options, beacause the extent of the issue could be
-- anywhere from benign, to being stuck in a TTY with no window manager, so
-- better to be safe(er) than sorry(er); it's a parachute, not a safety net.
function FubarMode()
  -- We want bakups, swapfiles, undofiles; who knows what went wrong.
  vim.o.swapfile      = true
  vim.o.writebackup   = true
  vim.o.undofile      = true
  vim.o.updatetime    = 100

  -- Minimize any incompatibility issues arising from termguicolors, e.g.
  -- when running Neovim in a TTY with no Window manager.
  vim.o.termguicolors = false

  -- We do not want to omit any any information, even if verbosely annoying.
  vim.o.shortmess     = ""

  -- We want to make sure we can copy/paste from the system clipboard.
  vim.o.clipboard     = 'unnamedplus'

  -- Virtualedit can be a source of problems.
  vim.o.virtualedit   = "none"

  -- We always want to know what tabs exist and which one we're on.
  vim.o.showtabline   = 2

  -- Line wrap can freeze Neovim when reading large files.
  vim.o.wrap          = false

  -- We want context, what byte is under the cursor, where we're located, etc.
  vim.o.winbar        = '%y %t %m > %L > %l:%c > %b @ 0x%O (%o) > %F'

  vim.notify("FubarMode options have been set.")
end

-- Get Child Modules -----------------------------------------------------------
function GetChildModules()
  local reflect = debug.getinfo(2, "S")
  local full_path = reflect.source

  local module_path = full_path:match("@.*" .. LuaConfigHome .. '(.+)/[^/]+.lua$')

end

-------------------------------------------------------------------------------

---@class LoadOrder
---@field files table Sorted table of files prefixed by N-Filename, e.g. 05-thing.lua, or 105-thing.lua
---@field dirs table Sorted table of directories prefixed by N-Dirname, e.g. 05-stuff, or 105-stuff.lua

---@param path string The path to the directory containing files and or folders to sort.
---@return LoadOrder? -- A table with dirs and files subkeys, containing the sorted list N-Prefixed names. Nil on failure to read directory contents.
function GetLoadOrder(path)
  local result = { dirs = {}, files = {} }
  local iter = vim.loop.fs_opendir(path, nil, 100)

  if not iter then
    return nil
  end

  ---@type uv.fs_readdir.entry[]?
  local entries = vim.loop.fs_readdir(iter)

  while entries do
    for _, entry in ipairs(entries) do
      ---@type number?
      local prefix = tonumber(entry.name:match("^%d+"))

      if prefix then
        if entry.type == "directory" then
          table.insert(result.dirs, entry.name)
        elseif entry.type == "file" then

          -- Only match lua files, and remove the extension.
          local module_name = entry.name:match("(.+)%.lua$")

          if module_name then
            table.insert(result.files, module_name)
          end
        end
      end
    end

    entries = vim.loop.fs_readdir(iter)
  end

  vim.loop.fs_closedir(iter)

  local function sort_by_prefix(a, b)
    return tonumber(a:match("^%d+")) < tonumber(b:match("^%d+"))
  end

  table.sort(result.dirs, sort_by_prefix)
  table.sort(result.files, sort_by_prefix)

  return result
end

-------------------------------------------------------------------------------

function ImportModuleTree()
  local reflect = debug.getinfo(2, "S")
  local full_path = reflect.source

  -- "04-custom/01-lib"
  local module_path = full_path:match("@.*" .. LuaConfigHome .. '(.+)/[^/]+.lua$')

  -- "04-custom.01-lib"
  local import_path = module_path:gsub('/', '.') or nil

  -- { dirs = {}, files = { "05-hello", "06-world" } }
  local load_order = GetLoadOrder(LuaConfigHome .. module_path)

  if not load_order then
    return nil
  end

  for _, dir in ipairs(load_order.dirs) do
    local ok, _ = pcall(require, string.format("%s.%s", import_path, dir))

    if not ok then
      vim.notify("Failed to import module: " .. dir)
    end
  end

  for _, file in ipairs(load_order.files) do
    local ok, _ = require(string.format("%s.%s", import_path, file))

    if not ok then
      vim.notify("Failed to import module: " .. file)
    end
  end
end

-------------------------------------------------------------------------------
--- Config loading starts here.

LuaConfigHome = os.getenv("HOME") .. "/.config/nvim/lua/"
local load_order = GetLoadOrder(LuaConfigHome)

if load_order == nil or load_order.dirs == nil then
  vim.notify(
    "Something has gone horribly wrong. GetLoadOrder failed; the Lua config might not even exist, we may not have permission, perhaps it's corrupt? Switching to FubarMode.",
    vim.log.levels.ERROR)

  FubarMode()
elseif #load_order.dirs == 0 then
  vim.notify(
    "Something might be wrong. No modules were found in the Lua config!",
    vim.log.levels.WARN)
else
  for number, name in ipairs(load_order.dirs) do
    if type(name) == "string" then
      local module_ok, _ = pcall(require, name)

      if not module_ok then
        vim.notify(string.format("Failed to load module %i: %s", number, name), vim.log.levels.ERROR)
      end
    end
  end
end
