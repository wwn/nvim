-- ============================================================================
--  neotree.lua — file tree in the sidebar
--  Toggle: <leader>e  (mapping in lua/user/keymaps.lua)
-- ============================================================================

require("neo-tree").setup({
    -- Sort case-insensitively, otherwise on Linux/macOS all uppercase
    -- entries would come first.
    sort_case_insensitive = true,

    window = {
        width = 30,
    },

    filesystem = {
        -- Tree automatically follows the currently active buffer and expands
        -- the matching folder.
        follow_current_file = {
            enabled = true,
        },
        -- Replace netrw so that `nvim .` or `:e <folder>` opens neo-tree.
        hijack_netrw_behavior = "open_default",
    },
})
