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

if LANG_INSTALL_CONFIG.csharp then
    table.insert(packages, {
        "Issafalcon/neotest-dotnet",
    })
end

return packages
