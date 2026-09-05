-- ============================================================================
--  options.lua — editor base settings
--  Look up: :h 'optionsname'  (e.g. :h 'scrolloff')
-- ============================================================================

local opt = vim.opt

-- ---------------------------------------------------------------------------
-- Disable providers
-- ---------------------------------------------------------------------------
-- No external language providers are installed. Without these lines
-- :checkhealth reports four warnings and Neovim needlessly searches for node,
-- perl, python3 and ruby on startup.
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

-- ---------------------------------------------------------------------------
-- Appearance
-- ---------------------------------------------------------------------------
-- Light variant of the colorscheme (jb.nvim reads 'background').
vim.o.background = "light"

-- True 24-bit colors (usually already the default in 0.12, explicit here for
-- Neovide and older terminals).
opt.termguicolors = true

-- Mouse in all modes
opt.mouse = "a"

-- Share the system clipboard with y/p (on Windows: win32yank/Windows clipboard)
opt.clipboard = "unnamedplus"

-- Line numbers: absolute number of the cursor line + relative numbers around it
-- (relative = handy for movements like 5j / 12k)
opt.number = true
opt.relativenumber = true

-- Highlight the current line
opt.cursorline = true

-- Always keep 8 lines of context above/below the cursor while scrolling
opt.scrolloff = 8

-- Always reserve a column for signs (diagnostics, git) so text doesn't
-- shift sideways as soon as a sign appears.
opt.signcolumn = "yes"

-- ---------------------------------------------------------------------------
-- Search
-- ---------------------------------------------------------------------------
-- Ignore case …
opt.ignorecase = true
-- … unless the search query itself contains uppercase letters (needs ignorecase)
opt.smartcase = true

-- ---------------------------------------------------------------------------
-- Line wrapping
-- ---------------------------------------------------------------------------
-- Visually wrap long lines (default: on)
opt.wrap = true
-- Only wrap at word boundaries, not in the middle of a word
opt.linebreak = true
-- Continue wrapped lines at the indentation level
opt.breakindent = true

-- ---------------------------------------------------------------------------
-- Indentation (default 4 spaces; web filetypes to 2 → see autocmds.lua)
-- ---------------------------------------------------------------------------
opt.tabstop = 4      -- Width of an actual tab character
opt.shiftwidth = 4   -- Width of one indentation step (>>, <<, autoindent)
opt.softtabstop = 4  -- Width that <Tab>/<BS> move in Insert mode
opt.expandtab = true -- <Tab> produces spaces instead of tab characters
opt.autoindent = true -- Carry over the previous line's indentation
-- opt.smartindent = true -- deliberately off: conflicts with Treesitter indent
                          -- and e.g. pushes '#' in Python to the start of the line

-- ---------------------------------------------------------------------------
-- Completion (built-in, without cmp/blink)
-- ---------------------------------------------------------------------------
-- 'autocomplete' (new in 0.12): popup appears automatically while typing.
opt.autocomplete = true
-- "noselect": nothing is preselected, so <CR> doesn't insert a suggestion
-- but a new line. Without this, autocomplete gets annoying while writing.
-- "menu,popup" are the Neovim defaults (menu + doc window beside it).
opt.completeopt = { "menu", "popup", "noselect" }

-- ---------------------------------------------------------------------------
-- Files / behavior
-- ---------------------------------------------------------------------------
-- Undo history across sessions (~/AppData/Local/nvim-data/undo)
opt.undofile = true

-- Open splits to the right / below (instead of left/above)
opt.splitright = true
opt.splitbelow = true

-- Shorter CursorHold interval (swapfile writes, plugin timers). Default 4000.
opt.updatetime = 250

-- Ask for confirmation on :q with unsaved changes instead of aborting
opt.confirm = true
