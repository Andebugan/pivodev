local packages = {}

if LANG_INSTALL_CONFIG.dbtools then
    table.insert(packages,
        {
            'kristijanhusak/vim-dadbod-ui',
            dependencies = {
                {
                    'tpope/vim-dadbod',
                    lazy = true
                },
                {
                    'kristijanhusak/vim-dadbod-completion',
                    ft = { 'sql', 'mysql', 'plsql' },
                    lazy = true
                },
            },
            cmd = {
                'DBUI',
                'DBUIToggle',
                'DBUIAddConnection',
                'DBUIFindBuffer',
            },
            init = function()
                -- DBUI configuration
                vim.g.db_ui_use_nerd_fonts = 1
            end,
        })


    vim.keymap.set('n', '<Leader>Du', '<cmd>DBUI<cr>')  -- open UI
    vim.keymap.set('n', '<Leader>Dt', '<cmd>DBUIToggle<cr>')  -- toggle UI 
    vim.keymap.set('n', '<Leader>Da', '<cmd>DBUIAddConnection<cr>')  -- add connection 
    vim.keymap.set('n', '<Leader>Dc', '<cmd>DBUIClose<cr>')  -- add connection 
    vim.keymap.set('n', '<Leader>Dfb', '<cmd>DBUIFindBuffer<cr>')  -- find buffer
    vim.keymap.set('n', '<Leader>Drb', '<cmd>DBUIRenameBuffer<cr>')  -- rename buffer
    vim.keymap.set('n', '<Leader>Di', '<cmd>DBUILastQueryInfo<cr>')  -- last query info 
end

return packages
