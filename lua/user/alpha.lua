-- ============================================================================
--  alpha.lua — start screen with a Vim cheat sheet
--
--  Layout: three equal-width columns laid out row by row side by side.
--  For the columns to line up cleanly, everything is computed using
--  *display width* (vim.fn.strdisplaywidth), not byte length (#s).
--  Characters like "→" or "─" take up multiple bytes but only
--  one screen column — with # all following columns would shift out of place.
-- ============================================================================

local alpha = require("alpha")

-- ---------------------------------------------------------------------------
-- Header line: version info
-- ---------------------------------------------------------------------------
local v = vim.version()
local info_lines = { string.format("  NVIM v%d.%d.%d", v.major, v.minor, v.patch) }
if vim.g.neovide then
    -- Neovide sets g:neovide_version itself; older versions lack it.
    local nv = vim.g.neovide_version
    table.insert(info_lines, nv and string.format("  Neovide v%s", nv) or "  Neovide")
end

local header = {
    type = "text",
    val = info_lines,
    opts = { position = "left", hl = "Title" },
}

-- ---------------------------------------------------------------------------
-- Column geometry
-- ---------------------------------------------------------------------------
local KW, DW = 12, 15      -- keybind width / description width
                           -- KW=12: even the longest keybind ("gu{m}/gU{m}")
                           -- still keeps one separating space
local COL_W = KW + DW      -- 27 screen columns per column
local GAP = "  "           -- gap between the columns

-- Display width instead of byte length (see comment above)
local width = vim.fn.strdisplaywidth

-- Pad to a fixed width; texts that are too long are not truncated,
-- the line just ends up a bit wider then.
local function pad(s, w)
    return s .. string.rep(" ", math.max(0, w - width(s)))
end

-- One cheat-sheet line: "<keybind>   <description>"
local function entry(k, d)
    return pad(k or "", KW) .. pad(d or "", DW)
end

-- Section heading: "── TITLE ──────────────" at exactly COL_W width
local function hdr(title)
    -- 4 = display width of "── " (3) plus the space after the title
    return "── " .. title .. " " .. string.rep("─", math.max(0, COL_W - width(title) - 4))
end

-- ---------------------------------------------------------------------------
-- Column contents
-- ---------------------------------------------------------------------------
local col1 = {
    hdr("FILES"),
    entry(":e <file>",  "open file"),
    entry(":w",         "save"),
    entry(":wa",        "save all"),
    entry(":wq / :x",   "save & quit"),
    entry(":q!",        "force quit"),
    entry(":saveas",    "save as"),
    entry("gf",         "open @cursor"),
    entry(":r <file>",  "read into buf"),
    entry(":cd %:h",    "cd to file dir"),
    hdr("BUFFERS"),
    entry(":bn / :bp",  "next/prev buf"),
    entry(":bd",        "delete buf"),
    entry(":ls",        "list buffers"),
    entry("<C-^>",      "last buffer"),
    entry(":b <n>",     "go to buf n"),
    hdr("CUSTOM"),
    entry("<leader>e",  "neotree toggle"),
    entry("<leader>ff", "find files"),
    entry("<leader>fg", "grep text"),
    entry("<leader>fb", "buffers"),
    entry("<leader>fh", "help tags"),
    entry("jj",         "→ <Esc>"),
}

local col2 = {
    hdr("WINDOWS"),
    entry("<C-w>s/v",    "split h / v"),
    entry("<C-w>hjkl",   "navigate wins"),
    entry("<C-w>q",      "close window"),
    entry("<C-w>=",      "equalize wins"),
    entry("<C-w>o",      "only window"),
    hdr("TABS"),
    entry("gt / gT",     "next/prev tab"),
    entry(":tabnew",     "new tab"),
    entry(":tabclose",   "close tab"),
    hdr("JUMPS"),
    entry("<C-o>",       "jump back"),
    entry("<C-i>",       "jump forward"),
    entry("''",          "last position"),
    entry("g;",          "last edit pos"),
    hdr("VISUAL"),
    entry("v",           "char-wise"),
    entry("V",           "line-wise"),
    entry("<C-v>",       "block select"),
    entry("gv",          "reselect"),
    entry("> / <",       "indent/dedent"),
    entry("~",           "toggle case"),
    entry("gu{m}/gU{m}", "lower/upper"),
}

local col3 = {
    hdr("EDIT"),
    entry("y / yy",      "yank / line"),
    entry("p / P",       "paste aft/bef"),
    entry("d / dd",      "cut / line"),
    entry("J",           "join lines"),
    entry(".",           "repeat last"),
    entry("u / <C-r>",   "undo / redo"),
    entry("<C-a>/<C-x>", "inc/dec num"),
    hdr("TEXT OBJECTS"),
    entry("ciw / diw",   "chg/del word"),
    entry('ci" / di"',   'chg/del "..."'),
    entry("ci( / di(",   "chg/del (...)"),
    entry("%",           "jump bracket"),
    hdr("SEARCH"),
    entry("/pattern",    "search fwd"),
    entry("n / N",       "next/prev"),
    entry("* / #",       "word fwd/bwd"),
    entry(":%s/o/n/g",   "replace all"),
    entry(":nohl",       "clear highl"),
    hdr("MARKS & MACROS"),
    entry("ma / 'a",     "set/jump mark"),
    entry("q<x> / @<x>", "rec/play macro"),
}

-- ---------------------------------------------------------------------------
-- Lay the columns out side by side
-- ---------------------------------------------------------------------------
-- In narrow windows, only show as many columns as fit —
-- otherwise alpha would wrap the overly long lines and the grid would fall apart.
local all_cols = { col1, col2, col3 }
local usable = math.max(1, math.floor(vim.o.columns / (COL_W + #GAP)))
local cols = {}
for i = 1, math.min(#all_cols, usable) do
    cols[i] = all_cols[i]
end

local max_rows = 0
for _, c in ipairs(cols) do
    max_rows = math.max(max_rows, #c)
end

local lines = {}
for row = 1, max_rows do
    local parts = {}
    for i, c in ipairs(cols) do
        -- Don't pad the last column: saves trailing spaces at the end of the line.
        local cell = c[row] or ""
        parts[#parts + 1] = GAP .. (i < #cols and pad(cell, COL_W) or cell)
    end
    lines[row] = table.concat(parts)
end

local cheatsheet = {
    type = "text",
    val = lines,
    opts = { position = "center", hl = "Comment" },
}

alpha.setup({
    layout = {
        { type = "padding", val = 1 },
        header,
        { type = "padding", val = 2 },
        cheatsheet,
        { type = "padding", val = 2 },
    },
    opts = {},
})
