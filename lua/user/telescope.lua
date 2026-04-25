require("telescope").setup({})

local map = vim.keymap.set
local opts = { noremap = true, silent = true }
local builtin = require("telescope.builtin")

map("n", "<leader>ff", builtin.find_files, opts)  -- Dateien suchen
map("n", "<leader>fg", builtin.live_grep, opts)   -- Text suchen (braucht ripgrep!)
map("n", "<leader>fb", builtin.buffers, opts)     -- offene Buffer
map("n", "<leader>fh", builtin.help_tags, opts)   -- Hilfe durchsuchen