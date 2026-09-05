-- ============================================================================
--  alpha.lua — Startbildschirm mit Vim-Spickzettel
--
--  Aufbau: drei gleich breite Spalten, die zeilenweise nebeneinandergelegt
--  werden. Damit die Spalten sauber untereinander stehen, wird durchgehend mit
--  der *Anzeigebreite* gerechnet (vim.fn.strdisplaywidth), nicht mit der
--  Byte-Länge (#s). Zeichen wie "→" oder "─" belegen mehrere Bytes, aber nur
--  eine Bildschirmspalte — mit # verrutschen sonst alle folgenden Spalten.
-- ============================================================================

local alpha = require("alpha")

-- ---------------------------------------------------------------------------
-- Kopfzeile: Versionsinfos
-- ---------------------------------------------------------------------------
local v = vim.version()
local info_lines = { string.format("  NVIM v%d.%d.%d", v.major, v.minor, v.patch) }
if vim.g.neovide then
    -- Neovide setzt g:neovide_version selbst; bei älteren Versionen fehlt es.
    local nv = vim.g.neovide_version
    table.insert(info_lines, nv and string.format("  Neovide v%s", nv) or "  Neovide")
end

local header = {
    type = "text",
    val = info_lines,
    opts = { position = "left", hl = "Title" },
}

-- ---------------------------------------------------------------------------
-- Spalten-Geometrie
-- ---------------------------------------------------------------------------
local KW, DW = 12, 15      -- Breite Tastenkürzel / Breite Beschreibung
                           -- KW=12: auch das längste Kürzel ("gu{m}/gU{m}")
                           -- behält noch ein Trennleerzeichen
local COL_W = KW + DW      -- 27 Bildschirmspalten pro Spalte
local GAP = "  "           -- Abstand zwischen den Spalten

-- Anzeigebreite statt Byte-Länge (siehe Kommentar oben)
local width = vim.fn.strdisplaywidth

-- Auf feste Breite auffüllen; zu lange Texte werden nicht abgeschnitten,
-- dann ist die Zeile eben etwas breiter.
local function pad(s, w)
    return s .. string.rep(" ", math.max(0, w - width(s)))
end

-- Eine Spickzettel-Zeile: "<Kürzel>   <Beschreibung>"
local function entry(k, d)
    return pad(k or "", KW) .. pad(d or "", DW)
end

-- Abschnittsüberschrift: "── TITEL ──────────────" auf exakt COL_W Breite
local function hdr(title)
    -- 4 = Anzeigebreite von "── " (3) plus das Leerzeichen nach dem Titel
    return "── " .. title .. " " .. string.rep("─", math.max(0, COL_W - width(title) - 4))
end

-- ---------------------------------------------------------------------------
-- Inhalt der Spalten
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
-- Spalten nebeneinanderlegen
-- ---------------------------------------------------------------------------
-- In schmalen Fenstern nur so viele Spalten zeigen, wie hineinpassen —
-- sonst würde alpha die zu langen Zeilen umbrechen und das Raster zerfiele.
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
        -- Letzte Spalte nicht auffüllen: spart Leerzeichen am Zeilenende.
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
