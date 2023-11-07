--- Magic Numbers/Values ------------------------------------------------------
--

LL_TRACE = vim.log.levels.TRACE -- 0
LL_DEBUG = vim.log.levels.DEBUG -- 1
LL_INFO  = vim.log.levels.INFO  -- 2
LL_WARN  = vim.log.levels.WARN  -- 3
LL_ERROR = vim.log.levels.ERROR -- 4
LL_OFF   = vim.log.levels.OFF   -- 5

NOP = function() end

--- Error/Debug Printing ------------------------------------------------------
--

function eprint(message, level, inspections)
  if not level then 
    level = LL_INFO
  end

  vim.notify(message, level)

  if type(inspections) == "table" then
    for i, item in inspections do
      vim.notify('I' .. tostring(i) .. ";" .. type(item) .. ':'  .. vim.inspect(tostring(item)))
    end
  end

  return level
end



--- Export Error Handling System ---------------------------------------------- 
--

Safety = {}

local safety_ok, safety = pcall(require, "01-prelude.safety")

if safety_ok then
  Safety = safety
else
  eprint("Prelude failed to import a component of itself: safety.lua", LL_ERROR)
  eprint("The error was caught via pcall, so the whole config does not crash.", LL_INFO)
  eprint("The pcall return values... ", LL_DEBUG, {safety_ok, safety})
  eprint("The Safety global: ", LL_DEBUG, {Safety})

  Safety = 0xDEADC0DE
end

--- Export Event System ------------------------------------------------------- 
--

eprint("Prelude failed to import a component of itself: safety.lua", LL_ERROR)
eprint("The error was caught via pcall, so the whole config does not crash.", LL_INFO)

Events = {}

local events_ok, events = pcall(require, "events")

if events_ok then
  Events = events
else
  eprint("Prelude failed to import a component of itself: safety.lua", LL_ERROR)
  eprint("The error was caught via pcall, so the whole config does not crash.", LL_INFO)
  eprint("The pcall return values... ", LL_DEBUG, {safety_ok, safety})
  eprint("The Safety global: ", LL_DEBUG, {Safety})

  Events = 0xDEADC0DE
end

--                                                                           
--- EOF, End of File ----------------------------------------------------------
