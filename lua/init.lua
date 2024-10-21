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
vim.o.pumheight      = 12
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
  vim.o.writebackup   = true
  vim.o.backup        = true
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

-------------------------------------------------------------------------------
---@alias ModuleType "f" | "d"
---@class ModuleInfo
---@field name string
---@field type ModuleType

---@param path string The path to the directory containing files and or folders to sort.
---@return ModuleInfo[]?
function GetLoadOrder(path)
  local handle = vim.loop.fs_opendir(path, nil, 100)
  if not handle then return nil end

  ---@type ModuleInfo[]
  local results = {}

  local entry_iter = vim.loop.fs_readdir(handle)

  while entry_iter do
    for _, entry in ipairs(entry_iter) do
      ---@type number?
      local prefix = tonumber(entry.name:match("^%d+"))

      if prefix then
        if entry.type == "directory" then
          ---@type ModuleInfo
          local module_info = { name = entry.name, type = "d" }
          table.insert(results, module_info)
        else
          -- Only match lua files, and remove the extension.
          local module_name = entry.name:match("(.+)%.lua$")

          if module_name then
            ---@type ModuleInfo
            local module_info = { name = module_name, type = "f" }
            table.insert(results, module_info)
          end
        end
      end
    end

    entry_iter = vim.loop.fs_readdir(handle)
  end

  vim.loop.fs_closedir(handle)

  local function sort_by_prefix(a, b)
    return tonumber(a.name:match("^%d+")) < tonumber(b.name:match("^%d+"))
  end

  table.sort(results, sort_by_prefix)

  return results
end

-------------------------------------------------------------------------------

--- Will import all other modules in the same directory as the module it was
--- from, which have a numerical prefix, e.g. 01-prelude, or 00-debug.lua,
--- Returns a table with two keys, `files` and `dirs`, both being tables that
--- store the name and return value of each imported module respectively.
--- Directories with a numerical prefix take precedence over files.
---@class ModuleReturns
---@field name string
---@field returned any
---@return ModuleReturns[]?
function ImportModuleTree()
  local reflect = debug.getinfo(2, "S")
  local full_path = reflect.source

  -- e.g. "04-custom/01-lib"
  local module_path = full_path:match("@.*" .. LuaConfigHome .. '(.+)/[^/]+.lua$')

  -- e.g "04-custom.01-lib"
  local import_path = module_path:gsub('/', '.') or nil

  -- { dirs = {}, files = { "05-hello", "06-world" } }
  local load_order = GetLoadOrder(LuaConfigHome .. module_path)

  if not load_order then
    vim.notify("Can't import module tree, GetLoadOrder returned nil for: " .. module)
    return nil
  end

  local return_values = {}

  for _, module_info in ipairs(load_order) do
    local name = module_info.name

    local ok, module = pcall(require, string.format("%s.%s", import_path, name))

    if not ok then
      local message = string.format("Failed to import module: %s - %s", name, vim.inspect(module))
      vim.notify(message)
    else
      return_values[name] = module
    end
  end



  return return_values
end

-------------------------------------------------------------------------------
--- Config loading starts here.

LuaConfigHome = os.getenv("HOME") .. "/.config/nvim/lua/"
local load_order = GetLoadOrder(LuaConfigHome)

if load_order == nil then
  vim.notify(
    "Something has gone horribly wrong. GetLoadOrder failed; the Lua config might not even exist, we may not have permission, perhaps it's corrupt? Switching to FubarMode.",
    vim.log.levels.ERROR)

  FubarMode()
elseif #load_order == 0 then
  vim.notify(
    "Something might be wrong. No modules were found in the Lua config!",
    vim.log.levels.WARN)
else
  for number, module_info in ipairs(load_order) do
    local name = module_info.name

    if type(name) == "string" then
      local module_ok, module = pcall(require, name)

      if not module_ok then
        vim.notify(string.format("Failed to load module %i: %s - %s", number, name, vim.inspect(module)),
          vim.log.levels.ERROR)
      end
    end
  end
end
