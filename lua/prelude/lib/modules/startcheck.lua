function plNvimGetDirectlyOpened()
  -- A file was opened.
  if vim.fn.argc() > 0 then return false end

  -- Stdin was provided.
  if vim.fn.line2byte("$") ~= -1 then return false end

  -- Started with -M modifiable, most likely.
  if not vim.o.modifiable then return false end

  -- Ignore arguments that fall under...
  local whitelist = {
    ["--startuptime"] = true
  } 

  -- Target arguments that fall under...
  local blacklist = {
    ["-b"] = true,
    ["-c"] = true,
    ["-S"] = true,
    esoteric = function(argument)
      if vim.startswith(argument, "+") then 
        return true 
      end
    end
  }

  for _, arg in pairs(vim.v.argv) do
    local whitelisted = whitelist[arg]
    local blacklisted = blacklist[arg] or blacklist.esoteric(arg)

    if     whitelisted then return true 
    elseif blacklisted then return false 
    end
  end

  -- Nothing caught, Neovim probably started directly.
  return true
end

