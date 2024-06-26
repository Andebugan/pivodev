local packages = {
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-treesitter/nvim-treesitter"
        },
        config = function()
            local adapters = {}
            if LANG_INSTALL_CONFIG.csharp then
                table.insert(adapters, require("neotest-dotnet")({
                    dap = { justMyCode = false },
                }))
            end

            require("neotest").setup({
                adapters = adapters,
            })
        end
    },
}

vim.keymap.set('n', '<Leader>ntr', '<cmd>Neotest run<cr>')
vim.keymap.set('n', '<Leader>nto', '<cmd>Neotest output<cr>')
vim.keymap.set('n', '<Leader>ntp', '<cmd>Neotest output-panel<cr>')
vim.keymap.set('n', '<Leader>nta', '<cmd>Neotest attach<cr>')
vim.keymap.set('n', '<Leader>ntj', '<cmd>Neotest jump<cr>')
vim.keymap.set('n', '<Leader>ntt', '<cmd>Neotest stop<cr>') -- terminate
vim.keymap.set('n', '<Leader>nts', '<cmd>Neotest summary<cr>')

if LANG_INSTALL_CONFIG.csharp then
    table.insert(packages, {
        "Issafalcon/neotest-dotnet",
    })
end

return packages
