-- ============================================================================
--  init.lua — entry point of the configuration (Neovim >= 0.12)
--
--  Order matters:
--    1. Set leader keys      (BEFORE loading plugins!)
--    2. Register plugins     (vim.pack.add loads immediately/synchronously)
--    3. Load own modules     (lua/user/*)
--    4. GUI-specific stuff   (only under Neovide)
-- ============================================================================

-- Faster Lua module loader (bytecode cache) — should be at the very top.
vim.loader.enable()

-- ---------------------------------------------------------------------------
-- 1. Leader keys
-- ---------------------------------------------------------------------------
-- Must come BEFORE vim.pack.add(): mappings a plugin creates while loading
-- resolve "<leader>" immediately. If the leader is set afterwards, such
-- mappings still stick to the old default ("\").
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ---------------------------------------------------------------------------
-- 2. Plugins
-- ---------------------------------------------------------------------------
-- vim.pack is the plugin manager built into Neovim 0.12. The installed
-- commits are recorded in nvim-pack-lock.json (checked into the repo = reproducible).
--   :lua vim.pack.update()   -> updates and rewrites the lockfile
--   :lua vim.pack.get()      -> shows the status of all plugins
-- Optionally pin per entry: { src = '...', version = 'v1.2.3' }
vim.pack.add {
    -- Colorscheme (JetBrains look), activated in lua/user/main.lua
    'https://github.com/nickkadutskyi/jb.nvim',
    -- Status line
    'https://github.com/nvim-lualine/lualine.nvim',

    -- Icons (required by neo-tree, lualine, telescope, render-markdown)
    -- Needs a Nerd Font installed in the terminal / in Neovide.
    'https://github.com/nvim-tree/nvim-web-devicons',

    -- File tree (neo-tree) + its required dependencies
    'https://github.com/nvim-neo-tree/neo-tree.nvim',
    'https://github.com/nvim-lua/plenary.nvim',  -- Lua utilities (also used by telescope)
    'https://github.com/MunifTanjim/nui.nvim',   -- UI components for neo-tree

    -- Fuzzy finder (uses externally: ripgrep for live_grep, fd for find_files)
    'https://github.com/nvim-telescope/telescope.nvim',

    -- Markdown preview directly in the buffer (tables, bold, links, checkboxes)
    'https://github.com/MeanderingProgrammer/render-markdown.nvim',

    -- Start screen / dashboard
    'https://github.com/goolord/alpha-nvim',
}

-- ---------------------------------------------------------------------------
-- 3. Own modules
-- ---------------------------------------------------------------------------
-- "user.main" == lua/user/main.lua. (require("user") would instead look for
-- lua/user/init.lua.)
require("user.main")

-- ---------------------------------------------------------------------------
-- 4. Neovide (GUI) — skipped entirely in terminal Neovim
-- ---------------------------------------------------------------------------
if vim.g.neovide then
    -- Ligatures: "vim.g.neovide_font_features" does NOT exist. Font features
    -- for Neovide are only set in its own config file:
    --   %APPDATA%\neovide\config.toml
    --   [font.features]
    --   "JetBrainsMonoNL Nerd Font Mono" = ["-calt", "-liga", "-dlig", "-clig"]
    -- Unnecessary here, since the "NL" variant of JetBrains Mono is already
    -- ligature-free ("NL" = No Ligatures).

    -- Font size per platform (macOS renders point sizes smaller)
    local os_name = vim.uv.os_uname().sysname
    if os_name == "Darwin" then
        vim.o.guifont = "JetBrainsMonoNL Nerd Font Mono:h16"
    else -- Windows_NT, Linux
        vim.o.guifont = "JetBrainsMonoNL Nerd Font Mono:h12"
    end

    -- Particle effect behind the cursor (:h neovide_cursor_vfx_mode)
    vim.g.neovide_cursor_vfx_mode = "railgun"

    -- Window transparency (0.0 = invisible, 1.0 = opaque)
    vim.g.neovide_opacity = 0.85
end
