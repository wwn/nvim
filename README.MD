## Keymaps

The `<leader>` key is set to `Space`.

### General Shortcuts

| Shortcut | Mode | Action |
| :--- | :--- | :--- |
| `jj` | Insert | Escape (Return to Normal mode) |
| `<leader>e` | Normal | Toggle Neo-tree (File Explorer) |

### Telescope Shortcuts

| Shortcut | Action |
| :--- | :--- |
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep (search text) |
| `<leader>fb` | List buffers |
| `<leader>fh` | Help tags |

### Neo-tree Shortcuts

When the Neo-tree sidebar is focused, the following default shortcuts are available:

| Shortcut | Action |
| :--- | :--- |
| `<cr>` | Open file or directory |
| `s` | Open in vertical split |
| `i` | Open in horizontal split |
| `a` | Add a new file (append `/` for directory) |
| `d` | Delete file/directory |
| `r` | Rename file/directory |
| `y` | Copy to clipboard |
| `x` | Cut to clipboard |
| `p` | Paste from clipboard |
| `c` | Copy file/directory |
| `m` | Move file/directory |
| `H` | Toggle hidden files |
| `R` | Refresh explorer |
| `?` | Help menu |

### Render-Markdown Shortcuts

| Command | Aktion |
| :--- | :--- |
| `:RenderMarkdown toggle` | Rendering ein/ausschalten |
| `:RenderMarkdown enable` | Rendering einschalten |
| `:RenderMarkdown disable` | Rendering ausschalten |
| `:RenderMarkdown expand` | Conceal-Level erhöhen (mehr gerendert) |
| `:RenderMarkdown contract` | Conceal-Level verringern (mehr Rohtext) |

## Plugins

- **[jb.nvim](https://github.com/nickkadutskyi/jb.nvim)**: JetBrains-inspired colorscheme.
- **[lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)**: A fast and customizable statusline.
- **[neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim)**: Neovim plugin to manage the file system.
- **[telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)**: A highly extendable fuzzy finder over lists.
- **[plenary.nvim](https://github.com/nvim-lua/plenary.nvim)**: Useful lua functions used by many plugins.
- **[nui.nvim](https://github.com/MunifTanjim/nui.nvim)**: UI Component Library for Neovim.
- **[render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim)**: Rendert Markdown direkt im Buffer (Headings, Tabellen, Checkboxen, Code-Blöcke).
- **[nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons)**: Dateityp-Icons, benötigt von Neo-tree, Lualine, Telescope und render-markdown.
- **[alpha-nvim](https://github.com/goolord/alpha-nvim)**: Startbildschirm mit der Tastenkürzel-Übersicht (`lua/user/alpha.lua`).
- **Built-in Tree-sitter** (Neovim 0.12): bringt die Parser `c`, `lua`, `markdown`, `markdown_inline`, `query`, `vim` und `vimdoc` mit. Für andere Sprachen (TypeScript, JavaScript, HTML, CSS, JSON, YAML …) gibt es kein Treesitter-Highlighting, sondern nur die klassische Regex-Syntax — dafür wäre ein Parser-Plugin nötig.

## Appearance

- **Font**: JetBrains Mono Nerd Font (configured for Neovide).
- **Theme**: JetBrains (jb).
- **Statusline**: Lualine with auto-theme.

## Commands
update plugins
```vim
:lua vim.pack.update()
:lua vim.pack.update(nil, { force = true })
```
oder confirm with
```vim
:write
```

uninstall plugin
```vim
:lua vim.pack.del({ 'plugin-name' })
```

## Utilities
install some stuff
```sh
winget install BurntSushi.ripgrep.MSVC sharkdp.fd
brew install ripgrep fd
```

show all files except hidden ones in current directory:
```sh
find . -type d -path '*/.*' -prune -o -type f -exec printf "\033[1;32m\n[PATH: %s]\033[0m\n" {} \; -exec cat {} \;
```

