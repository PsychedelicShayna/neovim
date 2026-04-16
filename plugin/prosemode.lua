-- ~/.config/nvim/lua/plugins/prose-mode.lua   (or wherever you like)
local M = {}

local function get_alacritty_paths()
  local base = vim.fn.expand("~/.config/alacritty/")
  return {
    current = base .. "alacritty.toml",
    prose   = base .. "alacritty_prose.toml",
    backup  = base .. "alacritty_prose_original.toml",
  }
end

--- Safe file rename with existence check
local function safe_rename(src, dst)
  if vim.fn.filereadable(src) == 0 then
    return false, "Source does not exist: " .. src
  end
  local ok, err = pcall(os.rename, src, dst)
  if not ok then
    return false, "Rename failed: " .. tostring(err)
  end
  return true
end

--- Try to restore original alacritty config if we're in prose mode
--- (called on Neovim startup)
function M.ensure_normal_alacritty()
  local p = get_alacritty_paths()

  -- If backup exists → most reliable sign we did a switch
  if vim.fn.filereadable(p.backup) == 1 then
    safe_rename(p.current, p.prose)  -- put current (prose) aside
    safe_rename(p.backup, p.current) -- restore original
    vim.notify("Restored original alacritty.toml (backup was present)", vim.log.levels.WARN)
    return
  end

  -- Fallback heuristic: look for magic comment
  if vim.fn.filereadable(p.current) == 1 then
    local lines = vim.fn.readfile(p.current, '', 30) -- first ~30 lines only
    for _, line in ipairs(lines) do
      if line:match("^%s*#.*prose_mode") then
        safe_rename(p.current, p.prose)
        vim.notify("Detected prose alacritty.toml → restored original", vim.log.levels.WARN)
        return
      end
    end
  end
end

--- Switch alacritty config (only if files exist)
function M.toggle_alacritty_prose(enable)
  local p = get_alacritty_paths()

  if enable then
    -- Going → prose mode
    if vim.fn.filereadable(p.prose) == 0 then
      vim.notify("alacritty_prose.toml not found", vim.log.levels.ERROR)
      return false
    end
    -- Make backup only if it doesn't already exist
    if vim.fn.filereadable(p.backup) == 0 then
      safe_rename(p.current, p.backup)
    end
    safe_rename(p.prose, p.current)
    vim.notify("Using prose alacritty config", vim.log.levels.INFO)
  else
    -- Going → normal mode
    if vim.fn.filereadable(p.backup) == 1 then
      safe_rename(p.current, p.prose)  -- save current prose away
      safe_rename(p.backup, p.current) -- restore original
      vim.notify("Restored original alacritty config", vim.log.levels.INFO)
    else
      vim.notify("No alacritty backup found — cannot restore", vim.log.levels.WARN)
    end
  end
  return true
end

local ns = vim.api.nvim_create_namespace("prose_mode")


local function store_window_state(win)
  local buf = vim.api.nvim_win_get_buf(win)
  local opts = {
    wrap        = vim.wo[win].wrap,
    linebreak   = vim.wo[win].linebreak,
    breakindent = vim.wo[win].breakindent,
    showbreak   = vim.wo[win].showbreak,
    virtualedit = vim.wo[win].virtualedit,
    colorcolumn = vim.wo[win].colorcolumn,
    scrolloff   = vim.wo[win].scrolloff,
    textwidth   = vim.bo[buf].textwidth,
  }

  vim.api.nvim_buf_set_var(buf, "prose_mode_prev", opts)
end

