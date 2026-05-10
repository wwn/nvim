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

## Plugins

- **[jb.nvim](https://github.com/nickkadutskyi/jb.nvim)**: JetBrains-inspired colorscheme.
- **[lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)**: A fast and customizable statusline.
- **[neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim)**: Neovim plugin to manage the file system.
- **[telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)**: A highly extendable fuzzy finder over lists.
- **[plenary.nvim](https://github.com/nvim-lua/plenary.nvim)**: Useful lua functions used by many plugins.
- **[nui.nvim](https://github.com/MunifTanjim/nui.nvim)**: UI Component Library for Neovim.

## Appearance

- **Font**: JetBrains Mono Nerd Font (configured for Neovide).
- **Theme**: JetBrains (jb).
- **Statusline**: Lualine with auto-theme.

## Commands
update plugins
<pre>:lua vim.pack.update()</pre>
<pre>:lua vim.pack.update(nil, { force = true })</pre>
oder confirm with  <pre>:write</pre>


uninstall plugin
<pre>lua vim.pack.del({ 'plugin-name' })</pre>

## Utilities
install some stuff
<pre>winget install BurntSushi.ripgrep.MSVC winget install sharkdp.fd</pre>
<pre>brew install ripgrep fd</pre>

show all files except hidden ones in current directory:
<pre>find . -type d -path '*/.*' -prune -o -type f -exec  printf "\033[1;32m\n[PATH: %s]\033[0m\n" {} \; -exec cat {} \;</pre>


### Plugin Dir
- jb.nvim
- lualine.nvim
- neo-tree.nvim
- nui.nvim
- telescope.nvim
