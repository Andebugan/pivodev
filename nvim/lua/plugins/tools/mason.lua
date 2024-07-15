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
            if LANG_INSTALL_CONFIG.html then table.insert(packages, "html") end
            if LANG_INSTALL_CONFIG.css then table.insert(packages, "cssls") end
            if LANG_INSTALL_CONFIG.dbtools then table.insert(packages, "sqlls") end
            if LANG_INSTALL_CONFIG.go then table.insert(packages, "gopls") end

            require("mason-lspconfig").setup({
                ensure_installed = packages,
                auto_install = true
            })
        end
    },
}
