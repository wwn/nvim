-- ============================================================================
--  lualine.lua — Statuszeile
-- ============================================================================

-- lualine zeigt den Modus (NORMAL/INSERT/…) bereits selbst an; die eingebaute
-- Anzeige in der Kommandozeile wäre doppelt gemoppelt.
vim.o.showmode = false

require("lualine").setup({
    options = {
        -- "auto" leitet die Farben aus dem aktiven Colorscheme (jb) ab.
        theme = "auto",
        -- Trennzeichen brauchen eine Nerd Font; nvim-web-devicons ist geladen.
        icons_enabled = true,
    },
})
