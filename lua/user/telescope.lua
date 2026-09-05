-- ============================================================================
--  telescope.lua — fuzzy finder
--
--  External tools (both present, installed via winget):
--    ripgrep (rg) -> live_grep
--    fd           -> find_files (respects .gitignore, skips .git/)
--  If missing, Telescope falls back to slower Vim-internal search.
-- ============================================================================

require("telescope").setup({})

local builtin = require("telescope.builtin")
local map = vim.keymap.set

-- desc shows up in :map and in which-key-style help
local function opts(desc)
    return { noremap = true, silent = true, desc = desc }
end

map("n", "<leader>ff", builtin.find_files, opts("Telescope: find files"))
map("n", "<leader>fg", builtin.live_grep,  opts("Telescope: search text (ripgrep)"))
map("n", "<leader>fb", builtin.buffers,    opts("Telescope: open buffers"))
map("n", "<leader>fh", builtin.help_tags,  opts("Telescope: search help"))
