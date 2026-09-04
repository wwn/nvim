require("user.keymaps")-- <dirname.filename>
require("user.options")
require("user.autocmds")
require("user.treesitter")
require("user.markdown")
require("user.lualine")
require("user.neotree")
require("user.telescope")
require("user.alpha")

--[[
require("user.diagnostics")
--]]

-- nur ins Home wechseln, wenn nvim ohne Datei-Argument gestartet wurde
-- (sonst suchen Telescope und Neo-tree im Home statt im Projekt)
if vim.fn.argc() == 0 then
    vim.cmd("cd ~")
end
vim.cmd.colorscheme('jb')
