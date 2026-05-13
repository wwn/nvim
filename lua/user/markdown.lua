require("render-markdown").setup({
    render_modes = { "n", "c" },

    heading = {
        backgrounds = { "RenderMarkdownH1Bg", "RenderMarkdownH2Bg", "RenderMarkdownH3Bg" },
        foregrounds = { "RenderMarkdownH1", "RenderMarkdownH2", "RenderMarkdownH3" },
    },

    code = {
        style = "full",
        border = "thin",
    },

    bullet = {
        icons = { "●", "○", "◆", "◇" },
    },

    checkbox = {
        unchecked = { icon = "☐" },
        checked   = { icon = "☑" },
    },

    html  = { enabled = false },
    latex = { enabled = false },
    yaml  = { enabled = false },
})
