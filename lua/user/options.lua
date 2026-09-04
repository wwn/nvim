local opt = vim.opt

vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

vim.o.background = 'light'

-- allows mouse actions
opt.mouse = "a"
-- synchc clipboard
opt.clipboard = "unnamedplus"


-- line numbers
opt.number = true
opt.relativenumber = true
opt.termguicolors = true
-- marks current line
opt.cursorline = true
-- 8 lines gap to top and bottom
opt.scrolloff = 8


-- search
opt.ignorecase = true
-- don't ignore case when enter upper case
opt.smartcase = true

-- enable wrap (default: true)
opt.wrap = true
-- wrap only at word boundaries
opt.linebreak = true
-- keep indentation when wrapping (nicer!)
opt.breakindent = true

-- indentation
-- tab width
opt.tabstop = 4
-- indent width
opt.shiftwidth = 4
-- soft tab stop
opt.softtabstop = 4
-- use spaces instead of tabs
opt.expandtab = true
-- smart auto-indenting
-- opt.smartindent = true
-- copy indent from current line
opt.autoindent = true

-- native autocompletion
opt.autocomplete = true
