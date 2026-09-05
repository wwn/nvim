-- ============================================================================
--  autocmds.lua — filetype detection and filetype-dependent settings
-- ============================================================================

-- Also recognize the uppercase extension ".MD" as Markdown.
-- (Neovim compares the extension case-sensitively, even on Windows.)
vim.filetype.add({ extension = { MD = "markdown" } })

-- 2-space indentation is convention in web/frontend files (Prettier & co.).
-- opt_local only affects the respective buffer; the global 4 from options.lua
-- remain in effect for all other filetypes.
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
