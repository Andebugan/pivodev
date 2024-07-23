local packages = {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "ray-x/lsp_signature.nvim",
        },
        config = function()
            local capabilities = require('cmp_nvim_lsp').default_capabilities()
            local lspconfig = require("lspconfig")

            -- default
            lspconfig.lua_ls.setup({ capabilities = capabilities })
            lspconfig.bashls.setup({ capabilities = capabilities })
            lspconfig.yamlls.setup({ capabilities = capabilities })
            lspconfig.jsonls.setup({ capabilities = capabilities })

            lspconfig.dockerls.setup({ capabilities = capabilities })
            lspconfig.docker_compose_language_service.setup({ capabilities = capabilities })

            lspconfig.marksman.setup({ capabilities = capabilities })

            -- configurable
            if LANG_INSTALL_CONFIG.latex then
                lspconfig.texlab.setup({ capabilities = capabilities })
            end

            if LANG_INSTALL_CONFIG.python then
                lspconfig.pylsp.setup({
                    capabilities = capabilities,
                    settings = {
                        pylsp = {
                            plugins = {
                                pycodestyle = {
                                    ignore = { 'E501', 'W391' }
                                },
                            },
                        },
                    },
                    root_dir = function()
                        return vim.fn.getcwd()
                    end
                })
            end

            if LANG_INSTALL_CONFIG.csharp then
                local pid = vim.fn.getpid()
                lspconfig.omnisharp.setup(
                    {
                        capabilities = capabilities,
                        cmd = {
                            os.getenv('HOME') .. "/.local/share/nvim/mason/bin/omnisharp",
                            "--languageserver",
                            "--hostPID",
                            tostring(pid)
                        },
                    }
                )
            end

            if LANG_INSTALL_CONFIG.css then
                lspconfig.cssls.setup({ capabilities = capabilities })
            end

            if LANG_INSTALL_CONFIG.html then
                lspconfig.html.setup({
                    capabilities = capabilities,
                    filetypes = { "html", "templ" },
                })
            end

            if LANG_INSTALL_CONFIG.go then
                lspconfig.gopls.setup({
                    capabilities = capabilities,
                })
            end

            if LANG_INSTALL_CONFIG.dbtools then
                lspconfig.sqlls.setup({
                    capabilities = capabilities,
                })
            end

            vim.keymap.set('n', '<leader>df', vim.diagnostic.open_float)
            vim.keymap.set('n', '<leader>gp', vim.diagnostic.goto_prev)
            vim.keymap.set('n', '<leader>gn', vim.diagnostic.goto_next)
            vim.keymap.set('n', '<leader>sl', vim.diagnostic.setloclist)

            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('UserLspConfig', {}),
                callback = function(ev)
                    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

                    local opts = { buffer = ev.buf }

                    vim.keymap.set('n', '<leader>gD', vim.lsp.buf.declaration, opts)
                    vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition, opts)
                    vim.keymap.set('n', '<leader>h', vim.lsp.buf.hover, opts)
                    vim.keymap.set('n', '<leader>gi', vim.lsp.buf.implementation, opts)
                    vim.keymap.set('n', '<leader>s', vim.lsp.buf.signature_help, opts)
                    vim.keymap.set('n', '<leader>w', vim.lsp.buf.add_workspace_folder, opts)
                    vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
                    vim.keymap.set('n', '<leader>tD', vim.lsp.buf.type_definition, opts)
                    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
                    vim.keymap.set('n', '<leader>gr', vim.lsp.buf.references, opts)
                    vim.keymap.set('n', '<leader>wl', function()
                        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                    end, opts)
                    vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
                    vim.keymap.set('n', '<leader>f', function()
                        vim.lsp.buf.format { async = true }
                    end, opts)

                    -- attach lsp signature
                    local bufnr = ev.buf
                    local client = vim.lsp.get_client_by_id(ev.data.client_id)
                    if vim.tbl_contains({ 'null-ls' }, client.name) then -- blacklist lsp
                        return
                    end
                    require("lsp_signature").on_attach({
                        doc_lines = 20,
                        hint_prefix = {
                            above = "↙ ", -- when the hint is on the line above the current line
                            current = "← ", -- when the hint is on the same line
                            below = "↖ " -- when the hint is on the line below the current line
                        },
                        max_height = 30,
                        max_width = 90
                    }, bufnr)
                end

            })
        end
    },
    {
        "ray-x/lsp_signature.nvim",
        event = "VeryLazy",
        opts = {},
        config = function(_, opts) require('lsp_signature').setup(opts) end
    }
}

if LANG_INSTALL_CONFIG.python then
    table.insert(packages, {
        "linux-cultist/venv-selector.nvim",
        dependencies = {
            'neovim/nvim-lspconfig',
            'nvim-telescope/telescope.nvim',
        },
        config = function()
            require('venv-selector').setup {}
        end,
        keys = {
            { '<leader>vs', '<cmd>VenvSelect<cr>' },
            { '<leader>vc', '<cmd>VenvSelectCached<cr>' }
        }
    })
end

return packages
