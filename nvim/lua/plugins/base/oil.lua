return {
    'stevearc/oil.nvim',
    dependencies = {
        'nvim-tree/nvim-web-devicons',
    },
    opts = {
        vim.keymap.set('n', '<leader>oo', '<cmd>Oil<cr>', {}),
        vim.keymap.set('n', '<leader>of', '<cmd>Oil --float<cr>', {}),
    }
}
