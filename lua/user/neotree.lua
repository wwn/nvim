-- ============================================================================
--  neotree.lua — Dateibaum in der Seitenleiste
--  Umschalten: <leader>e  (Mapping in lua/user/keymaps.lua)
-- ============================================================================

require("neo-tree").setup({
    -- Sortierung ohne Beachtung der Gross-/Kleinschreibung, sonst stünden auf
    -- Linux/macOS alle Grossbuchstaben-Einträge zuerst.
    sort_case_insensitive = true,

    window = {
        width = 30,
    },

    filesystem = {
        -- Baum folgt automatisch dem gerade aktiven Puffer und klappt den
        -- passenden Ordner auf.
        follow_current_file = {
            enabled = true,
        },
        -- netrw ersetzen, damit `nvim .` bzw. `:e <ordner>` neo-tree öffnet.
        hijack_netrw_behavior = "open_default",
    },
})
