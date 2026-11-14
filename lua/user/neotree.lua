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
        -- Show hidden, system and gitignored files by default ("H" still toggles).
        filtered_items = {
            hide_dotfiles = false,   -- .gitignore, .github/, .env …
            hide_gitignored = false, -- node_modules, build output …
            hide_hidden = false,     -- Windows "hidden" attribute
            hide_by_name = {},       -- default hides .DS_Store and thumbs.db
        },
    },
})
