vim.treesitter.start = vim.treesitter.start or function() end

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "markdown", "lua", "vim", "query" },
    callback = function(ev)
        pcall(vim.treesitter.start, ev.buf)
    end,
})
