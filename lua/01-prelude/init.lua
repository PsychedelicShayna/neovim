--- Magic Numbers/Values ------------------------------------------------------
--

LL_TRACE = vim.log.levels.TRACE -- 0
LL_DEBUG = vim.log.levels.DEBUG -- 1
LL_INFO  = vim.log.levels.INFO  -- 2
LL_WARN  = vim.log.levels.WARN  -- 3
LL_ERROR = vim.log.levels.ERROR -- 4
LL_OFF   = vim.log.levels.OFF   -- 5

NOP      = function() end

--- Error/Debug Printing ------------------------------------------------------
--


-- Setting this to true, will allow the below function to take effect.
DEBUG_MODE = false

function PrintError(module_name, message, inspections)
  vim.notify('[' .. module_name .. '] ' .. message)
end


function PrintDbg(message, level, inspections)
  if not level then
    level = LL_INFO
  end

  vim.notify(message, level)

  if type(inspections) == "table" then
    for index, item in ipairs(inspections) do
      local item_type = type(item)
      local item_str = "nil"

      if item_type ~= 'nil' then
        item_str = vim.inspect(item)
      end

      vim.notify('I' .. index .. ";" .. item_type .. ':' .. item_str)
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
  PrintDbg("Prelude failed to import a component of itself: safety.lua", LL_ERROR)
  PrintDbg("The error was caught via pcall, so the whole config does not crash.", LL_INFO)
  PrintDbg("The pcall return values... ", LL_DEBUG, { safety_ok, safety })
  PrintDbg("The Safety global: ", LL_DEBUG, { Safety })

  Safety = 0xDEADC0DE
end

--- Export Event System -------------------------------------------------------
--

Events = {}

local events_ok, events = pcall(require, "01-prelude.events")

if events_ok then
  Events = events
else
  PrintDbg(
    "Prelude failed to import a component of itself [events.lua] inspection: ",
    LL_ERROR, {
      events,
      events_ok
    })

  Events = 0xDEADC0DE
end

--
--- EOF, End of File ----------------------------------------------------------
