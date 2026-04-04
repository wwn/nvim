local opt = vim.opt

vim.o.background = 'light'

opt.mouse = "a"               -- allows mouse actions
opt.clipboard = "unnamedplus" -- synchc clipboard


opt.number = true             -- line numbers
opt.relativenumber = true
opt.termguicolors = true
opt.cursorline = true         -- marks current line
opt.scrolloff = 8             -- 8 lines gap to top and bottom


-- search
opt.ignorecase = true
opt.smartcase = true          -- don't ignore case when enter upper case


-- indentation
opt.tabstop = 4               -- tab width
opt.shiftwidth = 4            -- indent width
opt.softtabstop = 4           -- soft tab stop
opt.expandtab = true          -- use spaces instead of tabs
opt.smartindent = true        -- smart auto-indenting
opt.autoindent = true         -- copy indent from current line
