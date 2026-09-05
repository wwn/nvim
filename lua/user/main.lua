-- ============================================================================
--  main.lua — lädt alle Teilmodule in fester Reihenfolge
--
--  Die Reihenfolge ist bewusst gewählt:
--    keymaps/options/autocmds  -> reines Neovim, keine Plugin-Abhängigkeit
--    treesitter ... alpha      -> jeweils ein Plugin, setup() direkt beim Laden
--  Modulname = <Verzeichnis>.<Dateiname> relativ zu lua/
-- ============================================================================

require("user.keymaps")     -- Leader-Mappings (Leader selbst kommt aus init.lua)
require("user.options")     -- vim.opt / vim.o Grundeinstellungen
require("user.autocmds")    -- Filetype-Erkennung und -abhängige Einstellungen
require("user.treesitter")  -- Syntax-Highlighting via Treesitter
require("user.markdown")    -- render-markdown.nvim
require("user.lualine")     -- Statuszeile
require("user.neotree")     -- Dateibaum
require("user.telescope")   -- Fuzzy-Finder + <leader>f… Mappings
require("user.alpha")       -- Startbildschirm

--[[ noch nicht vorhanden / geplant:
require("user.diagnostics")
--]]

-- Nur ins Home wechseln, wenn nvim ohne Datei-Argument gestartet wurde.
-- (Sonst würden Telescope und Neo-tree im Home statt im Projekt suchen.)
-- argc() == 0 heisst: reines `nvim`; `nvim datei` oder `nvim .` bleibt im
-- aktuellen Verzeichnis.
if vim.fn.argc() == 0 then
    vim.cmd("cd ~")
end

-- Colorscheme zuletzt: setzt Highlight-Gruppen, die manche Plugins beim
-- setup() bereits registriert haben, korrekt neu.
vim.cmd.colorscheme("jb")
