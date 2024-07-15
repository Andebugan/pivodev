return {
    {
        "jay-babu/mason-nvim-dap.nvim",
        config = function()
            require("mason").setup()

            local packages = {
            }

            if LANG_INSTALL_CONFIG.python then table.insert(packages, "debugpy") end
            if LANG_INSTALL_CONFIG.csharp then table.insert(packages, "netcoredbg") end
            if LANG_INSTALL_CONFIG.go then table.insert(packages, "delve") end

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
                    command = os.getenv('HOME') .. '/.local/share/nvim/mason/bin/netcoredbg',
                    args = { '--interpreter=vscode' }
                }

                dap.configurations.cs = {
                    {
                        type = "coreclr",
                        name = "launch - netcoredbg",
                        request = "launch",
                        program = function()
                            local name = vim.fn.input('pattern: ') -- search for dll as patten in /bin/Debug/ folders of the project (relative to cwd)
                            vim.print('')

                            local command = 'find ' .. vim.fn.getcwd() .. ' -path "*/bin/Debug/*/' .. name .. '.dll"'
                            local handle = io.popen(command)
                            if handle == nil then
                                vim.print("Unable to use find to search for .dll")
                                return ""
                            end
                            local result = handle:read("*a")
                            handle:close()

                            if result == nil or result == "" then
                                vim.print("Unable to find .dll");
                                return ""
                            end

                            local paths = {}
                            if string.find(result, "\n") then  -- newlines detected
                                for s in string.gmatch(result, "[^\n]+") do -- parse lines
                                    if s ~= "" and s ~= nil then
                                        vim.print(s)
                                        table.insert(paths, s)
                                    end
                                end
                            else
                                vim.print("dll path: " .. result)
                                return result
                            end

                            if #paths == 1 then -- if only one result then probably path
                                for _, v in ipairs(paths) do
                                    vim.print("dll path: " .. v)
                                    return v
                                end
                            elseif #paths == 0 then
                                vim.print("Unable to find .dll");
                                return ""
                            else
                                vim.print("Found multiple paths matching patter, first one will be used:")
                                for _, v in ipairs(paths) do vim.print(v) end
                                for _, v in ipairs(paths) do return v end
                            end
                        end,
                    }
                }
            end

            if LANG_INSTALL_CONFIG.go then
                dap.adapters.delve = {
                    type = 'server',
                    port = '${port}',
                    executable = {
                        command = 'dlv',
                        args = { 'dap', '-l', '127.0.0.1:${port}' },
                    }
                }

                dap.configurations.go = {
                    {
                        type = "delve",
                        name = "Debug",
                        request = "launch",
                        program = "${file}"
                    },
                    {
                        type = "delve",
                        name = "Debug test",
                        request = "launch",
                        mode = "test",
                        program = "${file}"
                    },
                    {
                        type = "delve",
                        name = "Debug test (go.mod)",
                        request = "launch",
                        mode = "test",
                        program = "./${relativeFileDirname}"
                    }
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

            vim.keymap.set('n', '<leader>dX', function () dapui.close() end)

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
