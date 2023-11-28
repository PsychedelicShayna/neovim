local export = {}

local modules = {
  symbols = "02-storage.symbols",
  banners = "02-storage.banners"
}

for name, path in pairs(modules) do
  local module_ok, module = pcall(require, path)

  if module_ok then
    export[name] = module
  end
end

Data = export

return export
