-- This introduces a new user command, :Z which acts like cd except it quries
-- Zoxide with the given search term, and will cd td  to the first match.
--
-- Commd invcation: zoxide query "search term"
--
-- We need to run and get the output of said comment invocation, then
-- changge the current directory to the directory given by the output.
--
-- We should ensure the directory provided is valid by Zoxide exists though.

local M = {}

---@return boolean
function M.is_directory(path)
  local stat = vim.loop.fs_stat(path)
  return stat and stat.type == "directory" or false
end

---@param query string
function M.get_completion_list(query)
  ---@type string
  local command_template = "zoxide query --list --exclude %q %q"

  ---@type string
  local command = string.format(command_template, vim.fn.getcwd(), query)

  ---@type file*?, string?
  local handle = io.popen(command, "r")

  if handle == nil then
    return {}
  end

  ---@type string
  local results = handle:read("*a")
  handle:close()

  ---@type string[]
  local lines = {}

  for line in results:gmatch("[^\r\n]+") do
    ---@type string
    line = line:match("^%s*(.-)%s*$")
    table.insert(lines, line)
  end

  return lines
end

---@param opts table
---@return boolean Whether or not the directory completed via Zoxide.
function M.zoxide_cd(opts, cdcmd)
  if type(opts) ~= 'table' then
    PrintDbg(string.format("zoxide_cd received a %q as its input, only receive an options table", type(opts)),
      LL_ERROR)
  end

  if not cdcmd then
    cdcmd = "cd"
  end

  ---@type string
  local path = opts.args

  ---@type string
  local zpath = ""

  ---@type file*?, string?
  local handle = io.popen("zoxide query " .. path, "r")
  if handle ~= nil then
    zpath = handle:read("*a")

    if type(zpath) == 'string' then
      zpath = zpath:match("^%s*(.-)%s*$")
    end

    handle:close()
  end

  local bad_result = (zpath == nil or zpath == "" or type(zpath) ~= 'string' or zpath == "zoxide: no match found")
  local path_exists = M.is_directory(path)
  local destination = zpath

  -- The path does exist but Zoxide isn't aware, we should inform it.
  if bad_result and path_exists then
    handle = io.popen(string.format("zoxide add %s", path))
    destination = path

    if handle ~= nil then
      handle:close()
    else
      PrintDbg(string.format("Could not inform Zoxide that %q exists; handle was nil."), LL_WARN)
    end
  elseif not M.is_directory(zpath) then
    vim.notify(string.format("Zoxide gave back a path that does not exist: %q", zpath))
    return false
  end

  vim.cmd(string.format("%s %s", cdcmd, destination))
  vim.cmd("pwd")

  return not bad_result
end

local function zoxide_complete(_arglead, cmdline, _cursorpos)
  ---@type string?
  local args = cmdline:match("^Z (.+)")
  return (args and M.get_completion_list(args)) or {}
end

vim.api.nvim_create_user_command("Z",
  function(query) M.zoxide_cd(query) end,
  { nargs = '?', range = '%', complete = zoxide_complete, }
)

vim.api.nvim_create_user_command("Zt",
  function(query) M.zoxide_cd(query, "tcd") end,
  { nargs = '?', range = '%', complete = zoxide_complete, }
)

vim.api.nvim_create_user_command("Zl",
  function(query) M.zoxide_cd(query, "lcd") end,
  { nargs = '?', range = '%', complete = zoxide_complete, }
)

-- vim.api.nvim_create_user_command("Zt",
--   function(query) M.zoxide_cd(query, "t") end,
--   { nargs = '?', range = '%', complete = zoxide_complete, })
--
-- vim.api.nvim_create_user_command("Zl",
--   function(query) M.zoxide_cd(query, "l") end,
--   { nargs = '?', range = '%', complete = zoxide_complete, })
--

return M
