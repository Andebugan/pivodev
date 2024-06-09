return {
    {
        "ahmedkhalf/project.nvim",
        config = function()
            require("project_nvim").setup({
                patterns = {
                    ".git",
                    "_darcs",
                    ".hg",
                    ".bzr",
                    ".svn",
                    "Makefile",
                    ".csproj",
                    "venv",
                    "note.tex"
                }
            })
        end
    },
    {
        'nvim-telescope/telescope-ui-select.nvim',
        config = function()
            require("telescope").setup {
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown {}
                    }
                }
            }

            require("telescope").load_extension("ui-select")
        end
    },
    {
        'nvim-telescope/telescope-project.nvim',
        config = function()
            local telescope = require("telescope")
            telescope.setup()
            telescope.load_extension('project')
        end
    },
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.6',
        dependencies = {
            'nvim-lua/plenary.nvim'
        },
        config = function()
            local builtin = require("telescope.builtin")
            vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
            vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
            vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
            vim.keymap.set('n', '<leader>fr', builtin.oldfiles, {})
            vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
            vim.keymap.set('n', '<leader>fp', ':Telescope projects<CR>', {})
            require('telescope').setup({
                defaults = {
                    file_ignore_patterns = {
                        "node_modules/.*",
                        ".git/.*",
                        "tmp/.*",
                        "cahce/.*",
                        "venv/.*",
                        "__pycache__/.*",
                        ".aux",
                        ".toc",
                        ".bbl"
                    }
                },
                pickers = {
                    buffers = {
                        mappings = {
                            n = {
                                ["d"] = "delete_buffer",
                            }
                        }
                    }
                },
            })
        end
    },
}
