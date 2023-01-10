local status_ok, alpha = pcall(require, "alpha")
local fortune_ok, fortune = pcall(require, "plugins.alpha-nvim.fortune")


local fortune_ok = true

if not status_ok then
  return
end

local dashboard = require "alpha.themes.dashboard"

dashboard.section.header.val = {
  [[                  ___====-_  _-====___ ]],
  [[           _--~~~#####// '  ` \\#####~~~--_ ]],
  [[         -~##########// (    ) \\##########~-_ ]],
  [[        -############//  |\^^/|  \\############- ]],
  [[      _~############//   (O||O)   \\############~_ ]],
  [[     ~#############((     \\//     ))#############~ ]],
  [[    -###############\\    (oo)    //###############- ]],
  [[   -#################\\  / `' \  //#################- ]],
  [[  -###################\\/  ()  \//###################- ]],
  [[ _#/|##########/\######(  (())  )######/\##########|\#_ ]],
  [[ |/ |#/\#/\#/\/  \#/\##|  \()/  |##/\#/  \/\#/\#/\#| \| ]],
  [[ `  |/  V  V  `   V  )||  |()|  ||(  V   '  V /\  \|  ' ]],
  [[    `   `  `      `  / |  |()|  | \  '      '<||>  ' ]],
  [[                    (  |  |()|  |  )\        /|/ ]],
  [[                   __\ |__|()|__| /__\______/|/ ]],
  [[                  (vvv(vvvv)(vvvv)vvv)______|/ ]],
  [[╔══════════════════════════════════════════════════════╗  ]],
  [[║     ___     ___    ___   __  __ /\_\    ___ ___      ║ ]],
  [[║    / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\    ║ ]],
  [[║   /\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \   ║ ]],
  [[║   \ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\  ║ ]],
  [[║    \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/  ║ ]],
  [[╚══════════════════════════════════════════════════════╝]]
}

dashboard.section.buttons.val = {
  dashboard.button("e", "  New File", ":ene <BAR> startinsert <CR>"),
  dashboard.button("f", "  Find File", ":Telescope find_files <CR>"),
  dashboard.button("r", "  Recently Used Files", ":Telescope oldfiles <CR>"),
  dashboard.button("t", "  Live Grep", ":Telescope live_grep <CR>"),
  dashboard.button("p", "  Find Project", ":Telescope projects <CR>"),
  dashboard.button("c", "  Configuration", ":e ~/AppData/Local/nvim <CR>"),
  dashboard.button("q", "  Quit Neovim", ":qa<CR>"),
}

local function footer()
  if not fortune_ok then
    return "How unfortunate..."
  end

  local fortune_text, fortune_file = GetRandomFortune(nil, 10)
  return "From " .. fortune_file .. ": \n" .. fortune_text
  -- return "fixed"
end

dashboard.section.footer.val = footer()

dashboard.section.footer.opts.hl = "Type"
dashboard.section.header.opts.hl = "Include"
dashboard.section.buttons.opts.hl = "Keyword"
dashboard.opts.opts.noautocmd = true

-- vim.cmd([[autocmd User AlphaReady echo 'ready']])
alpha.setup(dashboard.opts)
