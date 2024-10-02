return {
  {
    "mfussenegger/nvim-dap",
    lazy = true,
    cmd = "DapNew",
    config = function()
      Safe.import_then("dap", function(dap)
        dap.adapters.cppdbg = {
          id = "cppdbg",
          type = "executable",
          command =
          "/home/eternal0000ff/.local/share/nvim/mason/packages/cpptools/extension/debugAdapters/bin/OpenDebugAD7"
        }

        dap.configurations.cpp = {
          {
            name = "Launch File",
            type = "cppdbg",
            request = "launch",
            program = function()
              return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            end,
            cwd = '${workspaceFolder}',
            stopAtEntry = true,
            setupCommands = {
              {
                text = '-enable-pretty-printing',
                description = 'enable pretty printing',
                ignoreFailures = false
              },
            },
          },
          {
            name = 'Attach to gdbserver :1234',
            type = 'cppdbg',
            request = 'launch',
            MIMode = 'gdb',
            miDebuggerServerAddress = 'localhost:1234',
            miDebuggerPath = '/usr/bin/gdb',
            cwd = '${workspaceFolder}',
            program = function()
              return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            end,
            setupCommands = {
              {
                text = '-enable-pretty-printing',
                description = 'enable pretty printing',
                ignoreFailures = false
              },
            },

          },

        }

        dap.configurations.c = dap.configurations.cpp
        dap.configurations.rust = dap.configurations.cpp

        Events.await_event {
          actor = "which-key",
          event = "configured",
          retroactive = true,
          callback = function()
            Safe.import_then('which-key', function(wk)
              wk.add {
                { "<space>d",    group = "[Debugging]" },

                -- Session Management.
                { "<space>ds",   group = "[Session]" },
                { "<leader>dsr", "<cmd>lua require('dap').restart()<cr>",           desc = "Restart Debugging Session" },
                { "<leader>dsc", "<cmd>lua require('dap').close()<cr>",             desc = "Close Debugging Session" },
                { "<leader>dst", "<cmd>lua require('dap').terminate()<cr>",         desc = "Terminate Debugging Session" },
                { "<leader>dsd", "<cmd>lua require('dap').disconnect()<cr>",        desc = "Request Debugger Disconnect" },

                -- Control Flow
                { "<leader>dr",  "<cmd>lua require('dap').run_last()<cr>",          desc = "Runs Last Debug Adapter Configuration" },
                { "<leader>dc",  "<cmd>lua require('dap').continue()<cr>",          desc = "Continue Execution/Start Debugger" },
                { "<leader>dC",  "<cmd>lua require('dap').reverse_continue()<cr>",  desc = "Continue Backwards (Reverse Debugging)" },
                { "<leader>di",  "<cmd>lua require('dap').step_into()<cr>",         desc = "Step Into" },
                { "<leader>do",  "<cmd>lua require('dap').step_out()<cr>",          desc = "Step Out" },
                { "<leader>dl",  "<cmd>lua require('dap').step_over()<cr>",         desc = "Step Over" },
                { "<leader>dh",  "<cmd>lua require('dap').step_back()<cr>",         desc = "Step Back" },
                { "<leader>d;",  "<cmd>lua require('dap').repl.toggle()<cr>",       desc = "Toggle Debugger REPL" },

                -- Breakpoints
                { "<leader>db",  group = "[Breakpoints]" },
                { "<leader>dbb", "<cmd>lua require('dap').toggle_breakpoint()<cr>", desc = "Toggle Breakpoint" },
                { "<leader>dbh", "<cmd>lua require('dap').run_to_cursor()<cr>",     desc = "Break Here & Run" },
                { "<leader>dbc", "<cmd>lua require('dap').clear_breakpoints()<cr>", desc = "Clear Breakpoints" },
                { "<leader>dbl", "<cmd>lua require('dap').list_breakpoints()<cr>",  desc = "List Breakpoints (QF Window)" },
              }
            end)
          end
        }
      end)

      vim.cmd [[ hi debugPC guibg=#222222 guifg=#d4be98 ]]

      Events.fire_event {
        actor = "nvim-dap",
        event = "configured"
      }
    end
  },

  -- Optional: DAP UI for a better debugging experience
  {
    'rcarriga/nvim-dap-ui',
    dependencies = {
      'mfussenegger/nvim-dap',
      "nvim-neotest/nvim-nio"
    },
    lazy = true,
    ft = 'c',
    config = function()
      Safe.import_then("dapui", function(dapui)
        dapui.setup()

        -- Automatically open DAP UI when debugging starts, and close when it ends
        Safe.import_then("dap", function(dap)
          dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open()
          end

          dap.listeners.before.event_terminated["dapui_config"] = function()
            dapui.close()
          end

          dap.listeners.before.event_exited["dapui_config"] = function()
            dapui.close()
          end
        end)
      end)


      Events.fire_event {
        actor = "nvim-dap-ui",
        event = "configured"
      }
    end
  },

  -- Optional: Virtual text for DAP (displays variable values inline)
  {
    'theHamsta/nvim-dap-virtual-text',
    dependencies = { 'mfussenegger/nvim-dap' },
    lazy = true,
    ft = 'c',
    config = function()
      require("nvim-dap-virtual-text").setup()

      Events.fire_event {
        actor = "nvim-dap-virtual-text",
        event = "configured"
      }
    end
  }


}
