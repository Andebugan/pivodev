return {
    { 
        "lewis6991/gitsigns.nvim",
        config = function()
            require('gitsigns').setup {
                signs = {
                    add          = { text = '│' },
                    change       = { text = '│' },
                    delete       = { text = '_' },
                    topdelete    = { text = '‾' },
                    changedelete = { text = '~' },
                    untracked    = { text = '┆' },
                },
                signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
                numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
                linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
                word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
                watch_gitdir = {
                    follow_files = true
                },
                attach_to_untracked = true,
                current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
                current_line_blame_opts = {
                    virt_text = true,
                    virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
                    delay = 1000,
                    ignore_whitespace = false,
                    virt_text_priority = 100,
                },
                current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
                sign_priority = 6,
                update_debounce = 100,
                status_formatter = nil, -- Use default
                max_file_length = 40000, -- Disable if file is longer than this (in lines)
                preview_config = {
                    -- Options passed to nvim_open_win
                    border = 'single',
                    style = 'minimal',
                    relative = 'cursor',
                    row = 0,
                    col = 1
                },
                yadm = {
                    enable = false
                },
                on_attach = function(bufnr)
                    local gs = package.loaded.gitsigns

                    opts = {}
                    opts.buffer = bufnr

                    -- Navigation
                    vim.keymap.set('n', ']c', function()
                        if vim.wo.diff then
                            vim.cmd.normal({']c', bang = true})
                        else
                            gitsigns.nav_hunk('next')
                        end
                    end, opts) 

                    vim.keymap.set('n', '[c', function()
                        if vim.wo.diff then
                            vim.cmd.normal({'[c', bang = true})
                        else
                            gitsigns.nav_hunk('prev')
                        end
                    end, opts)

                    -- Actions
                    vim.keymap.set('n', '<leader>hs', gs.stage_hunk, opts)
                    vim.keymap.set('n', '<leader>hr', gs.reset_hunk, opts)
                    vim.keymap.set('v', '<leader>hs', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end, opts)
                    vim.keymap.set('v', '<leader>hr', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end, opts)
                    vim.keymap.set('n', '<leader>hS', gs.stage_buffer, opts)
                    vim.keymap.set('n', '<leader>hu', gs.undo_stage_hunk, opts)
                    vim.keymap.set('n', '<leader>hR', gs.reset_buffer, opts)
                    vim.keymap.set('n', '<leader>hp', gs.preview_hunk, opts)
                    vim.keymap.set('n', '<leader>hb', function() gs.blame_line{full=true} end, opts)
                    vim.keymap.set('n', '<leader>tb', gs.toggle_current_line_blame, opts)
                    vim.keymap.set('n', '<leader>hd', gs.diffthis, opts)
                    vim.keymap.set('n', '<leader>hD', function() gs.diffthis('~') end, opts)
                    vim.keymap.set('n', '<leader>td', gs.toggle_deleted, opts)
                    -- Text object
                    vim.keymap.set({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>', opts)
                end
            }
        end
    },
    {
        'tpope/vim-fugitive',
        config = function ()
            vim.keymap.set('n', '<leader>Ga', '<cmd>G add .<cr>')
            vim.keymap.set('n', '<leader>Gp', '<cmd>G pull <cr>')
            vim.keymap.set('n', '<leader>GP', '<cmd>G push <cr>')
        end
    },
}
