-- LuaConfigHome = os.getenv("HOME") .. "/.config/nvim/lua/"
--
-- local load_order = GetLoadOrder(LuaConfigHome .. '01-prelude')
--
-- local function remove_extension(path)
--   return path:match("(.+)%..+$") or path -- Removes the extension, if present
-- end
--
-- print(("test.lua.disabled"):match(""))
--
-- for number, name in ipairs(load_order.files) do
--   name = remove_extension(name)
--   local module_ok, _ = pcall(require, "01-prelude." .. name)
--
--   if not module_ok then
--     vim.notify(string.format("Failed to load module %i: %s", number, name), vim.log.levels.ERROR)
--   end
-- end


ImportModuleTree()
