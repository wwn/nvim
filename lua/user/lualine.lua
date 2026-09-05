-- ============================================================================
--  lualine.lua — status line
-- ============================================================================

-- lualine already shows the mode (NORMAL/INSERT/…) itself; the built-in
-- display in the command line would be redundant.
vim.o.showmode = false

require("lualine").setup({
    options = {
        -- "auto" derives the colors from the active colorscheme (jb).
        theme = "auto",
        -- Separators need a Nerd Font; nvim-web-devicons is loaded.
        icons_enabled = true,
    },
})
