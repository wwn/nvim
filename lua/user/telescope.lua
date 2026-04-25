require("telescope").setup({})

local map = vim.keymap.set
local opts = { noremap = true, silent = true }
local builtin = require("telescope.builtin")

-- find files
map("n", "<leader>ff", builtin.find_files, opts)
-- search text (needs ripgrep!)
map("n", "<leader>fg", builtin.live_grep, opts)
-- open buffers
map("n", "<leader>fb", builtin.buffers, opts)
-- search help
map("n", "<leader>fh", builtin.help_tags, opts)