return {
  {
    "mfussenegger/nvim-dap",
    lazy = true,
    config = function()
      Safe.import_then("dap", function(dap)
        local home_folder = os.getenv("HOME")

        local odad7_path = string.format("%s/%s",
          home_folder,
          "/.local/share/nvim/mason/packages/cpptools/extension/debugAdapters/bin/OpenDebugAD7"
        )

        dap.adapters.cppdbg = {
          id = "cppdbg",
          type = "executable",
          command = odad7_path
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
      end)

      vim.cmd [[ hi debugPC guibg=#222222 guifg=#d4be98 ]]

      Events.fire_event { actor = "nvim-dap", event = "configured" }
    end
  },


  { -- Optional: DAP UI for a better debugging experience
    'rcarriga/nvim-dap-ui',
    dependencies = { 'mfussenegger/nvim-dap', "nvim-neotest/nvim-nio" },
    ft = { 'rust', 'c', 'cpp' },
    config = function()
      Safe.import_then("dapui", function(dapui)
        dapui.setup()

        -- Automatically open DAP UI when debugging starts, and close when it ends
        Safe.import_then("dap", function(dap)
          dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open()
          end
        end)
      end)

      Events.fire_event { actor = "dapui", event = "configured" }
    end
  },


  { -- Optional: Virtual text for DAP (displays variable values inline)
    'theHamsta/nvim-dap-virtual-text',
    dependencies = { 'mfussenegger/nvim-dap' },
    lazy = true,
    init = function()

    end,
    config = function()
      require("nvim-dap-virtual-text").setup()
      Events.fire_event { actor = "dap-virt", event = "configured" }
    end
  },
}
