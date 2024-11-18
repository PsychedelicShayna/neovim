return {
  "echasnovski/mini.nvim",
  version = '*',
  config = function()
    -- -- -- -- Adds Operators -- -- -- --
    --
    --    g=    Eval text and replace
    --    gx    Excchange text regions
    --    gm    Duplicate text
    --    gs    Replace with register
    --
    require("mini.operators").setup()
    -- -- -- -- -- -- -- -- -- -- -- -- --

    -- Enhances text objects and adds new text objects to be used with motions
    -- e.g. inner or around last/next text object of a certain type, or around
    -- function (af), or custom left/right edges with a?, etc.
    require("mini.ai").setup()

    -- Extends the behavior of 'f' to include multiple lines, and introduces
    -- a new binding 't' which until a character.
    -- require("mini.jump").setup {
    --   forward = 'f<Enter>',
    --   forward_till = 'f<Enter>t',
    --   repeat_jump = ';' 
    -- }
    -- forward       f  forward_till    t
    -- backward      F  backward_till   T
    -- repeat_jump   ;

    -- Amazing. Introduces a new motion by hitting enter that lets you
    -- jump to anywhere in the buffer instantly by narrowing down the
    -- location via 2-3 keystrokes. It's a fully fledged motion!
    require("mini.jump2d").setup()

    -- Also awesome, lets you move visual mode selections omni-directionally,
    -- by holding Alt+hjkl, combinable with motions. Suggest :set ve=all
    require("mini.move").setup()

    -- Introduces new operators hat allows you to operate on the surrounding
    -- part of a motion, i.e. the word "foo" has quotes surrounding it. You
    -- could gsr"' would turn it into 'foo'

    require("mini.surround").setup {
      mappings = {
        add = 'gsa',            -- Add surrounding in Normal and Visual mode
        delete = 'gsd',         -- Delete surrounding
        find = 'gsf',           -- Find surrounding (to the right)
        find_left = 'gsF',      -- Find surrounding (to the left)
        highlight = 'gsh',      -- Highlight surrounding
        replace = 'gsr',        -- Replace surrounding
        update_n_lines = 'gsn', -- Update `n_lines`
        suffix_last = 'l',      -- Suffix to search with "prev" method
        suffix_next = 'n',      -- Suffix to search with "next" method
      }
    }

    -- require("mini.base16").setup {
    --   palette = {
    --     base00 = "#282828", -- Background (Dark0 H                         
    --     base01 = "#3C3836", -- Dark1                                       
    --     base02 = "#504945", -- Dark2                                       
    --     base03 = "#665C54", -- Dark3                                       
    --     base04 = "#BDAE93", -- Light4                                      
    --     base05 = "#D5C4A1", -- Light1                                      
    --     base06 = "#EBDBB2", -- Light2                                      
    --     base07 = "#FBF1C7", -- Light3 (Foreground)                         
    --     base08 = "#FB4934", -- Red (Bright Red)                            
    --     base09 = "#FE8019", -- Orange                                      
    --     base0A = "#FABD2F", -- Yellow                                      
    --     base0B = "#B8BB26", -- Green                                       
    --     base0C = "#8EC07C", -- Aqua                                        
    --     base0D = "#83A598", -- Blue                                        
    --     base0E = "#D3869B", -- Purple                                      
    --     base0F = "#D65D0E", -- Brown                                       
    --
    --   }
    -- }
    -- require("mini.hues").setup()
  end
}
