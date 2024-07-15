-- basic settings
vim.o.number = true               -- enable line numbers
vim.o.ruler = false               -- disable ruler
vim.o.relativenumber = false      -- enable relative line numbers

vim.o.tabstop = 4                 -- number of spaces a tab represents
vim.o.shiftwidth = 4              -- number of spaces in each identations
vim.o.expandtab = true            -- convert tabs to spaces
vim.o.smartindent = true          -- automatically indent new lines
vim.o.wrap = true                 -- disable line wrapping
vim.o.linebreak = true            -- enable breaking at words for wrap option

vim.o.termguicolors = true        -- disnable 24-bit RGB colors

vim.o.ignorecase = true           -- set ignore case for search
vim.o.smartcase = true            -- set smart case for search

vim.opt.fillchars = { eob = " " } -- disable tilde symbols after EOF

vim.o.foldmethod = "indent"       -- fold

-- key mappings
vim.g.mapleader = ' ' -- set space as the leader key

-- tab keymaps
vim.keymap.set('n', '<Leader>to', '<cmd>tabnew<cr>')   -- open new tab
vim.keymap.set('n', '<Leader>tc', '<cmd>tabclose<cr>') -- close tab
vim.keymap.set('n', '<Leader>tn', '<cmd>tabnext<cr>')  -- next tab
vim.keymap.set('n', '<Leader>tp', '<cmd>tabprev<cr>')  -- previous tab
vim.keymap.set('n', '<Leader>tf', '<cmd>tabfirst<cr>') -- first tab
vim.keymap.set('n', '<Leader>tl', '<cmd>tablast<cr>')  -- last tab

-- file keymaps
vim.keymap.set('n', '<Leader>sf', '<cmd>w<cr>')  -- save current file
vim.keymap.set('n', '<Leader>sa', '<cmd>wa<cr>') -- save all open files

-- buffer keymaps
vim.keymap.set('n', '<Leader>bn', '<cmd>bnext<cr>')     -- next buffer
vim.keymap.set('n', '<Leader>bp', '<cmd>bprevious<cr>') -- previous buffer
vim.keymap.set('n', '<Leader>bf', '<cmd>bfirst<cr>')    -- first buffer
vim.keymap.set('n', '<Leader>bl', '<cmd>blast<cr>')     -- last buffer
vim.keymap.set('n', '<Leader>br', '<cmd>brewind<cr>')   -- go to first buffer in list
vim.keymap.set('n', '<Leader>bm', '<cmd>bmodified<cr>') -- go to next modified buffer
vim.keymap.set('n', '<Leader>bu', '<cmd>bunload<cr>')   -- unload buffer
vim.keymap.set('n', '<Leader>bd', '<cmd>bdelete<cr>')   -- delete buffer
vim.keymap.set('n', '<Ledaer>bd!', '<cmd>bdelete!<cr>') -- force delete buffer
vim.keymap.set('n', '<Leader>bw', '<cmd>bwipeout<cr>')  -- wipe buffer

-- misc keymaps
vim.keymap.set('n', '<Leader>cc', '<cmd>clo<cr>') -- close current window
vim.keymap.set('n', '<Leader>hh', '<cmd>noh<cr>') -- hide highlight

-- session keymaps
vim.keymap.set('n', '<Leader>ss', '<cmd>mksession! .session.vim<cr>') -- create current session file in cwd
vim.keymap.set('n', '<Leader>ls', '<cmd>source .session.vim<cr>') -- create current session file in cwd

-- cyrillic qwerty langmap
vim.o.langmap =
"йq,цw,уe,кr,еt,нy,гu,шi,щo,зp,х[,ъ],фa,ыs,вd,аf,пg,рh,оj,лk,дl,ж\\;,э',яz,чx,сc,мv,иb,тn,ьm,б\\,,ю.,ё`,ЙQ,ЦW,УE,КR,ЕT,НY,ГU,ШI,ЩO,ЗP,Х{,Ъ},ФA,ЫS,ВD,АF,ПG,РH,ОJ,ЛK,ДL,Ж\\:,Э\",ЯZ,ЧX,СC,МV,ИB,ТN,ЬM,Б<,Ю>,Ё~"

-- syntax
vim.cmd('syntax enable')             -- enable syntax highlight
vim.cmd('filetype plugin indent on') -- enable filetype detection, completions, plugin files and indent files

-- terminal
vim.cmd('autocmd TermOpen * setlocal nonumber norelativenumber') -- disable line numbers for terminal
vim.o.shell = "bash"                                             -- change terminal shell to bash

-- lazy.nvim setup
-- for correct symbol rendering Nerd Font should be installed (me have chosen Hack Mono you do you)

if pcall(require, "plugins.config.local_config") then
    LANG_INSTALL_CONFIG = require("plugins.config.local_config")
else
    LANG_INSTALL_CONFIG = require("plugins.config.config")
end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins")

-- pull config update from repo
vim.keymap.set('n', '<Leader>U', function()
    print("Fetching configuration...")
    print(vim.fn.system({
        "git",
        "-C",
        os.getenv('HOME') .. "/pivodev/",
        "fetch",
    }))
    print("Pulling update from repository...")
    print(vim.fn.system({
        "git",
        "-C",
        os.getenv('HOME') .. "/pivodev/",
        "pull",
    }))
    print("Update complete, reload nvim to apply changes")
end)
