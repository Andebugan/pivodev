return {
    {
        "williamboman/mason.nvim",
        config = function()
            require('mason').setup()
        end
    },
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            -- default
            local packages = {
                "lua_ls",
                "docker_compose_language_service",
                "dockerls",
                "bashls",
                "jsonls",
                "lua_ls",
                "yamlls",
                "marksman",
            }

            -- custom config add packages
            if LANG_INSTALL_CONFIG.python then table.insert(packages, "pylsp") end
            if LANG_INSTALL_CONFIG.latex then table.insert(packages, "texlab") end
            if LANG_INSTALL_CONFIG.csharp then table.insert(packages, "omnisharp") end

            require("mason-lspconfig").setup({
                ensure_installed = packages,
                auto_install = true
            })
        end
    },
}
