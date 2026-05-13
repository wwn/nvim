require("user.keymaps")-- <dirname.filename>
require("user.options")
require("user.autocmds")
require("user.treesitter")
require("user.markdown")
require("user.lualine")
require("user.neotree")
require("user.telescope")

--[[
require("user.diagnostics")
--]]

vim.cmd("cd ~")
vim.cmd.colorscheme('jb')
