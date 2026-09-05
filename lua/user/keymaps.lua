-- ============================================================================
--  keymaps.lua — globale Tastenbelegungen
--
--  Hinweis: vim.g.mapleader wird in init.lua gesetzt (muss vor dem Laden der
--  Plugins passieren) und darf hier NICHT erneut gesetzt werden.
--  Plugin-eigene Mappings stehen beim jeweiligen Plugin (z. B. telescope.lua).
-- ============================================================================

local map = vim.keymap.set

-- noremap: nicht rekursiv auflösen; silent: Befehl nicht in der Cmdline zeigen
local opts = { noremap = true, silent = true }

-- "jj" im Insert-Mode als Escape-Ersatz (Finger bleiben auf der Grundreihe)
map("i", "jj", "<Esc>", vim.tbl_extend("force", opts, { desc = "Insert-Mode verlassen" }))

-- Dateibaum ein-/ausblenden
map("n", "<leader>e", "<cmd>Neotree toggle<cr>",
    vim.tbl_extend("force", opts, { desc = "Neo-tree umschalten" }))

--[[ ---------------------------------------------------------------------------
  Bewusst deaktivierte Mappings — bei Bedarf einzeln wieder einkommentieren.
  (Gesammelt hier, damit die aktiven Mappings oben übersichtlich bleiben.)

  Speichern / Beenden
map("n", "<leader>w", "<cmd>w<cr>", opts)
map("n", "<leader>q", "<cmd>q<cr>", opts)
map("n", "<leader>Q", "<cmd>qa<cr>", opts)

  Achtung: überschreibt die eingebauten J (Zeilen verbinden) und K (Hilfe/hover)
map("n", "J", "5j", opts)
map("n", "K", "5k", opts)
map("v", "J", "5j", opts)
map("v", "K", "5k", opts)

  Fensterwechsel ohne <C-w>
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

  Splits
map("n", "<leader>sv", "<cmd>vsplit<cr>", opts)
map("n", "<leader>sh", "<cmd>split<cr>", opts)

  Fenstergrösse
map("n", "<leader>=", "<C-w>+", opts)
map("n", "<leader>-", "<C-w>-", opts)
map("n", "<leader>>", "<C-w>>", opts)
map("n", "<leader><", "<C-w><", opts)

  Buffer-Navigation
map("n", "<Tab>", "<cmd>bnext<cr>", opts)
map("n", "<S-Tab>", "<cmd>bprevious<cr>", opts)
map("n", "<leader>bd", "<cmd>bdelete<cr>", opts)

  Suchhervorhebung löschen
map("n", "<leader>nh", "<cmd>nohlsearch<cr>", opts)
--]]
