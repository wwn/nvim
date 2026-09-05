-- ============================================================================
--  init.lua — Einstiegspunkt der Konfiguration (Neovim >= 0.12)
--
--  Reihenfolge ist wichtig:
--    1. Leader-Tasten setzen  (VOR dem Laden von Plugins!)
--    2. Plugins registrieren  (vim.pack.add lädt sofort/synchron)
--    3. Eigene Module laden   (lua/user/*)
--    4. GUI-Spezifisches      (nur unter Neovide)
-- ============================================================================

-- Schnellerer Lua-Modul-Loader (Bytecode-Cache) — sollte ganz oben stehen.
vim.loader.enable()

-- ---------------------------------------------------------------------------
-- 1. Leader-Tasten
-- ---------------------------------------------------------------------------
-- Muss VOR vim.pack.add() stehen: Mappings, die ein Plugin beim Laden anlegt,
-- lösen "<leader>" sofort auf. Wird der Leader erst danach gesetzt, hängen
-- solche Mappings noch am alten Default ("\").
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ---------------------------------------------------------------------------
-- 2. Plugins
-- ---------------------------------------------------------------------------
-- vim.pack ist der in Neovim 0.12 eingebaute Plugin-Manager. Die installierten
-- Commits stehen in nvim-pack-lock.json (im Repo eingecheckt = reproduzierbar).
--   :lua vim.pack.update()   -> aktualisiert und schreibt den Lockfile neu
--   :lua vim.pack.get()      -> zeigt Status aller Plugins
-- Optional lässt sich pro Eintrag pinnen: { src = '...', version = 'v1.2.3' }
vim.pack.add {
    -- Colorscheme (JetBrains-Look), wird in lua/user/main.lua aktiviert
    'https://github.com/nickkadutskyi/jb.nvim',
    -- Statuszeile
    'https://github.com/nvim-lualine/lualine.nvim',

    -- Icons (Voraussetzung für neo-tree, lualine, telescope, render-markdown)
    -- Braucht eine installierte Nerd Font im Terminal / in Neovide.
    'https://github.com/nvim-tree/nvim-web-devicons',

    -- Dateibaum (neo-tree) + dessen zwingende Abhängigkeiten
    'https://github.com/nvim-neo-tree/neo-tree.nvim',
    'https://github.com/nvim-lua/plenary.nvim',  -- Lua-Utilities (auch von telescope genutzt)
    'https://github.com/MunifTanjim/nui.nvim',   -- UI-Komponenten für neo-tree

    -- Fuzzy-Finder (nutzt extern: ripgrep für live_grep, fd für find_files)
    'https://github.com/nvim-telescope/telescope.nvim',

    -- Markdown-Vorschau direkt im Puffer (Tabellen, fett, Links, Checkboxen)
    'https://github.com/MeanderingProgrammer/render-markdown.nvim',

    -- Startbildschirm / Dashboard
    'https://github.com/goolord/alpha-nvim',
}

-- ---------------------------------------------------------------------------
-- 3. Eigene Module
-- ---------------------------------------------------------------------------
-- "user.main" == lua/user/main.lua. (require("user") würde stattdessen nach
-- lua/user/init.lua suchen.)
require("user.main")

-- ---------------------------------------------------------------------------
-- 4. Neovide (GUI) — wird im Terminal-Neovim komplett übersprungen
-- ---------------------------------------------------------------------------
if vim.g.neovide then
    -- Ligaturen: "vim.g.neovide_font_features" gibt es NICHT. Font-Features
    -- werden bei Neovide ausschliesslich in der eigenen Config-Datei gesetzt:
    --   %APPDATA%\neovide\config.toml
    --   [font.features]
    --   "JetBrainsMonoNL Nerd Font Mono" = ["-calt", "-liga", "-dlig", "-clig"]
    -- Hier unnötig, weil die "NL"-Variante von JetBrains Mono ohnehin
    -- ligaturfrei ist ("NL" = No Ligatures).

    -- Schriftgrösse je Plattform (macOS rendert Punktgrössen kleiner)
    local os_name = vim.uv.os_uname().sysname
    if os_name == "Darwin" then
        vim.o.guifont = "JetBrainsMonoNL Nerd Font Mono:h16"
    else -- Windows_NT, Linux
        vim.o.guifont = "JetBrainsMonoNL Nerd Font Mono:h12"
    end

    -- Partikeleffekt hinter dem Cursor (:h neovide_cursor_vfx_mode)
    vim.g.neovide_cursor_vfx_mode = "railgun"

    -- Fenstertransparenz (0.0 = unsichtbar, 1.0 = deckend)
    vim.g.neovide_opacity = 0.85
end
