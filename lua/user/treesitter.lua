-- ============================================================================
--  treesitter.lua — Syntax-Highlighting über Treesitter
--
--  Neovim 0.12 bringt die Parser c, lua, markdown, markdown_inline, query,
--  vim und vimdoc bereits mit, startet Treesitter von sich aus aber nur in
--  den mitgelieferten ftplugins für help, lua, markdown und query
--  (siehe $VIMRUNTIME/ftplugin/). Für c, vim, vimdoc — und für jeden Parser,
--  der später manuell in ~/AppData/Local/nvim/parser/ landet — braucht es
--  diesen Autocmd. Ein Plugin wie nvim-treesitter ist dafür nicht nötig.
-- ============================================================================

-- Ab dieser Dateigrösse wird Treesitter abgeschaltet. Bei Logs, minifiziertem
-- JS oder Dumps kostet das Parsen sonst spürbar Zeit; Neovim fällt dann auf
-- das klassische Regex-Highlighting zurück.
local MAX_FILESIZE = 1024 * 1024 -- 1 MB

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("user_treesitter", { clear = true }),
    callback = function(ev)
        local name = vim.api.nvim_buf_get_name(ev.buf)
        -- fs_stat liefert nil bei neuen/namenlosen Puffern (dann: kein Limit)
        local stat = name ~= "" and vim.uv.fs_stat(name) or nil

        if stat and stat.size > MAX_FILESIZE then
            -- Wichtig: nicht bloss "nicht starten". Die eingebauten ftplugins
            -- (lua, markdown, help, query) laufen VOR diesem Autocmd und haben
            -- Treesitter dort bereits aktiviert — also aktiv wieder stoppen.
            pcall(vim.treesitter.stop, ev.buf)
            return
        end

        -- Fehlt der Parser für diesen Filetype, wirft vim.treesitter.start()
        -- einen Fehler — pcall fängt ihn ab, damit der Start nicht bricht.
        pcall(vim.treesitter.start, ev.buf)
    end,
})
