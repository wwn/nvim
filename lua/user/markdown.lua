-- ============================================================================
--  markdown.lua — render-markdown.nvim
--  Renders Markdown directly in the buffer (headings, tables, code, lists).
--  Assumes the bundled Treesitter parsers markdown/markdown_inline are present.
-- ============================================================================

require("render-markdown").setup({
    -- Only render in Normal and Command mode. In Insert mode the raw
    -- text is shown, otherwise the cursor jumps around while editing.
    render_modes = { "n", "c" },

    heading = {
        -- Only H1–H3 get their own background/foreground color;
        -- from H4 on the plugin's fallback applies.
        backgrounds = { "RenderMarkdownH1Bg", "RenderMarkdownH2Bg", "RenderMarkdownH3Bg" },
        foregrounds = { "RenderMarkdownH1", "RenderMarkdownH2", "RenderMarkdownH3" },
    },

    code = {
        style = "full",   -- language line + colored block
        border = "thin",  -- thin border instead of a full background area
    },

    -- Icons per bullet nesting level
    bullet = {
        icons = { "●", "○", "◆", "◇" },
    },

    checkbox = {
        unchecked = { icon = "☐" },
        checked   = { icon = "☑" },
    },

    -- Deliberately off: not needed, and latex would expect `latex2text` externally.
    html  = { enabled = false },
    latex = { enabled = false },
    yaml  = { enabled = false },
})
