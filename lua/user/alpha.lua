local alpha = require("alpha")

local v = vim.version()
local info_lines = { string.format("  NVIM v%d.%d.%d", v.major, v.minor, v.patch) }
if vim.g.neovide then
    local nv = vim.g.neovide_version
    table.insert(info_lines, nv and string.format("  Neovide v%s", nv) or "  Neovide")
end

local header = {
    type = "text",
    val = info_lines,
    opts = { position = "left", hl = "Title" },
}

local KW, DW = 11, 16
local COL_W = KW + DW  -- 27 Zeichen pro Spalte

local function entry(k, d)
    k, d = k or "", d or ""
    return k .. string.rep(" ", math.max(0, KW - #k))
           .. d .. string.rep(" ", math.max(0, DW - #d))
end

local function hdr(title)
    return "── " .. title .. " " .. string.rep("─", math.max(0, COL_W - #title - 4))
end

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

local max_rows = math.max(#col1, #col2, #col3)
local blank = string.rep(" ", COL_W)
local lines = {}
for i = 1, max_rows do
    lines[i] = "  " .. (col1[i] or blank)
             .. "  " .. (col2[i] or blank)
             .. "  " .. (col3[i] or "")
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
