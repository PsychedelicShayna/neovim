local config = function()
  local telescope = require "telescope"
  local actions = require "telescope.actions"

  telescope.setup {
    defaults = {
      prompt_prefix = "  ",
      selection_caret = "  ",
      path_display = { "smart" },
      mappings = {
        i = {
          ["<Up>"] = actions.cycle_history_next,
          ["<Down>"] = actions.cycle_history_prev,

          ["<A-j>"] = actions.move_selection_next,
          ["<A-k>"] = actions.move_selection_previous,
          ["<A-J>"] = actions.toggle_selection + actions.move_selection_worse,
          ["<A-K>"] = actions.toggle_selection + actions.move_selection_better,
          ["<A-L>"] = actions.toggle_selection,

          ["<A-q>"] = actions.close,

          ["<A-l>"] = actions.select_default,
          ["<A-x>"] = actions.select_horizontal,
          ["<A-v>"] = actions.select_vertical,
          ["<A-t>"] = actions.select_tab,

          ["<C-u>"] = actions.preview_scrolling_up,
          ["<C-d>"] = actions.preview_scrolling_down,

          ["<PageUp>"] = actions.results_scrolling_up,
          ["<PageDown>"] = actions.results_scrolling_down,

          ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
          ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
          ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
          ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
          ["<C-l>"] = actions.complete_tag,
          ["<C-_>"] = actions.which_key, -- keys from pressing <C-/>
        },

        n = {
          ["q"] = actions.close,
          ["l"] = actions.select_default,
          ["<C-x>"] = actions.select_horizontal,
          ["<C-v>"] = actions.select_vertical,
          ["<C-t>"] = actions.select_tab,

          ["J"] = actions.toggle_selection + actions.move_selection_worse,
          ["K"] = actions.toggle_selection + actions.move_selection_better,
          ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
          ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,

          ["j"] = actions.move_selection_next,
          ["k"] = actions.move_selection_previous,
          ["<Space>"] = actions.toggle_selection,

          ["<Down>"] = actions.move_selection_next,
          ["<Up>"] = actions.move_selection_previous,
          ["gg"] = actions.move_to_top,
          ["G"] = actions.move_to_bottom,

          ["<C-u>"] = actions.preview_scrolling_up,
          ["<C-d>"] = actions.preview_scrolling_down,

          ["<PageUp>"] = actions.results_scrolling_up,
          ["<PageDown>"] = actions.results_scrolling_down,

          ["?"] = actions.which_key,
        },
      },
    },
    pickers = {
      diagnostics = {
        theme = "ivy",
        previewer = false,
        layout_config = {
          height = 10,
        }
      }
    },

    preview = {
      filesize_limit = 5,
      treesitter = false
    }
  }

  Events.fire_event {
    actor = "telescope",
    event = "configured"
  }
end

