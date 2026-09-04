-- Treesitter-Highlighting fuer jeden Filetype versuchen.
-- Fehlt der Parser, schlaegt vim.treesitter.start fehl und pcall faengt das ab
-- (Neovim 0.12 bringt nur c, lua, markdown, markdown_inline, query, vim, vimdoc mit).
vim.api.nvim_create_autocmd("FileType", {
    callback = function(ev)
        pcall(vim.treesitter.start, ev.buf)
    end,
})
