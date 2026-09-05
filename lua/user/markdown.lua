-- ============================================================================
--  markdown.lua — render-markdown.nvim
--  Rendert Markdown direkt im Puffer (Überschriften, Tabellen, Code, Listen).
--  Setzt die mitgelieferten Treesitter-Parser markdown/markdown_inline voraus.
-- ============================================================================

require("render-markdown").setup({
    -- Nur im Normal- und Kommandomodus rendern. Im Insert-Mode wird der
    -- Rohtext gezeigt, sonst springt der Cursor beim Bearbeiten.
    render_modes = { "n", "c" },

    heading = {
        -- Nur H1–H3 bekommen eine eigene Hintergrund-/Vordergrundfarbe;
        -- ab H4 greift der Fallback des Plugins.
        backgrounds = { "RenderMarkdownH1Bg", "RenderMarkdownH2Bg", "RenderMarkdownH3Bg" },
        foregrounds = { "RenderMarkdownH1", "RenderMarkdownH2", "RenderMarkdownH3" },
    },

    code = {
        style = "full",   -- Sprachzeile + farbiger Block
        border = "thin",  -- schmaler Rahmen statt voller Hintergrundfläche
    },

    -- Symbole je Verschachtelungsebene der Aufzählung
    bullet = {
        icons = { "●", "○", "◆", "◇" },
    },

    checkbox = {
        unchecked = { icon = "☐" },
        checked   = { icon = "☑" },
    },

    -- Bewusst aus: nicht benötigt und latex würde extern `latex2text` erwarten.
    html  = { enabled = false },
    latex = { enabled = false },
    yaml  = { enabled = false },
})
