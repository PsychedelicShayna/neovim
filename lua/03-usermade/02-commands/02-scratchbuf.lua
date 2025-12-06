-- This introduces a new user command `:ScratchPad`, which opens a new
-- temporary buffer in a vertical split, with an optional file extension.
-- When the buffer is closed, the temporary file is deleted from disk.
--
-- What needs to be added and what we will be doing right now, is adding the
-- ability to specify the file extension when creating the scratch buffer,
-- as an argument to the command. We will also recognize certain strings
-- like "py" for Python, "js" for JavaScript, etc., to make it easier so
-- the user doesn't have to type the full extension every time.
--
-- Furthermoe, some unique strings, such as "output" which can be used to
-- store compiler or program output, can be mapped to specific strings that
-- are non-extensions, and will be stored with no extension, but the buffer
-- will have specific settings applied to it, such as nowrite, nolist, wreap
-- and options that make it more suitable for viewing output.

local special_extensions = {
  out = {
    file_extension = "",
    buffer_options = {
      -- buftype = "nofile",
      -- bufhidden = "wipe",
      -- swapfile = false,
      -- readonly = false,
      -- write = false,
      -- nospell = true,
      -- nowrap = true,
      colorcolumn="",
      relativenumber=false,
      number=false,
      signcolumn="no",
      -- number = true,
    }
  }
}


vim.api.nvim_create_user_command("Temp", function(opts)
  local args = opts.args
  args = vim.trim(args)

  local split_args = vim.split(args, "%s+")

  -- Can be v, s, r, or t.
  -- vsplit opens in a vertical split (default)
  -- split opens in a horizontal split
  -- replace opens in the current window, replacing the current buffer without
  -- deleting the buffer that it replaces, it just loads itself onto the window.
  -- tabnew opens in a new window in a new tab.
  local split_type = split_args[1] or "v"

  local extension = split_args[2] or ""

  -- Get a temporary file path; should be unique every time.
  local temp_file_name = vim.fn.tempname()

  -- In case of a conflicting path, re-run the function until
  -- a unique path is generated, and add in the current timestamp
  -- for good measure, to ensure uniqueness.

  while vim.fn.filereadable(temp_file_name) ~= 0 do
    temp_file_name = string.format("%s.%s", vim.fn.tempname(), os.time())
  end

  if extension == "" then
    -- Query the user for the file's extension, which will determine the syntax
    -- highlighting and language server, due to its filetype.
    extension = vim.fn.input("Extension: ")
  end

  extension = vim.trim(extension)

  local is_special = false

  if special_extensions[extension] ~= nil then
    is_special = true
  else
    if extension ~= "" then
      temp_file_name = temp_file_name .. "." .. extension
    end
  end

  -- Write the file first, before opening it in a vertical split, to ensure
  --  it's a fresh read from the disk, triggering all autocmds that would
  --  launch LSP, pick filetype, etc..
  vim.fn.writefile({}, temp_file_name)

  if split_type == "s" then
    vim.cmd("split " .. temp_file_name)
  elseif split_type == "r" then
    vim.cmd("edit " .. temp_file_name)
  elseif split_type == "t" then
    vim.cmd("tabnew " .. temp_file_name)
  else
    -- Vertical split, and get the current buffer number immediately after.
    vim.cmd("vsplit " .. temp_file_name)
  end


  local bufnr = vim.api.nvim_get_current_buf()


  if is_special then
    local buf_options = special_extensions[extension].buffer_options

    for option, value in pairs(buf_options) do
      local winid = vim.fn.bufwinid(bufnr)
      vim.api.nvim_set_option_value(option, value, { win = winid, scope = 'local' })
    end
  end

  -- -- Set the buffer's name to indicate it's a scratch buffer.
  -- vim.api.nvim_buf_set_name(bufnr, "[Scratch] " .. vim.api.nvim_buf_get_name(bufnr))

  -- Use lcd to set the cd of the window to the parent directory of the temp file.
  -- local parent_dir = vim.fn.fnamemodify(temp_file_name, ":h")
  local expanded = vim.fn.expand(temp_file_name)
  local parent_modern = vim.fs.dirname(expanded)
  parent_modern = vim.fs.abspath(parent_modern)
  vim.cmd("lcd " .. parent_modern)

  -- Using the buffer number, create an autocmd to delete the file when the
  -- buffer is closed, but the window may stay open.

  local autocmd = vim.api.nvim_create_autocmd({ "BufDelete" }, {
    buffer = bufnr,
    once = true,
    callback = function()
      Safe.try(function()
        os.remove(temp_file_name)
      end)

      -- Fire a custom command using my Events library, to notify that
      -- this autocmd callback has been called, allowing the autocmd
      -- to be deleted after the file has been deleted, since the ID
      -- of the autocmd is not known at this time.
      Events.fire_event({
        actor = "scratch-pad.lua",
        event = "BufDelete"
      })
    end
  })

  -- Receive the above custom event, delete the autocmd from its now known ID.
  Events.await_event({
    actor = "scratch-pad.lua",
    event = "BufDelete",
    callback = function()
      Safe.try(function()
        vim.api.nvim_del_autocmd(autocmd)
      end)

      return { expire = true }
    end
  })
end, {
  nargs = "?",
  desc = "Open a temporary scratch buffer in a split. Args: [extension] [split_type]"
})
