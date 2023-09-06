-- function ListDir(path)
--   local directory = vim.loop.fs_scandir_next(path)
--   local collection = {}
-- 
--   while true do
--     local ename, etype = vim.loop.fs_scandir_next(directory)
-- 
--     if not ename then
--       break
--     end
--     
--     table.insert(collection, {ename, etype})
--   end
-- 
--   vim.loop.fs_closedir(directory)
-- end
-- 
-- 
-- function IterDir(path)
--   local directory = vim.loop.fs_opendir(path)
-- 
--   return function()
--     local ename, etype = vim.loop.fs_scandir_next(directory)
--     
--     if ename then
--       return ename, etype
--     else
--       vim.loop.fs_closedir(directory)
--     end
--   end
-- end
-- 
-- local listing = ListDir("C:\\Bin")
-- 
-- for _, e in ipairs(listing) do
--   vim.notify(vim.inspect(e))
-- end





