-- ============================================================================
--  keymaps.lua — global key mappings
--
--  Note: vim.g.mapleader is set in init.lua (must happen before loading
--  plugins) and must NOT be set again here.
--  Plugin-specific mappings live with their respective plugin (e.g. telescope.lua).
-- ============================================================================

local map = vim.keymap.set

-- noremap: don't resolve recursively; silent: don't show the command in the cmdline
local opts = { noremap = true, silent = true }

-- "jj" in Insert mode as an Escape substitute (fingers stay on the home row)
map("i", "jj", "<Esc>", vim.tbl_extend("force", opts, { desc = "Leave insert mode" }))

-- Toggle file tree
map("n", "<leader>e", "<cmd>Neotree toggle<cr>",
    vim.tbl_extend("force", opts, { desc = "Toggle Neo-tree" }))

--[[ ---------------------------------------------------------------------------
  Deliberately disabled mappings — uncomment individually as needed.
  (Collected here so the active mappings above stay easy to read.)

  Save / quit
map("n", "<leader>w", "<cmd>w<cr>", opts)
map("n", "<leader>q", "<cmd>q<cr>", opts)
map("n", "<leader>Q", "<cmd>qa<cr>", opts)

  Warning: overwrites the built-in J (join lines) and K (help/hover)
map("n", "J", "5j", opts)
map("n", "K", "5k", opts)
map("v", "J", "5j", opts)
map("v", "K", "5k", opts)

  Switch windows without <C-w>
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

  Splits
map("n", "<leader>sv", "<cmd>vsplit<cr>", opts)
map("n", "<leader>sh", "<cmd>split<cr>", opts)

  Window size
map("n", "<leader>=", "<C-w>+", opts)
map("n", "<leader>-", "<C-w>-", opts)
map("n", "<leader>>", "<C-w>>", opts)
map("n", "<leader><", "<C-w><", opts)

  Buffer navigation
map("n", "<Tab>", "<cmd>bnext<cr>", opts)
map("n", "<S-Tab>", "<cmd>bprevious<cr>", opts)
map("n", "<leader>bd", "<cmd>bdelete<cr>", opts)

  Clear search highlighting
map("n", "<leader>nh", "<cmd>nohlsearch<cr>", opts)
--]]
