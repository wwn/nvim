-- ============================================================================
--  autocmds.lua — Filetype-Erkennung und filetype-abhängige Einstellungen
-- ============================================================================

-- Grossgeschriebene Endung ".MD" ebenfalls als Markdown erkennen.
-- (Neovim vergleicht die Endung case-sensitiv, auch auf Windows.)
vim.filetype.add({ extension = { MD = "markdown" } })

-- In Web-/Frontend-Dateien ist 2er-Einrückung Konvention (Prettier & Co.).
-- opt_local wirkt nur im jeweiligen Puffer, die globalen 4 aus options.lua
-- bleiben für alle anderen Filetypes bestehen.
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("user_indent", { clear = true }),
    pattern = {
        "typescript", "typescriptreact",
        "javascript", "javascriptreact",
        "html", "css", "scss", "less",
        "json", "jsonc",
        "yaml",
    },
    callback = function()
        vim.opt_local.tabstop = 2
        vim.opt_local.shiftwidth = 2
        vim.opt_local.softtabstop = 2
    end,
})
