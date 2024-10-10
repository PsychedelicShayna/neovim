local config = function()
    local telescope = require "telescope"
    local actions = require "telescope.actions"

    telescope.setup {
        defaults = {
            prompt_prefix = " ",
            selection_caret = " > ",
            path_display = { "smart" },
            mappings = {
                i = {
                    ["<Up>"]    = actions.cycle_history_next,
                    ["<Down>"]  = actions.cycle_history_prev,

                    -- Alt is the easiest key to access with your thumb, so commonly
                    -- repeated keystrokes should default to Alt when possible.
                    ["<A-j>"]   = actions.move_selection_next,
                    ["<A-k>"]   = actions.move_selection_previous,

                    -- Tab should not behave any differently than cycling through the
                    -- results with Alt-j/k as one would expect Tab to do the same.
                    ["<Tab>"]   = actions.move_selection_next,
                    ["<S-Tab>"] = actions.move_selection_previous,

                    -- When one intends on selecting multiple results in a row, then it
                    -- doesn't become a problem to hold Shift while doing so. In fact,
                    -- it's made easier by just activating CapsLock.
                    ["<A-J>"]   = actions.toggle_selection + actions.move_selection_worse,
                    ["<A-K>"]   = actions.toggle_selection + actions.move_selection_better,

                    ["<A-q>"]   = actions.close,

                    -- Selecting a result is a one step operation, whereas selecting is
                    -- a multi-step operation. Therefore if one has to hold Shift while
                    -- holding Alt to navigate up and down with k and j, then it should
                    -- be when opening the selected file, not when marking seveal files.
                    ["<A-L>"]   = actions.select_default,
                    ["<A-l>"]   = actions.toggle_selection,

                    ["<A-x>"]   = actions.select_horizontal,
                    ["<A-v>"]   = actions.select_vertical,
                    ["<A-t>"]   = actions.select_tab,

                    ["<C-U>"]   = actions.preview_scrolling_up,
                    ["<C-D>"]   = actions.preview_scrolling_down,
                    ["<C-u>"]   = actions.results_scrolling_up,
                    ["<C-d>"]   = actions.results_scrolling_down,

                    ["<C-q>"]   = actions.send_to_qflist + actions.open_qflist,
                    ["<M-q>"]   = actions.send_selected_to_qflist + actions.open_qflist,
                    ["<C-l>"]   = actions.complete_tag,
                    ["<C-_>"]   = actions.which_key, -- keys from pressing <C-/>
                },

                n = {
                    ["q"]          = actions.close,
                    ["l"]          = actions.select_default,
                    ["<C-x>"]      = actions.select_horizontal,
                    ["<C-v>"]      = actions.select_vertical,
                    ["<C-t>"]      = actions.select_tab,

                    ["J"]          = actions.toggle_selection + actions.move_selection_worse,
                    ["K"]          = actions.toggle_selection + actions.move_selection_better,
                    ["<C-q>"]      = actions.send_to_qflist + actions.open_qflist,
                    ["<M-q>"]      = actions.send_selected_to_qflist + actions.open_qflist,

                    ["j"]          = actions.move_selection_next,
                    ["k"]          = actions.move_selection_previous,
                    ["<Space>"]    = actions.toggle_selection,

                    ["<Down>"]     = actions.move_selection_next,
                    ["<Up>"]       = actions.move_selection_previous,
                    ["gg"]         = actions.move_to_top,
                    ["G"]          = actions.move_to_bottom,

                    ["<C-U>"]      = actions.preview_scrolling_up,
                    ["<C-D>"]      = actions.preview_scrolling_down,
                    ["<C-u>"]      = actions.results_scrolling_up,
                    ["<C-d>"]      = actions.results_scrolling_down,

                    ["<PageUp>"]   = actions.results_scrolling_up,
                    ["<PageDown>"] = actions.results_scrolling_down,

                    ["?"]          = actions.which_key,
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
        { "<leader>fh",  "<cmd>Telescope help_tags<cr>",                                                                                        desc = "Help Tags" },
        { "<leader>fb",  "<cmd>lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown{previewer = false})<cr>",      desc = "Buffers" },
        { "<leader>f:",  "<cmd>Telescope commands<cr>",                                                                                         desc = "User Defined Commands" },
        { "<leader>fC",  "<cmd>Telescope command_history<cr>",                                                                                  desc = "Command History" },
        { "<leader>f/",  "<cmd>Telescope search_history<cr>",                                                                                  desc = "Search History" },
        { "<leader>fd",  "<cmd>Telescope diagnostics<cr>",                                                                                      desc = "Diagnostic" },
        { "<leader>ff",  "<cmd>lua require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({ previewer = false }))<cr>", desc = "Files" },
        { "<leader>fg",  "<cmd>lua require('telescope.builtin').live_grep(require('telescope.themes').get_dropdown({previewer=false}))<cr>",    desc = "File Contents (Live Grep)" },
        { "<leader>fj",  "<cmd>Telescope jumplist<cr>",                                                                                         desc = "Jumplist" },
        { "<leader>fo",  group = "[Obscure]" },
        { "<leader>foa", "<cmd>Telescope autocommands<cr>",                                                                                     desc = "AutoCommands" },
        { "<leader>fok", "<cmd>Telescope keymaps<cr>",                                                                                          desc = "Keybindings" },
        { "<leader>foo", "<cmd>Telescope colorscheme<cr>",                                                                                      desc = "Colorschemes" },
        { "<leader>fos", "<cmd>Telescope search_history<cr>",                                                                                   desc = "Search, History" },
        { "<leader>fov", "<cmd>Telescope vim_options<cr>",                                                                                      desc = "ViM Options" },
        { "<leader>fp",  "<cmd>Telescope projects<cr>",                                                                                         desc = "Projects" },
        { "<leader>fr",  "<cmd>lua require('telescope.builtin').oldfiles(require('telescope.themes').get_dropdown{previewer = false})<cr>",     desc = "Recent Files" },
        { "<leader>fR",  "<cmd>Telescope oldfiles<cr>",                                                                                         desc = "Recent Files (+Preview)" },
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