local function restore_window_state(win)
  local buf = vim.api.nvim_win_get_buf(win)
  local ok, prev = pcall(vim.api.nvim_buf_get_var, buf, "prose_mode_prev")
  if not ok or type(prev) ~= "table" then return end

  vim.wo[win].wrap        = prev.wrap
  vim.wo[win].linebreak   = prev.linebreak
  vim.wo[win].breakindent = prev.breakindent
  vim.wo[win].showbreak   = prev.showbreak
  vim.wo[win].virtualedit = prev.virtualedit
  vim.wo[win].colorcolumn = prev.colorcolumn
  vim.wo[win].scrolloff   = prev.scrolloff
  vim.bo[buf].textwidth   = prev.textwidth

  -- Clean up (optional but nice)
  pcall(vim.api.nvim_buf_del_var, buf, "prose_mode_prev")
end

local function set_prose_keymaps(win, enable)
  local mode = { "n", "v" }
  local opts = { buffer = vim.api.nvim_win_get_buf(win), nowait = true }

  if enable then
    vim.keymap.set(mode, "j", "gj", opts)
    vim.keymap.set(mode, "k", "gk", opts)
    vim.keymap.set(mode, "0", "g0", opts)
    vim.keymap.set(mode, "^", "g^", opts)
    vim.keymap.set(mode, "$", "g$", opts)
  else
    vim.keymap.del(mode, "j", opts)
    vim.keymap.del(mode, "k", opts)
    vim.keymap.del(mode, "0", opts)
    vim.keymap.del(mode, "^", opts)
    vim.keymap.del(mode, "$", opts)
  end
end

function M.toggle_prose_column_lock(buf, on)
  if vim.g.prose_column_lock == nil then
    vim.g.prose_column_lock = false
  end

  if on == nil then
    on = not vim.g.prose_column_lock
  end

  if vim.g.prose_column_acmd then
    vim.api.nvim_del_autocmd(vim.g.prose_column_acmd)
    vim.g.prose_column_acmd = nil
  end

  if on == false then
    vim.g.prose_column_lock = false
    return
  end

  -- on is true, implicit flow condition

  local acmdnr = vim.api.nvim_create_autocmd("VimResized", {
    callback = function(o)
      local columns = (o.buf and vim.b[o.buf].prose_columns) or vim.g.prose_columns or 100

      if not tonumber(columns) then
        columns = 100
      end

      vim.defer_fn(function()
        vim.api.nvim_set_option_value(
          "columns",
          tonumber(columns),
          { scope = "global" }
        )
      end, 500)
    end
  })

  vim.g.prose_column_acmd = acmdnr
  vim.g.prose_column_lock = true
end

function M.toggle(win, force_state, columns)
  win = win or 0
  if not vim.api.nvim_win_is_valid(win) then return end

  local buf = vim.api.nvim_win_get_buf(win)
  local is_prose = vim.b[buf].prose_mode == true

  -- Toggle by default if force_state is nil
  local new_state = not is_prose

  if force_state == 'on' then new_state = true end
  if force_state == 'off' then new_state = false end

  if new_state then
    -- ── ON ───────────────────────────────────────────────
    vim.b[buf].prose_columns = (columns and tonumber(columns)) or 100

    store_window_state(win)

    vim.wo[win].wrap        = true
    vim.wo[win].linebreak   = true
    vim.wo[win].breakindent = true
    vim.wo[win].showbreak   = "↳ "
    vim.wo[win].virtualedit = "all"
    vim.wo[win].colorcolumn = "70,80,90" -- tostring(vim.b[buf].prose_columns - 1)
    vim.bo[buf].textwidth   = vim.b[buf].prose_columns - 1
    vim.wo[win].scrolloff   = 8

    set_prose_keymaps(win, true)
    M.toggle_alacritty_prose(true)
    M.toggle_prose_column_lock(buf, true)

    vim.b[buf].prose_mode = true
    vim.notify("Prose mode → ON (" .. vim.b[buf].prose_columns .. ")", vim.log.levels.INFO)
  else
    -- ── OFF ──────────────────────────────────────────────
    restore_window_state(win)
    set_prose_keymaps(win, false)
    M.toggle_alacritty_prose(false)
    M.toggle_prose_column_lock(buf, false)

    vim.b[buf].prose_mode = false
    -- pcall(vim.api.nvim_buf_del_var, buf, "prose_columns")
    vim.notify("Prose mode → OFF", vim.log.levels.INFO)
  end
