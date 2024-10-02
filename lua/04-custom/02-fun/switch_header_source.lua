local function switch_header_source()
end

vim.api.nvim_create_user_command("SwitchHeaderSource", function()
  local current_file = vim.api.nvim_buf_get_name(0)

  local file_name = vim.fn.expand("%:t")
  local file_extension = vim.fn.expand("%:e")

  local file_name_without_extension = vim.fn.expand("%:t:r")

  local header_extensions = { "h", "hpp", "hh", "hxx" }
  local source_extensions = { "c", "cpp", "cc", "cxx" }

  local conversion = {
    h   = "c",
    hh  = "cc",
    hpp = "cpp",
    hxx = "cxx",

    c   = "h",
    cc  = "hh",
    cpp = "hpp",
    cxx = "hxx",
  }

  local new_extension = conversion[file_extension]

  if new_extension == nil then
    vim.notify("Cannot find the opposite extension for: " .. file_extension)
    return
  end

  local new_file_name = file_name_without_extension .. "." .. new_extension
  local new_file_path = vim.fn.expand("%:p:h") .. "/" .. new_file_name
  local new_file_exists = vim.fn.filereadable(new_file_path) == 1


  for _, buffer in pairs(vim.api.nvim_list_bufs()) do
    local buffer_name = vim.api.nvim_buf_get_name(buffer)

    if buffer_name == new_file_name then
      is_open = true
      break
    end
  end


  -- if new_file_exists then
  --
  -- else
  --   vim.notify("Cannot find file: " .. new_file_name)
  -- end
  --
end, {})


vim.api.nvim_create_autocmd({ "BufEnter" }, {
  pattern = { "*.cpp", "*.hpp", "*.c", "*.h", "*.cc", "*.hh", "*.cxx", "*.hxx" },
  callback = function(opts)
    local buffer = opts.buf
    local file_name = opts.file

    local full_path = vim.api.nvim_buf_get_name(buffer)

    vim.api.nvim_buf_set_keymap(buffer, "n",
      "<leader>ls", "<cmd>SwitchHeaderSource<cr>",
      { noremap = true, silent = true }
    )

    Events.await_event {
      actor = "which-key",
      event = "configured",
      retroactive = true,
      callback = function()
        Safe.import_then('which-key', function(which_key)
          which_key.register(
            { "Switch Header/Source" },
            { prefix = "<leader>ls", mode = "n", buffer = buffer }
          )
        end)
      end
    }
  end
})
