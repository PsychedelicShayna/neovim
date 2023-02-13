local status_ok, alpha = pcall(require, "alpha")
if not status_ok then
  return
end

local dashboard = require("alpha.themes.dashboard")
local banners = require("tables.banners")

dashboard.section.header.val = banners.hydra

-- dashboard.section.header.val = {
--   [[                  ___====-_  _-====___ ]],
--   [[            _--~~~#####//      \\#####~~~--_ ]],
--   [[          -~##########// (    ) \\##########~- ]],
--   [[        -############//  |\^^/|  \\############- ]],
--   [[      _~############//   (O||O)   \\############~_ ]],
--   [[     ~#############((     \\//     ))#############~ ]],
--   [[    -###############\\    (oo)    //###############- ]],
--   [[   -#################\\  /    \  //#################- ]],
--   [[  -###################\\/  ()  \//###################- ]],
--   [[ _#/|##########/\######(  (())  )######/\##########|\#_ ]],
--   [[ |/ |#/\#/\#/\/  \#/\##|  \()/  |##/\#/  \/\#/\#/\#| \| ]],
--   [[ `  |/  V  V  `   V  )||  |()|  ||(  V   '  V /\  \|  ' ]],
--   [[    `   `  `      `  / |  |()|  | \  '      '<||>  ' ]],
--   [[                    (  |  |()|  |  )\        /|/ ]],
--   [[                   __\ |__|()|__| /__\______/|/ ]],
--   [[                  (vvv(vvvv)(vvvv)vvv)______|/ ]],
-- }
-- [[╔══════════════════════════════════════════════════════╗  ]],
-- [[║     ___     ___    ___   __  __ /\_\    ___ ___      ║ ]],
-- [[║    / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\    ║ ]],
-- [[║   /\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \   ║ ]],
-- [[║   \ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\  ║ ]],
-- [[║    \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/  ║ ]],
-- [[╚══════════════════════════════════════════════════════╝]]
-- }

-- dashboard.section.header.val = {
--   [[                 *     ,MMMM.            * ]],
--   [[                      MMMM    . ]],
--   [[                     MM&& ]],
--   [[         *           MMM ]],
--   [[                     MMM8 ]],
--   [[                     'MMM&' ]],
--   [[                       'MMM8'      * ]],
--   [[              |\___/| ]],
--   [[              )     (             .              ' ]],
--   [[             =\     /= ]],
--   [[               )===(       * ]],
--   [[              /     \ ]],
--   [[              |     | ]],
--   [[             /       \ ]],
--   [[             \       / ]],
--   [[╔═══════════════( ( ═══════════════════════════════════╗  ]],
--   [[║     ___     ___) )  ____  __  __ /\_\    ___ ___     ║ ]],
--   [[║    / _ `\  / _(_(\ / __`\/\ \/\ \\/\ \  / __` __`\   ║ ]],
--   [[║   /\ \/\ \/\  ___//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \  ║ ]],
--   [[║   \ \_\ \_\ \____\\ \____/\ \___/  \ \_\ \_\ \_\ \_\ ║ ]],
--   [[║    \/_/\/_/\/____/ \/___/  \/__/    \/_/\/_/\/_/\/_/ ║ ]],
--   [[╚══════════════════════════════════════════════════════╝]]
-- }
-- [[      _/\_/\_/\__  _/_/\_/\_/\_/\_/\_/\_/\_/\_/\_ ]],
-- [[      |  |  |  |( (  |  |  |  |  |  |  |  |  |  | ]],
-- [[      |  |  |  | ) ) |  |  |  |  |  |  |  |  |  | ]],
-- [[      |  |  |  |(_(  |  |  |  |  |  |  |  |  |  | ]],

dashboard.section.buttons.val = {
  dashboard.button("e", "  New File", ":ene <BAR> startinsert <CR>"),
  dashboard.button("f", "  Find File", ":Telescope find_files <CR>"),
  dashboard.button("r", "  Recently Used Files", ":Telescope oldfiles <CR>"),
  dashboard.button("t", "  Live Grep", ":Telescope live_grep <CR>"),
  dashboard.button("p", "  Find Project", ":Telescope projects <CR>"),
  dashboard.button("c", "  Configuration", ":e ~/AppData/Local/nvim <CR>"),
  dashboard.button("q", "  Quit Neovim", ":qa<CR>"),
}

local function fortune_footer()
  local random_fortune_ok, random_fortune = pcall(require, "fortune.fortune")
  if not random_fortune_ok or not random_fortune then
    return "Failed to load fortune.lua"
  end

  local fortune_file, fortune = random_fortune.get_random_fortune()

  if not fortune then
    return fortune_file -- Should contain error message.
  else
    return "From: " .. fortune_file .. "\n" .. fortune
  end
end

dashboard.section.footer.val = fortune_footer()
dashboard.section.footer.opts.hl = "Type"
dashboard.section.header.opts.hl = "Include"
dashboard.section.buttons.opts.hl = "Keyword"
dashboard.opts.opts.noautocmd = true

alpha.setup(dashboard.opts)
