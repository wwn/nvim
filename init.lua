vim.loader.enable()

vim.pack.add {
    'https://github.com/nickkadutskyi/jb.nvim',
    'https://github.com/nvim-lualine/lualine.nvim',

    -- neo-tree
    'https://github.com/nvim-neo-tree/neo-tree.nvim',
    'https://github.com/nvim-lua/plenary.nvim',
    'https://github.com/MunifTanjim/nui.nvim',
    -- fuzzy finder
    'https://github.com/nvim-telescope/telescope.nvim',
}

require("user.main") -- require("config") would search for lua/config/init.lua

if vim.g.neovide then
    vim.g.neovide_font_features = "-calt, -liga, -dlig, -clig"

    local os_name = vim.uv.os_uname().sysname
    if os_name == "Darwin" then
        vim.o.guifont = "JetBrainsMonoNL Nerd Font Mono:h16"
    elseif os_name == "Windows_NT" then
        vim.o.guifont = "JetBrainsMonoNL Nerd Font Mono:h12"
    else
        vim.o.guifont = "JetBrainsMonoNL Nerd Font Mono:h12"
    end

    vim.g.neovide_cursor_vfx_mode = "railgun"
end
