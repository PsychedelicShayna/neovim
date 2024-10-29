function ConstructStatusLine()
  local status_line = ""
  local diagnostics = ""

  local gather_diagnostics = function(bufnr)
    local errors = #vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.ERROR })
    local warnings = #vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.WARN })
    local infos = #vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.INFO })
    local hints = #vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.HINT })
    return { errors = errors, warnings = warnings, infos = infos, hints = hints }
  end

  local buffers = vim.api.nvim_list_bufs()

  local current_buffer_diagnostics = gather_diagnostics(0)
  local buffer_diagnostics = {}

  for _, bufnr in ipairs(buffers) do
    if bufnr ~= 0 then
      buffer_diagnostics[bufnr] = gather_diagnostics(bufnr)
    end
  end

  local cbd = current_buffer_diagnostics
  local bd = buffer_diagnostics

  local cummulative_diagnostics = { errors = 0, warnings = 0, infos = 0, hints = 0 }

  for _, diagnostics in pairs(buffer_diagnostics) do
    cummulative_diagnostics.errors = cummulative_diagnostics.errors + diagnostics.errors
    cummulative_diagnostics.warnings = cummulative_diagnostics.warnings + diagnostics.warnings
    cummulative_diagnostics.infos = cummulative_diagnostics.infos + diagnostics.infos
    cummulative_diagnostics.hints = cummulative_diagnostics.hints + diagnostics.hints
  end

  local cd = cummulative_diagnostics

  local have_global = (cd.errors + cd.warnings + cd.infos + cd.hints) > 0


  local have_local = (cbd.errors + cbd.warnings + cbd.infos + cbd.hints) > 0


  if cbd.errors > 0 then
    diagnostics = diagnostics .. 'E' .. cbd.errors .. ' '
  end

  if cbd.warnings > 0 then
    diagnostics = diagnostics .. 'W' .. cbd.warnings .. ' '
  end

  if cbd.infos > 0 then
    diagnostics = diagnostics .. 'I' .. cbd.infos .. ' '
  end

  if cbd.hints > 0 then
    diagnostics = diagnostics .. 'H' .. cbd.hints .. ' '
  end

  if have_global then
    if have_local then
      diagnostics = 'Local ' .. diagnostics .. '| Global '
    else
      diagnostics = diagnostics .. 'Local Clean | Global '
    end
  elseif have_local then
    diagnostics = 'Local ' .. diagnostics .. '| Global Clean '
  else
    diagnostics = diagnostics .. 'Local Clean | Global Clean '
  end

  if cd.errors > 0 then
    diagnostics = diagnostics .. 'E' .. cd.errors .. ' '
  end

  if cd.warnings > 0 then
    diagnostics = diagnostics .. 'W' .. cd.warnings .. ' '
  end

  status_line = '[ ' .. diagnostics .. '] << [' .. vim.fn.getcwd(-1, -1) .. '] <<GL>> [' .. vim.fn.getcwd(0) .. '] '

  return status_line
end

vim.o.statusline = "%!v:lua.ConstructStatusLine()"
