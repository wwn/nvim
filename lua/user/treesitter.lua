-- ============================================================================
--  treesitter.lua — syntax highlighting via Treesitter
--
--  Neovim 0.12 ships with the parsers c, lua, markdown, markdown_inline, query,
--  vim and vimdoc already included, but only starts Treesitter on its own in
--  the bundled ftplugins for help, lua, markdown and query
--  (see $VIMRUNTIME/ftplugin/). For c, vim, vimdoc — and for any parser
--  that later ends up manually in ~/AppData/Local/nvim/parser/ — this
--  autocmd is needed. A plugin like nvim-treesitter is not required for this.
-- ============================================================================

-- Treesitter is disabled above this file size. For logs, minified
-- JS, or dumps, parsing would otherwise cost noticeable time; Neovim then
-- falls back to classic regex highlighting.
local MAX_FILESIZE = 1024 * 1024 -- 1 MB

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("user_treesitter", { clear = true }),
    callback = function(ev)
        local name = vim.api.nvim_buf_get_name(ev.buf)
        -- fs_stat returns nil for new/unnamed buffers (then: no limit)
        local stat = name ~= "" and vim.uv.fs_stat(name) or nil

        if stat and stat.size > MAX_FILESIZE then
            -- Important: not just "don't start". The built-in ftplugins
            -- (lua, markdown, help, query) run BEFORE this autocmd and have
            -- already enabled Treesitter there — so actively stop it again.
            pcall(vim.treesitter.stop, ev.buf)
            return
        end

        -- If the parser for this filetype is missing, vim.treesitter.start()
        -- throws an error — pcall catches it so startup doesn't break.
        pcall(vim.treesitter.start, ev.buf)
    end,
})
