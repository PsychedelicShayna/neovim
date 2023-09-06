
vim.o.colorcolumn = '80,120'
vim.o.expandtab = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.scrolloff = 16
vim.o.shiftwidth = 2
vim.o.sidescrolloff = 64
vim.o.softtabstop = 2
vim.o.tabstop = 2
vim.o.wrap = false

vim.cmd('color murphy')

function PrintDbg(var, name)
  if name ~= nil then
    print('\n\n')
    print('Inspection for ' .. name)
    print('-----------------------------------------')
  end

  print(vim.inspect(var))
end 

--!!__________________________________________________!! 
--!!                                                  !! 
--!!                 CRITICAL CODE                    !!
--!!__________________________________________________!! 
--!!                                                  !!
--!! The most important function in the init.lua file !!-----------------------
--!!__________________________________________________!!
--
-- This function is the global importer that is used throughout the config to
-- import other modules. It is a wrapper aloud require, and pcall(require, ...
-- with extended functionality. Within the confines of this config, always use
-- import over require.
--
-------------------------------------------------------------------------------

function import(name, options)
 local result = {
   Name = name, -- Same name that would have been passed to require.
   Prefix = nil, -- Prefix prepended to the name, to make a module path.

   PreCb = nil, -- Function that will be called right before import.
   PostCb = nil, -- Inverse of PreCb, called after import.

   Critical = false,  -- The config will panic if this module fails to load.

   HardDependents = {}, -- Modules that cannot function without this one.
   Softependents = {}, -- Modules that optionally take advantage of this one.

   HardDependenceis = {}, -- Mandatory modules for this module to work.
   SoftDependencies = {} -- Opotional modules that this module.
  }

  return result;
end

-------------------------------------------------------------------------------
--- ^                       ^ CRITICAL CODE ^                             ^ ---
-------------------------------------------------------------------------------










-- Prelude --------------------------------------------------------------------

import('prelude')

local prelude_ok, prelude = pcall(require, 'prelude')

if not prelude_ok or prelude == nil or type(prelude) ~= 'table' then
  print("Could not import prelude; the rest of the configuration will not load, because prelude is a core dependency.")
  print("Sane defaults will be provided however.")
  PrintDbg(prelude_ok, 'prelude_ok')
  PrintDbg(prelude, 'prelude')
  return {}
end


print('Inspection of prelude.events: ')
print(vim.inspect(prelude.events))
print('And then of prelude: ')
print(vim.inspect(prelude))

