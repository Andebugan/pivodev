return {
    {
        'nvim-treesitter/nvim-treesitter',
        config = function ()
            require('nvim-treesitter.configs').setup({
                ensure_installed = {
                    -- required parsers
                    "lua",
                    "vim",
                    "vimdoc",
                    "query",
                    "c",
                },
                auto_install = true
            })
        end
    },
}