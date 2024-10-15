local M = {}

local function traceback_caller(depth)
  local info = debug.getinfo(depth + 1, "Sl")
  return string.format("%s:%d", info.short_src, info.currentline)
end

return M
