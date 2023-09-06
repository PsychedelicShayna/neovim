local events = require("prelude").events

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
          ["<C-n>"] = actions.cycle_history_next,
          ["<C-p>"] = actions.cycle_history_prev,

          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,

          ["<C-c>"] = actions.close,

          ["<CR>"] = actions.select_default,
          ["<C-x>"] = actions.select_horizontal,
          ["<C-v>"] = actions.select_vertical,
          ["<C-t>"] = actions.select_tab,

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
          ["<esc>"] = actions.close,
          ["<CR>"] = actions.select_default,
          ["<C-x>"] = actions.select_horizontal,
          ["<C-v>"] = actions.select_vertical,
          ["<C-t>"] = actions.select_tab,

          ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
          ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
          ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
          ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,

          ["j"] = actions.move_selection_next,
          ["k"] = actions.move_selection_previous,
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,

          ["H"] = actions.move_to_top,
          ["M"] = actions.move_to_middle,
          ["L"] = actions.move_to_bottom,

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
end

local function which_key_mappings()
  require("which-key").register({
    name = "Find...",
    f = {
      "<cmd>lua require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({ previewer = false }))<cr>",
      "Files" },
    F = { "<cmd>Telescope find_files<cr>", "Files (+ Preview)" },
    G = { "<cmd>Telescope live_grep<cr>", "Live Grep (+ Preview)" },
    g = {
      "<cmd>lua require('telescope.builtin').live_grep(require('telescope.themes').get_dropdown({previewer=false}))<cr>",
      "File Contents (Live Grep)" },
    r = {
      "<cmd>lua require('telescope.builtin').oldfiles(require('telescope.themes').get_dropdown{previewer = false})<cr>",
      "Recent Files" },
    R = { "<cmd>Telescope oldfiles<cr>", "Recent Files (+Preview)" },
    b = {
      "<cmd>lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown{previewer = false})<cr>",
      "Buffers" },
    B = { "<cmd>Telescope buffers<cr>", "Buffers" },
    p = { "<cmd>Telescope projects<cr>", "Projects" },
    d = { "<cmd>Telescope diagnostics<cr>", "Diagnostic" },
    s = { "<cmd>Telescope symbols<cr>", "Symbols" },
    c = { "<cmd>Telescope commands<cr>", "Commands" },
    j = { "<cmd>Telescope jumplist<cr>", "Jumplist" },
    o = {
      name = "Obscure...",
      v = { "<cmd>Telescope vim_options<cr>", "ViM Options" },
      o = { "<cmd>Telescope colorscheme<cr>", "Colorschemes" },
      k = { "<cmd>Telescope keymaps<cr>", "Keybindings" },
      s = { "<cmd>Telescope search_history<cr>", "Search, History" },
      c = { "<cmd>Telescope command_history<cr>", "Command History" },
      a = { "<cmd>Telescope autocommands<cr>", "AutoCommands" },
    },
  }, {
    prefix = "<leader>f",
    mode = "n"
  })
end

return {
  "nvim-telescope/telescope.nvim",
  lazy = true,
  cmd = "Telescope",
  init = function()
    events.run_after(
      "configured",
      "which-key",
      function()
        which_key_mappings()
      end,
      true)
  end,
  config = config
}
