-- ============================================================================
--  .github/ci/health.lua — configuration and health check for CI
--
--  Invocation (the config is loaded completely normally in the process):
--      nvim --headless -c "lua dofile(vim.env.CI_SCRIPT)"
--
--  "nvim -l script.lua" does NOT work: -l skips init.lua. Then neither
--  the modules from lua/user/ nor the plugins activated via vim.pack.add
--  would be visible — the check would effectively test nothing.
--
--  Exit code 0 = all good, 1 = at least one ERROR.
--  WARNINGs don't fail the build, but do show up in the report.
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
-- 1. Neovim version
-- ---------------------------------------------------------------------------
-- vim.pack only exists from 0.12 onward; below that the config doesn't start at all.
local v = vim.version()
info("Neovim %d.%d.%d", v.major, v.minor, v.patch)
if vim.fn.has("nvim-0.12") == 0 then
    err("Neovim >= 0.12 required (vim.pack), found: %d.%d.%d", v.major, v.minor, v.patch)
end
if vim.pack == nil then
    err("vim.pack is not available — plugin check skipped")
end

-- ---------------------------------------------------------------------------
-- 2. Plugins against nvim-pack-lock.json
-- ---------------------------------------------------------------------------
-- vim.pack.get() lists everything sitting on the packpath. "active = true"
-- means: loaded in this session via vim.pack.add() from init.lua.
if vim.pack ~= nil then
    local lock_path = config_dir .. "/nvim-pack-lock.json"
    local ok_lock, lock = pcall(function()
        return vim.json.decode(table.concat(vim.fn.readfile(lock_path), "\n")).plugins
    end)

    if not ok_lock or type(lock) ~= "table" then
        err("nvim-pack-lock.json not readable: %s", lock_path)
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
    info("Plugins: %d installed, %d active, %d in the lockfile",
        #packs, active_count, vim.tbl_count(lock))

    for name, entry in pairs(lock) do
        local p = installed[name]
        if not p then
            err("Plugin '%s' is in the lockfile but not installed", name)
        elseif not p.active then
            -- In the lockfile, on disk, but not referenced by any vim.pack.add()
            -- line: a leftover from an earlier config version.
            warn("Plugin '%s' is installed but not loaded by the config", name)
        elseif entry.rev and p.rev and entry.rev ~= p.rev then
            -- Not a hard error: on a fresh clone the upstream HEAD can
            -- deviate from the pinned commit. It should still be visible
            -- though — that's exactly why the weekly run exists.
            warn("Plugin '%s': installed %s, lockfile %s",
                name, p.rev:sub(1, 8), entry.rev:sub(1, 8))
        end
    end

    for _, p in ipairs(packs) do
        if p.active and lock[p.spec.name] == nil then
            err("Plugin '%s' is loaded but missing from the lockfile "
                .. "(run :lua vim.pack.update() and commit the lockfile)",
                p.spec.name)
        end
    end
end

-- ---------------------------------------------------------------------------
-- 3. Own modules
-- ---------------------------------------------------------------------------
-- Every file in lua/user/ should actually have been loaded via user.main.
-- A module that wasn't loaded is usually a forgotten require().
local loaded_user = 0
for name, _ in pairs(package.loaded) do
    if type(name) == "string" and name:match("^user%.") then
        loaded_user = loaded_user + 1
    end
end
for _, file in ipairs(vim.fn.glob(config_dir .. "/lua/user/*.lua", false, true)) do
    local mod = "user." .. vim.fn.fnamemodify(file, ":t:r")
    if package.loaded[mod] == nil then
        warn("Module '%s' exists but was not loaded "
            .. "(forgot the require in lua/user/main.lua?)", mod)
    end
end
info("Loaded user modules: %d", loaded_user)

-- ---------------------------------------------------------------------------
-- 4. External programs
-- ---------------------------------------------------------------------------
-- git is mandatory (vim.pack uses it to clone), ripgrep/fd is needed by Telescope
-- for live_grep and find_files respectively.
local tools = {
    { names = { "git" }, required = true, why = "vim.pack (plugin installation)" },
    { names = { "rg" }, required = true, why = "telescope live_grep" },
    { names = { "fd", "fdfind" }, required = false, why = "telescope find_files (otherwise falls back)" },
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
        info("found: %s — %s", found, t.why)
    elseif t.required then
        err("'%s' not in PATH — required for %s", table.concat(t.names, "/"), t.why)
    else
        warn("'%s' not in PATH — %s", table.concat(t.names, "/"), t.why)
    end
end

-- ---------------------------------------------------------------------------
-- 5. :checkhealth
-- ---------------------------------------------------------------------------
-- checkhealth writes into a buffer; we read that out instead of writing it to
-- a file — user.main does "cd ~" on startup, so relative paths would
-- otherwise end up in home instead of the workspace.
local health_lines = {}
local ok_health, health_err = pcall(function()
    vim.cmd("checkhealth")
    health_lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
end)

if not ok_health then
    err(":checkhealth was aborted: %s", tostring(health_err))
else
    local section, expect_title = "?", false
    local n_err, n_warn = 0, 0
    for _, line in ipairs(health_lines) do
        -- Structure: an ===-line, below it the section heading
        -- ("neo-tree: ..."), then the entries.
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
    info("checkhealth: %d lines, %d ERROR, %d WARNING", #health_lines, n_err, n_warn)

    -- Store the full report as an artifact (path comes from the workflow).
    local report = vim.env.CI_REPORT
    if report ~= nil and report ~= "" then
        vim.fn.mkdir(vim.fn.fnamemodify(report, ":h"), "p")
        vim.fn.writefile(health_lines, report)
        info("Report written: %s", report)
    end
end

-- ---------------------------------------------------------------------------
-- 6. Output (stdout + GitHub job summary)
-- ---------------------------------------------------------------------------
local out = {}
local function emit(s)
    out[#out + 1] = s
end

emit("## Neovim Setup")
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
emit(#errors == 0 and "**Result: OK**" or string.format("**Result: %d error(s)**", #errors))

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
