-- ============================================================================
--  main.lua — loads all submodules in a fixed order
--
--  The order is chosen deliberately:
--    keymaps/options/autocmds  -> pure Neovim, no plugin dependency
--    treesitter ... alpha      -> one plugin each, setup() right when loaded
--  Module name = <directory>.<filename> relative to lua/
-- ============================================================================

require("user.keymaps")     -- Leader mappings (the leader itself comes from init.lua)
require("user.options")     -- vim.opt / vim.o base settings
require("user.autocmds")    -- Filetype detection and dependent settings
require("user.treesitter")  -- Syntax highlighting via Treesitter
require("user.markdown")    -- render-markdown.nvim
require("user.lualine")     -- Status line
require("user.neotree")     -- File tree
require("user.telescope")   -- Fuzzy finder + <leader>f… mappings
require("user.alpha")       -- Start screen

--[[ not yet present / planned:
require("user.diagnostics")
--]]

-- Only switch to home if nvim was started without a file argument.
-- (Otherwise Telescope and Neo-tree would search in home instead of the project.)
-- argc() == 0 means: plain `nvim`; `nvim file` or `nvim .` stays in the
-- current directory.
if vim.fn.argc() == 0 then
    vim.cmd("cd ~")
end

-- Colorscheme last: correctly re-applies highlight groups that some plugins
-- have already registered during their setup().
vim.cmd.colorscheme("jb")
