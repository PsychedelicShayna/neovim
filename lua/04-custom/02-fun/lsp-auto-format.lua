local M = {}

_G.afmt_enabled = true

-- Entries consist of a language, and a list of valid formatters for it.
-- Formatters can be swapped out by using the Afmt command to set formatter.

M.available_formatters = {
  ['python'] = { 
    { name = "black",   command = "black %s" }, 
  },

  ['lua'] = { 
    { name = "stylua", command = "stylua %s" }, 
  }
}

vim.api.nvim_create_user_command("Afmt", function(opts)
  if opts.args == 'enable' then
    _G.afmt_enabled = true
  elseif opts.args == 'disable' then
    _G.afmt_enabled = false
  elseif opts.args == 'toggle' then
    _G.afmt_enabled = not _G.afmt_enable
  end
end, {
  nargs = "?",
  complete = function(_, _, _)
    -- TODO: Implement completion for formatters after any of the below.
    return { "enable", "disable", "toggle" }
  end
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  callback = function(opts)
    local file_type = opts.match
    local buffer = opts.buf

    local full_path = vim.api.nvim_buf_get_name(buffer)

    local custom_formatter = custom_formatters[file_type]

    Safe.try_catch(function()
      vim.api.nvim_buf_set_var(buffer, "afmt_formatter", custom_formatter)
    end, function()
    end)
  end
})

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  callback = function(opts)
    local file_name = opts.file
    local buffer = opts.buf

    if not _G.afmt_enabled then
      return
    end
      local custom_afmt = vim.api.nvim_buf_get_var(opts.buf, "afmt_formatter")

      if Safe.t_is(custom_afmt, 'nil') then
        vim.lsp.buf.format({ async = true })
      else

        local normalized = vim.fs.normalize(file_name)
        local command = string.format(custom_afmt, normalized)

        os.system(command)
      end
  
      local file_name = opts.file
      local buffer = opts.buf
  end
})

