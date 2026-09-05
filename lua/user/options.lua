-- ============================================================================
--  options.lua — Grundeinstellungen des Editors
--  Nachschlagen: :h 'optionsname'  (z. B. :h 'scrolloff')
-- ============================================================================

local opt = vim.opt

-- ---------------------------------------------------------------------------
-- Provider abschalten
-- ---------------------------------------------------------------------------
-- Es sind keine externen Sprach-Provider installiert. Ohne diese Zeilen meldet
-- :checkhealth vier Warnungen und Neovim sucht beim Start unnötig nach node,
-- perl, python3 und ruby.
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

-- ---------------------------------------------------------------------------
-- Darstellung
-- ---------------------------------------------------------------------------
-- Helle Variante des Colorschemes (jb.nvim wertet 'background' aus).
vim.o.background = "light"

-- Echte 24-Bit-Farben (in 0.12 meist schon Default, hier explizit für Neovide
-- und ältere Terminals).
opt.termguicolors = true

-- Maus in allen Modi
opt.mouse = "a"

-- Systemzwischenablage mit y/p teilen (unter Windows: win32yank/Windows-Clipboard)
opt.clipboard = "unnamedplus"

-- Zeilennummern: absolute Nummer der Cursorzeile + relative Nummern darum
-- (relativ = praktisch für Bewegungen wie 5j / 12k)
opt.number = true
opt.relativenumber = true

-- Aktuelle Zeile hervorheben
opt.cursorline = true

-- Beim Scrollen immer 8 Zeilen Kontext über/unter dem Cursor behalten
opt.scrolloff = 8

-- Spalte für Zeichen (Diagnostics, Git) immer reservieren, damit der Text
-- nicht seitlich springt, sobald ein Zeichen erscheint.
opt.signcolumn = "yes"

-- ---------------------------------------------------------------------------
-- Suchen
-- ---------------------------------------------------------------------------
-- Gross-/Kleinschreibung ignorieren …
opt.ignorecase = true
-- … ausser die Suchanfrage enthält selbst Grossbuchstaben (braucht ignorecase)
opt.smartcase = true

-- ---------------------------------------------------------------------------
-- Zeilenumbruch
-- ---------------------------------------------------------------------------
-- Lange Zeilen optisch umbrechen (Default: an)
opt.wrap = true
-- Nur an Wortgrenzen umbrechen, nicht mitten im Wort
opt.linebreak = true
-- Umbrochene Zeilen auf Einrückungshöhe fortsetzen
opt.breakindent = true

-- ---------------------------------------------------------------------------
-- Einrückung (Default 4 Spaces; Web-Filetypes auf 2 → siehe autocmds.lua)
-- ---------------------------------------------------------------------------
opt.tabstop = 4      -- Breite eines echten Tabulatorzeichens
opt.shiftwidth = 4   -- Breite eines Einrückungsschritts (>>, <<, autoindent)
opt.softtabstop = 4  -- Breite, die <Tab>/<BS> im Insert-Mode bewegen
opt.expandtab = true -- <Tab> erzeugt Leerzeichen statt Tabulatoren
opt.autoindent = true -- Einrückung der Vorzeile übernehmen
-- opt.smartindent = true -- absichtlich aus: kollidiert mit Treesitter-Indent
                          -- und schiebt z. B. '#' in Python an den Zeilenanfang

-- ---------------------------------------------------------------------------
-- Vervollständigung (eingebaut, ohne cmp/blink)
-- ---------------------------------------------------------------------------
-- 'autocomplete' (neu in 0.12): Popup erscheint automatisch beim Tippen.
opt.autocomplete = true
-- "noselect": nichts ist vorausgewählt, <CR> fügt also keinen Vorschlag ein,
-- sondern eine neue Zeile. Ohne das ist Autocomplete beim Schreiben lästig.
-- "menu,popup" sind die Neovim-Defaults (Menü + Doku-Fenster daneben).
opt.completeopt = { "menu", "popup", "noselect" }

-- ---------------------------------------------------------------------------
-- Dateien / Verhalten
-- ---------------------------------------------------------------------------
-- Undo-Historie über Sitzungen hinweg (~/AppData/Local/nvim-data/undo)
opt.undofile = true

-- Splits nach rechts bzw. unten öffnen (statt links/oben)
opt.splitright = true
opt.splitbelow = true

-- Kürzeres CursorHold-Intervall (Swapfile-Schreiben, Plugin-Timer). Default 4000.
opt.updatetime = 250

-- Bei :q mit ungespeicherten Änderungen nachfragen statt abzubrechen
opt.confirm = true
