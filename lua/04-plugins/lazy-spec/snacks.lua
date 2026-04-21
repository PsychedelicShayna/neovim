return {
  'folke/snacks.nvim',
  lazy = false,
  priority = 1001,
  opts = {
    bigfile = { enabled = true },
    dashboard = { enabled = false },
    explorer = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    picker = { enabled = true },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    scope = { enabled = true },
    animate = { enabled = true },
    scroll = {
      enabled = true,
      animate = {
        duration = { step = 16, total = 96 },
        easing = "outSine",
      },
      -- faster animation when repeating scroll after delay
      animate_repeat = {
        delay = 100,     -- delay in ms before using the repeat animation
        duration = { step = 16, total = 64 },
        easing = "outCubic",
      },
      -- what buffers to animate
      filter = function(buf)
        return vim.g.snacks_scroll ~= false and vim.b[buf].snacks_scroll ~= false and
            vim.bo[buf].buftype ~= "terminal"
      end,
    },
    statuscolumn = { enabled = true },
    words = { enabled = true },
  }
}