end

-- ── Commands ────────────────────────────────────────────────────────

vim.api.nvim_create_user_command("Prose", function(opts)
  local mode = nil
  local cols = nil

  vim.notify(vim.inspect(opts.fargs))

  if opts.fargs[1] then
    local valid_mode = opts.fargs[1] == "on" or opts.fargs[1] == "off"
    if valid_mode then
      mode = opts.fargs[1]
    else
      vim.notify("Usage :Prose [on|off] [columns]", vim.log.levels.WARN)
      return
    end
  end

  if opts.fargs[2] then
    local valid_cols = opts.fargs[2]:match("^%d+$")
    if valid_cols then
      cols = tonumber(opts.fargs[2])
    else
      vim.notify("Usage :Prose [on|off] [columns] -- invalid number for cols " .. vim.inspect(opts.fargs[2]),
        vim.log.levels.WARN)
      return
    end
  end

  M.toggle(0, mode, cols)
end, {
  nargs = "*",
  desc = "Toggle prose writing mode",
})

-- Try to fix broken alacritty config on every startup
vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = M.ensure_normal_alacritty,
})

return M










--
-- local M = {
--   autocmd = nil,
--   prev = nil
-- }
--
-- -- Use alternate config file for alacritty called alacritty_prose.toml
-- -- rename to alacritty.toml, and when toggled off again, rename back to
-- -- alacrtty_prose.toml, pputting the original back in place. As a fail
-- -- safe, upon launching Neovim, check if alacritty.toml contains the
-- -- comment #prose_mode, and if so, reset it back to alacritty_prose.toml
-- -- and move the original back to alacritty.toml. Or better yet, if the
-- -- file alacritty_prose_original.toml exists, move it back to alacritty.toml
-- -- and move that back to alacritty_prose.toml
-- function M.alacritty_prose()
--   local alacritty_path = os.getenv("HOME") .. "/.config/alacritty/"
--   local prose_file = alacritty_path .. "alacritty_prose.toml"
--   local original_file = alacritty_path .. "alacritty.toml"
--   local backup_file = alacritty_path .. "alacritty_prose_original.toml"
--
--   local prose_mode = false
--
--   local f = io.open(original_file, "r")
--   if f then
--     for line in f:lines() do
--       if line:find("#prose_mode") then
--         prose_mode = true
--         break
--       end
--     end
--     f:close()
--   end
--
--   if prose_mode then
--     os.rename(original_file, prose_file)
--     if os.rename(backup_file, original_file) == nil then
--       vim.notify("No backup file found for alacritty config.")
--     end
--   else
--     os.rename(original_file, backup_file)
--     os.rename(prose_file, original_file)
--   end
-- end
--
-- function M.store_curr(win)
--   if win == nil then
--     win = 0
--   end
--
--   local buf = vim.api.nvim_win_get_buf(win)
--
--   local prev_wrap = vim.api.nvim_get_option_value("wrap", { scope = "local", win = win })
--   local prev_linebreak = vim.api.nvim_get_option_value("linebreak", { scope = "local", win = win })
--   local prev_showbreak = vim.api.nvim_get_option_value("showbreak", { scope = "local", win = win })
--   local prev_virtualedit = vim.api.nvim_get_option_value("virtualedit", { scope = "local", win = win })
--   local prev_colorcolumn = vim.api.nvim_get_option_value("colorcolumn", { scope = "local", win = win })
--   local prev_textwidth = vim.api.nvim_get_option_value("textwidth", { scope = "local", buf = buf })
--   local prev_scrolloff = vim.api.nvim_get_option_value("scrolloff", { scope = "local", win = win })
--
--   -- vim.api.nvim_buf_set_var(buf, "__prose_mode_prev_
--
--   vim.api.nvim_buf_set_var(buf, "__prose_mode_prev_wrap", prev_wrap)
--   vim.api.nvim_buf_set_var(buf, "__prose_mode_prev_linebreak", prev_linebreak)
--   vim.api.nvim_buf_set_var(buf, "__prose_mode_prev_showbreak", prev_showbreak)
--   vim.api.nvim_buf_set_var(buf, "__prose_mode_prev_virtualedit", prev_virtualedit)
--   vim.api.nvim_buf_set_var(buf, "__prose_mode_prev_colorcolumn", prev_colorcolumn)
--   vim.api.nvim_buf_set_var(buf, "__prose_mode_prev_textwidth", prev_textwidth)
--   vim.api.nvim_buf_set_var(buf, "__prose_mode_prev_scrolloff", prev_scrolloff)
-- end
--
-- function M.restore_prev(win)
--   if win == nil then win = 0 end
--
--   local buf           = vim.api.nvim_win_get_buf(win)
--
--   local ok, prev_wrap = pcall(vim.api.nvim_buf_get_var, buf, "__prose_mode_prev_wrap")
--   if not ok then return nil end
--   local ok, prev_linebreak = pcall(vim.api.nvim_buf_get_var, buf, "__prose_mode_prev_linebreak")
--   if not ok then return nil end
--   local ok, prev_showbreak = pcall(vim.api.nvim_buf_get_var, buf, "__prose_mode_prev_showbreak")
--   if not ok then return nil end
--   local ok, prev_virtualedit = pcall(vim.api.nvim_buf_get_var, buf, "__prose_mode_prev_virtualedit")
--   if not ok then return nil end
--   local ok, prev_colorcolumn = pcall(vim.api.nvim_buf_get_var, buf, "__prose_mode_prev_colorcolumn")
--   if not ok then return nil end
--   local ok, prev_textwidth = pcall(vim.api.nvim_buf_get_var, buf, "__prose_mode_prev_textwidth")
--   if not ok then return nil end
--   local ok, prev_scrolloff = pcall(vim.api.nvim_buf_get_var, buf, "__prose_mode_prev_scrolloff")
--
--
--   vim.api.nvim_set_option_value("wrap", prev_wrap, { scope = "local", win = win })
--   vim.api.nvim_set_option_value("linebreak", prev_linebreak, { scope = "local", win = win })
--   vim.api.nvim_set_option_value("showbreak", prev_showbreak, { scope = "local", win = win })
--   vim.api.nvim_set_option_value("virtualedit", prev_virtualedit, { scope = "local", win = win })
--   vim.api.nvim_set_option_value("colorcolumn", prev_colorcolumn, { scope = "local", win = win })
--   vim.api.nvim_set_option_value("textwidth", prev_textwidth, { scope = "local", buf = buf })
--   vim.api.nvim_set_option_value("scrolloff", prev_scrolloff, { scope = "local", win = win })
-- end
--
-- function M.toggle_prose_mode(opts, win)
--   if win == nil then win = 0 end
--
--   local exists, original_state = pcall(vim.api.nvim_buf_get_var, win, "_prose_mode")
--
--   if not exists then
--     local ok, _ = pcall(vim.api.nvim_buf_set_var, win, "_prose_mode", true)
--     if not ok then vim.notify("cannot set _prose_mode/" .. ok) end
--     return
--   end
--
--   local columns = 80
--   local new_state = not original_state
--
--   if #opts.args >= 1 then
--     local requested = opts.args[1]
--
--     if requested == "on" then
--       new_state = true
--     elseif requested == "off" then
--       new_state = false
--     end
--
--     if #opts.args >= 2 then
--       columns = opts.args[2]
--     end
--   end
--
--   columns = 80
--
--   vim.api.nvim_buf_set_var(win, "_prose_mode", new_state)
--   vim.api.nvim_buf_set_var(win, "_prose_mode_cols", columns)
--
--
--   if new_state and not original_state then
--     local buf = vim.api.nvim_win_get_buf(win)
--
--     if M.autocmd ~= nil then
--       vim.api.nvim_del_autocmd(M.autocmd)
--       M.autocmd = nil
--     end
--
--     M.store_curr()
--     vim.api.nvim_set_option_value("wrap", true, { scope = "local", win = win })
--     vim.api.nvim_set_option_value("linebreak", true, { scope = "local", win = win })
--     vim.api.nvim_set_option_value("breakindent", true, { scope = "local", win = win })
--     vim.api.nvim_set_option_value("showbreak", "↳", { scope = "local", win = win })
--     vim.api.nvim_set_option_value("virtualedit", "all", { scope = "local", win = win })
--     vim.api.nvim_set_option_value("colorcolumn", "80,90", { scope = "local", win = win })
--     vim.api.nvim_set_option_value("textwidth", 79, { scope = "local", buf = buf })
--     vim.api.nvim_set_option_value("scrolloff", 5, { scope = "local", win = win })
--     vim.keymap.set({ 'n', 'v' }, 'j', 'gj')
--     vim.keymap.set({ 'n', 'v' }, 'k', 'gk')
--     vim.notify("ProseMode Toggled: " .. vim.inspect(new_state))
--
--     vim.api.nvim_buf_set_var(buf, "_prose_mode", true)
--     vim.api.nvim_buf_set_var(buf, "_prose_mode_cols", 80)
--
--     M.autocmd = vim.api.nvim_create_autocmd({ "VimResized" }, {
--       callback = function(o)
--         vim.notify(vim.inspect(o))
--
--         local prose_mode = vim.api.nvim_buf_get_var(o.buf, "_prose_mode")
--         local prose_cols = vim.api.nvim_buf_get_var(o.buf, "_prose_mode_cols")
--
--         if prose_mode then
--           vim.defer_fn(function()
--             vim.api.nvim_set_option_value("columns", prose_cols, { scope = "global" })
--           end, 250)
--         end
--
--         -- if prose_mode then
--         -- end
--
--         --   vim.api.nvim_set_option_value("columns", prose_cols, { scope = "global" })
--       end
--     })
--   elseif not new_state and original_state then
--     local buf = vim.api.nvim_win_get_buf(win)
--
--
--
--     vim.api.nvim_set_option_value("wrap", false, { scope = "local", win = win })
--     vim.api.nvim_set_option_value("linebreak", false, { scope = "local", win = win })
--     vim.api.nvim_set_option_value("breakindent", false, { scope = "local", win = win })
--     vim.api.nvim_set_option_value("showbreak", "", { scope = "local", win = win })
--     vim.api.nvim_set_option_value("virtualedit", "none", { scope = "local", win = win })
--     vim.api.nvim_set_option_value("colorcolumn", "80,120", { scope = "local", win = win })
--     vim.api.nvim_set_option_value("textwidth", 79, { scope = "local", buf = buf })
--     vim.api.nvim_set_option_value("scrolloff", 5, { scope = "local", win = win })
--     M.restore_prev()
--
--     if M.autocmd then
--       vim.api.nvim_del_autocmd(M.autocmd)
--       M.autocmd = nil
--     end
--
--     vim.api.nvim_buf_set_var(buf, "_prose_mode", false)
--     vim.api.nvim_buf_set_var(buf, "_prose_mode_cols", 80)
--
--     vim.keymap.set({ 'n', 'v' }, 'j', 'j')
--     vim.keymap.set({ 'n', 'v' }, 'k', 'k')
--
--     vim.notify("ProseMode Toggled: " .. vim.inspect(new_state))
--   end
-- end
--
-- vim.api.nvim_create_user_command("Prose", function(opts)
--   M.toggle_prose_mode(opts, 0)
-- end, {})
--
-- return M
