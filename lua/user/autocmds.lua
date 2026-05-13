-- .md -> uppercase .MD extension → markdown filetype
vim.filetype.add({ extension = { MD = "markdown" } })

-- space indentation for web/frontend filetypes
vim.api.nvim_create_autocmd("FileType", {
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
