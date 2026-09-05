-- ============================================================================
--  .github/ci/health.lua — Konfigurations- und Health-Check für die CI
--
--  Aufruf (die Config wird dabei ganz normal geladen):
--      nvim --headless -c "lua dofile(vim.env.CI_SCRIPT)"
--
--  "nvim -l script.lua" geht NICHT: -l überspringt die init.lua. Dann wären
--  weder die Module aus lua/user/ noch die per vim.pack.add aktivierten
--  Plugins sichtbar — der Check würde faktisch nichts prüfen.
--
--  Exitcode 0 = alles gut, 1 = mindestens ein ERROR.
--  WARNINGs brechen den Build nicht ab, stehen aber im Report.
-- ============================================================================

local errors, warns, infos = {}, {}, {}

local function err(fmt, ...)
    errors[#errors + 1] = select("#", ...) > 0 and fmt:format(...) or fmt
end
local function warn(fmt, ...)
    warns[#warns + 1] = select("#", ...) > 0 and fmt:format(...) or fmt
end
local function info(fmt, ...)
    infos[#infos + 1] = select("#", ...) > 0 and fmt:format(...) or fmt
end

local config_dir = vim.fn.stdpath("config")

-- ---------------------------------------------------------------------------
-- 1. Neovim-Version
-- ---------------------------------------------------------------------------
-- vim.pack gibt es erst ab 0.12; darunter startet die Config gar nicht.
local v = vim.version()
info("Neovim %d.%d.%d", v.major, v.minor, v.patch)
if vim.fn.has("nvim-0.12") == 0 then
    err("Neovim >= 0.12 nötig (vim.pack), gefunden: %d.%d.%d", v.major, v.minor, v.patch)
end
if vim.pack == nil then
    err("vim.pack ist nicht verfügbar — Plugin-Prüfung übersprungen")
end

-- ---------------------------------------------------------------------------
-- 2. Plugins gegen nvim-pack-lock.json
-- ---------------------------------------------------------------------------
-- vim.pack.get() listet alles, was auf dem packpath liegt. "active = true"
-- heisst: in dieser Session per vim.pack.add() aus der init.lua geladen.
if vim.pack ~= nil then
    local lock_path = config_dir .. "/nvim-pack-lock.json"
    local ok_lock, lock = pcall(function()
        return vim.json.decode(table.concat(vim.fn.readfile(lock_path), "\n")).plugins
    end)

    if not ok_lock or type(lock) ~= "table" then
        err("nvim-pack-lock.json nicht lesbar: %s", lock_path)
        lock = {}
    end

    local packs = vim.pack.get()
    local installed, active_count = {}, 0
    for _, p in ipairs(packs) do
        installed[p.spec.name] = p
        if p.active then
            active_count = active_count + 1
        end
    end
    info("Plugins: %d installiert, %d aktiv, %d im Lockfile",
        #packs, active_count, vim.tbl_count(lock))

    for name, entry in pairs(lock) do
        local p = installed[name]
        if not p then
            err("Plugin '%s' steht im Lockfile, ist aber nicht installiert", name)
        elseif not p.active then
            -- Im Lock, auf der Platte, aber von keiner vim.pack.add()-Zeile
            -- referenziert: Karteileiche aus einer früheren Config-Version.
            warn("Plugin '%s' ist installiert, wird von der Config aber nicht geladen", name)
        elseif entry.rev and p.rev and entry.rev ~= p.rev then
            -- Kein harter Fehler: bei einem frischen Clone kann der Upstream-
            -- HEAD vom gepinnten Commit abweichen. Sichtbar soll es trotzdem
            -- sein — genau dafür läuft der wöchentliche Lauf.
            warn("Plugin '%s': installiert %s, Lockfile %s",
                name, p.rev:sub(1, 8), entry.rev:sub(1, 8))
        end
    end

    for _, p in ipairs(packs) do
        if p.active and lock[p.spec.name] == nil then
            err("Plugin '%s' wird geladen, fehlt aber im Lockfile "
                .. "(:lua vim.pack.update() laufen lassen und Lockfile committen)",
                p.spec.name)
        end
    end
end

-- ---------------------------------------------------------------------------
-- 3. Eigene Module
-- ---------------------------------------------------------------------------
-- Jede Datei in lua/user/ sollte über user.main tatsächlich geladen worden
-- sein. Ein nicht geladenes Modul ist meist ein vergessenes require().
local loaded_user = 0
for name, _ in pairs(package.loaded) do
    if type(name) == "string" and name:match("^user%.") then
        loaded_user = loaded_user + 1
    end
end
for _, file in ipairs(vim.fn.glob(config_dir .. "/lua/user/*.lua", false, true)) do
    local mod = "user." .. vim.fn.fnamemodify(file, ":t:r")
    if package.loaded[mod] == nil then
        warn("Modul '%s' existiert, wurde aber nicht geladen "
            .. "(require in lua/user/main.lua vergessen?)", mod)
    end
end
info("Geladene user-Module: %d", loaded_user)

-- ---------------------------------------------------------------------------
-- 4. Externe Programme
-- ---------------------------------------------------------------------------
-- git ist Pflicht (vim.pack klont damit), ripgrep/fd braucht Telescope für
-- live_grep bzw. find_files.
local tools = {
    { names = { "git" }, required = true, why = "vim.pack (Plugin-Installation)" },
    { names = { "rg" }, required = true, why = "telescope live_grep" },
    { names = { "fd", "fdfind" }, required = false, why = "telescope find_files (sonst Fallback)" },
}
for _, t in ipairs(tools) do
    local found = nil
    for _, n in ipairs(t.names) do
        if vim.fn.executable(n) == 1 then
            found = n
            break
        end
    end
    if found then
        info("gefunden: %s — %s", found, t.why)
    elseif t.required then
        err("'%s' nicht im PATH — benötigt für %s", table.concat(t.names, "/"), t.why)
    else
        warn("'%s' nicht im PATH — %s", table.concat(t.names, "/"), t.why)
    end
end

-- ---------------------------------------------------------------------------
-- 5. :checkhealth
-- ---------------------------------------------------------------------------
-- checkhealth schreibt in einen Puffer; den lesen wir aus, statt ihn in eine
-- Datei zu schreiben — user.main macht beim Start "cd ~", relative Pfade
-- landen sonst im Home statt im Workspace.
local health_lines = {}
local ok_health, health_err = pcall(function()
    vim.cmd("checkhealth")
    health_lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
end)

if not ok_health then
    err(":checkhealth ist abgebrochen: %s", tostring(health_err))
else
    local section, expect_title = "?", false
    local n_err, n_warn = 0, 0
    for _, line in ipairs(health_lines) do
        -- Aufbau: eine ===-Linie, darunter die Abschnittsüberschrift
        -- ("neo-tree: ..."), danach die Einträge.
        if line:match("^=====") then
            expect_title = true
        elseif expect_title and vim.trim(line) ~= "" then
            section = vim.trim(line):match("^[^:]+") or vim.trim(line)
            expect_title = false
        end
        local entry = (vim.trim(line):gsub("^%-%s*", ""))
        if line:match("ERROR") then
            n_err = n_err + 1
            err("checkhealth [%s] %s", section, entry)
        elseif line:match("WARNING") then
            n_warn = n_warn + 1
            warn("checkhealth [%s] %s", section, entry)
        end
    end
    info("checkhealth: %d Zeilen, %d ERROR, %d WARNING", #health_lines, n_err, n_warn)

    -- Vollen Report als Artefakt ablegen (Pfad kommt aus dem Workflow).
    local report = vim.env.CI_REPORT
    if report ~= nil and report ~= "" then
        vim.fn.mkdir(vim.fn.fnamemodify(report, ":h"), "p")
        vim.fn.writefile(health_lines, report)
        info("Report geschrieben: %s", report)
    end
end

-- ---------------------------------------------------------------------------
-- 6. Ausgabe (stdout + GitHub-Job-Summary)
-- ---------------------------------------------------------------------------
local out = {}
local function emit(s)
    out[#out + 1] = s
end

emit("## Neovim-Setup")
emit("")
for _, s in ipairs(infos) do
    emit("- " .. s)
end
if #errors > 0 then
    emit("")
    emit(string.format("## ERROR (%d)", #errors))
    emit("")
    for _, s in ipairs(errors) do
        emit("- " .. s)
    end
end
if #warns > 0 then
    emit("")
    emit(string.format("## WARNING (%d)", #warns))
    emit("")
    for _, s in ipairs(warns) do
        emit("- " .. s)
    end
end
emit("")
emit(#errors == 0 and "**Ergebnis: OK**" or string.format("**Ergebnis: %d Fehler**", #errors))

local text = table.concat(out, "\n")
io.stdout:write(text .. "\n")

local summary = vim.env.GITHUB_STEP_SUMMARY
if summary ~= nil and summary ~= "" then
    local fh = io.open(summary, "a")
    if fh then
        fh:write(string.format("### %s\n\n", vim.uv.os_uname().sysname))
        fh:write(text .. "\n\n")
        fh:close()
    end
end

os.exit(#errors == 0 and 0 or 1)
