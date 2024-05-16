return {
    {
        "jay-babu/mason-nvim-dap.nvim",
        config = function()
            require("mason").setup()

            local packages = {
            }

            if LANG_INSTALL_CONFIG.python then table.insert(packages, "debugpy") end
            if LANG_INSTALL_CONFIG.csharp then table.insert(packages, "netcoredbg") end

            require("mason-nvim-dap").setup({
                ensure_installed = packages,
                automatic_installation = true
            })
        end,
    },
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "williamboman/mason.nvim",
            "nvim-neotest/nvim-nio",
        },
        config = function()
            local dap, dapui = require('dap'), require('dapui')
            dapui.setup()

            -- Python debugger config
            if LANG_INSTALL_CONFIG.python then
                dap.adapters.python = function(cb, config)
                    if config.request == 'attach' then
                        --@diagnostic disable-next-line: undefined-field
                        local port = (config.connect or config).port
                        --@diagnostic disable-next-line: undefined-field
                        local host = (config.connect or config).host or '127.0.0.1'
                        cb({
                            type = 'server',
                            port = assert(port, '`connect.port` is required for a python `attach` configuration'),
                            host = host,
                            options = {
                                source_filetype = 'python',
                            },
                        })
                    else
                        cb({
                            type = 'executable',
                            command = os.getenv('HOME') .. '/.virtualenvs/debugpy/bin/python3',
                            args = { '-m', 'debugpy.adapter' },
                            options = {
                                source_filetype = 'python'
                            },
                        })
                    end
                end

                dap.configurations.python = {
                    {
                        type = 'python',
                        request = 'launch',
                        name = "Launch file",

                        program = "${file}",

                        pythonPath = function()
                            local cwd = vim.fn.getcwd()
                            if vim.fn.executable(cwd .. '/venv/bin/python3') == 1 then
                                return cwd .. '/venv/bin/python3'
                            elseif vim.fn.executable(cwd .. '/.venv/bin/python3') == 1 then
                                return cwd .. '/.venv/bin/python3'
                            else
                                return '/usr/bin/python3'
                            end
                        end,
                    }
                }
            end

            if LANG_INSTALL_CONFIG.csharp then
                dap.adapters.coreclr = {
                    type = 'executable',
                    command = '$HOME/.local/share/nvim/mason/bin/netcoredbg',
                    args = {'--interpreter=vscode'}
                }

                dap.configurations.cs = {
                    type = "coreclr",
                    name = "launch = netcoredbg",
                    request = "launch",
                    program = function()
                        return vim.fn.input('path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
                    end,
                }
            end

            dap.listeners.after.event_initialized['dapui_config'] = function()
                dapui.open()
            end

            dap.listeners.after.event_terminated['dapui_config'] = function()
                dapui.close()
            end

            dap.listeners.after.event_exited['dapui_config'] = function()
                dapui.close()
            end

            vim.keymap.set('n', '<leader>db', ':DapToggleBreakpoint<CR>')
            vim.keymap.set('n', '<leader>dc', ':DapContinue<CR>')
            vim.keymap.set('n', '<leader>di', ':DapStepInto<CR>')
            vim.keymap.set('n', '<leader>dI', ':DapInstall<CR>')
            vim.keymap.set('n', '<leader>do', ':DapStepOut<CR>')
            vim.keymap.set('n', '<leader>dO', ':DapStepOver<CR>')
            vim.keymap.set('n', '<leader>dt', ':DapTerminate<CR>')
        end
    },
}
