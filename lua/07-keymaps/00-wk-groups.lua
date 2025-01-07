Events.await_event {
  actor = "which-key",
  event = "configured",
  retroactive = true,
  callback = function()
    Safe.import_then("which-key", function(wk)
      wk.add {
        { "<space>b",   group = "[Buffer]" },
        { "<space>c",   group = "[Configure]" },
        { "<space>d",   group = "[DAP]" },
        { "<space>f",   group = "[Find]" },
        { "<space>l",   group = "[LSP]" },
        { "<space>w",   group = "[Window]" },
        { "<space>d",   group = "[Debugging]" },
        { "<leader>db", group = "[Breakpoints]" },
        { "<leader>ds", group = "[Session]" },
        { "<leader>du", group = "[DAP UI]" },
        { "<leader>j",  group = "[Jump]" },
        { "<leader>jk",  group = "[Prevous]" },
        { "<leader>jj",  group = "[Next]" },
        { "<leader>m",  group = "[NaviMarks]" },
      }
    end)
  end
}