local function which_key_mappings()
  require("which-key").add {
    { "<leader>f",   group = "[Find]" },
    { "<leader>fB",  "<cmd>Telescope buffers<cr>",                                                                                          desc = "Buffers" },
    { "<leader>fF",  "<cmd>Telescope find_files<cr>",                                                                                       desc = "Files (+ Preview)" },
    { "<leader>fG",  "<cmd>Telescope live_grep<cr>",                                                                                        desc = "Live Grep (+ Preview)" },
    { "<leader>fh",  "<cmd>Telescope oldfiles<cr>",                                                                                         desc = "Historial Files" },
    { "<leader>fH",  "<cmd>lua require('telescope.builtin').oldfiles(require('telescope.themes').get_dropdown{previewer = true})<cr>",                                                                                         desc = "Historial Files" },
    { "<leader>fb",  "<cmd>lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown{previewer = false})<cr>",      desc = "Buffers" },
    { "<leader>fc",  "<cmd>Telescope commands<cr>",                                                                                         desc = "Commands" },
    { "<leader>fd",  "<cmd>Telescope diagnostics<cr>",                                                                                      desc = "Diagnostic" },
    { "<leader>ff",  "<cmd>lua require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({ previewer = false }))<cr>", desc = "Files" },
    { "<leader>fg",  "<cmd>lua require('telescope.builtin').live_grep(require('telescope.themes').get_dropdown({previewer=false}))<cr>",    desc = "File Contents (Live Grep)" },
    { "<leader>fj",  "<cmd>Telescope jumplist<cr>",                                                                                         desc = "Jumplist" },
    { "<leader>fo",  group = "[Obscure]" },
    { "<leader>foa", "<cmd>Telescope autocommands<cr>",                                                                                     desc = "AutoCommands" },
    { "<leader>foc", "<cmd>Telescope command_history<cr>",                                                                                  desc = "Command History" },
    { "<leader>fok", "<cmd>Telescope keymaps<cr>",                                                                                          desc = "Keybindings" },
    { "<leader>foo", "<cmd>Telescope colorscheme<cr>",                                                                                      desc = "Colorschemes" },
    { "<leader>fos", "<cmd>Telescope search_history<cr>",                                                                                   desc = "Search, History" },
    { "<leader>fov", "<cmd>Telescope vim_options<cr>",                                                                                      desc = "ViM Options" },
    { "<leader>fp",  "<cmd>Telescope projects<cr>",                                                                                         desc = "Projects" },
    { "<leader>fr",  "<cmd>lua require('telescope.builtin').oldfiles(require('telescope.themes').get_dropdown{previewer = false})<cr>",     desc = "Recent Files" },
    { "<leader>fs",  "<cmd>Telescope symbols<cr>",                                                                                          desc = "Symbols" },
    --
    -- name = "[Find]",
    -- f = {
    --   "<cmd>lua require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({ previewer = false }))<cr>",
    --   "Files" },
    -- F = { "<cmd>Telescope find_files<cr>", "Files (+ Preview)" },
    -- G = { "<cmd>Telescope live_grep<cr>", "Live Grep (+ Preview)" },
    -- g = {
    --   "<cmd>lua require('telescope.builtin').live_grep(require('telescope.themes').get_dropdown({previewer=false}))<cr>",
    --   "File Contents (Live Grep)" },
    -- r = {
    --   "<cmd>lua require('telescope.builtin').oldfiles(require('telescope.themes').get_dropdown{previewer = false})<cr>",
    --   "Recent Files" },
    -- R = { "<cmd>Telescope oldfiles<cr>", "Recent Files (+Preview)" },
    -- b = {
    --   "<cmd>lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown{previewer = false})<cr>",
    --   "Buffers" },
    -- B = { "<cmd>Telescope buffers<cr>", "Buffers" },
    -- p = { "<cmd>Telescope projects<cr>", "Projects" },
    -- d = { "<cmd>Telescope diagnostics<cr>", "Diagnostic" },
    -- s = { "<cmd>Telescope symbols<cr>", "Symbols" },
    -- c = { "<cmd>Telescope commands<cr>", "Commands" },
    -- j = { "<cmd>Telescope jumplist<cr>", "Jumplist" },
    -- o = {
    --   name = "[Obscure]",
    --   v = { "<cmd>Telescope vim_options<cr>", "ViM Options" },
    --   o = { "<cmd>Telescope colorscheme<cr>", "Colorschemes" },
    --   k = { "<cmd>Telescope keymaps<cr>", "Keybindings" },
    --   s = { "<cmd>Telescope search_history<cr>", "Search, History" },
    --   c = { "<cmd>Telescope command_history<cr>", "Command History" },
    --   a = { "<cmd>Telescope autocommands<cr>", "AutoCommands" },
    -- },
  }
  -- }, {
  --   prefix = "<leader>f",
  --   mode = "n"
  -- })
end

return {
  "nvim-telescope/telescope.nvim",
  lazy = true,
  cmd = "Telescope",
  init = function()
    Events.await_event {
      event = "configured",
      actor = "which-key",
      retroactive = true,
      callback = function()
        which_key_mappings()
      end
    }
  end,
  config = config
}
