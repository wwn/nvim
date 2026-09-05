-- ============================================================================
--  telescope.lua — Fuzzy-Finder
--
--  Externe Werkzeuge (beide vorhanden, per winget installiert):
--    ripgrep (rg) -> live_grep
--    fd           -> find_files (respektiert .gitignore, überspringt .git/)
--  Fehlen sie, fällt Telescope auf langsamere Vim-interne Suche zurück.
-- ============================================================================

require("telescope").setup({})

local builtin = require("telescope.builtin")
local map = vim.keymap.set

-- desc erscheint in :map und in Which-Key-artigen Hilfen
local function opts(desc)
    return { noremap = true, silent = true, desc = desc }
end

map("n", "<leader>ff", builtin.find_files, opts("Telescope: Dateien suchen"))
map("n", "<leader>fg", builtin.live_grep,  opts("Telescope: Text suchen (ripgrep)"))
map("n", "<leader>fb", builtin.buffers,    opts("Telescope: offene Buffer"))
map("n", "<leader>fh", builtin.help_tags,  opts("Telescope: Hilfe durchsuchen"))
