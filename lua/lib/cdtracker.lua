local tracking_buffer = nil
local tracker_autocmd_id = nil

local function refresh_buffer_contents(_)
  if not tracking_buffer or not tracker_autocmd_id then
    return
  end

  local cwd = vim.fn.getcwd()
  local cmd_output_lines = vim.fn.systemlist('lsd -1 "' .. cwd .. '"')

  local final_message = { "null message" }

  if type(cmd_output_lines) == 'table' then
    final_message = cmd_output_lines
  else
    final_message = {
      "Neovim Lua Error: the output returned by the command was not a table of lines, but a " ..
      type(cmd_output_lines) .. " instead.",
      "Inspection: " .. vim.insepct(cmd_output_lines)
    }
  end

  vim.api.nvim_buf_set_lines(tracking_buffer, 0, -1, false, final_message)
end

local function reset_tracking_buffer()
  if type(tracker_autocmd_id) == 'number' then
    vim.api.nvim_del_autocmd(tracker_autocmd_id)
  end

  tracking_buffer = nil
  tracker_autocmd_id = nil
end

vim.api.nvim_create_user_command("CdTrackerSetBuffer",
  function()
    local current_buffer = vim.api.nvim_get_current_buf()
    tracking_buffer = current_buffer -- Readability

    tracker_autocmd_id = vim.api.nvim_create_autocmd({ "DirChanged" }, {
      callback = function(event_data)
        refresh_buffer_contents(event_data)
      end
    })
  end, {})


vim.api.nvim_create_user_command("CdTrackerClear", function()
  reset_tracking_buffer()
end, {})

vim.api.nvim_create_user_command("CdTrackerRefresh", function()
  refresh_buffer_contents()
end, {})
