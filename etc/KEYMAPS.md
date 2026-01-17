# Aquamoon Key Mappings Cheat Sheet

## Table of Contents
- [River WM](#river-wm)
- [Neovim](#neovim)
- [Oil File Manager](#oil-file-manager)
- [Television (TV)](#television-tv)
- [Fish Shell Aliases](#fish-shell-aliases)

---

## River WM

### Application Launchers
| Keys | Action |
|------|--------|
| `Super + Return` | Launch Neovide (terminal) |
| `Super + Shift + Return` | Launch Qutebrowser |
| `Super + S` | Quick browser script |
| `Super + A` | Bookmarks script |
| `Super + D` | Application launcher (run script) |

### System Menus
| Keys | Action |
|------|--------|
| `Super + Z` | System menu |
| `Super + W` | Network manager |
| `Super + T` | Theme picker |

### Media Controls
| Keys | Action |
|------|--------|
| `Super + V` | Lower brightness |
| `Super + M` | Raise brightness |
| `Super + B` | Lower volume |
| `Super + N` | Raise volume |

### Utilities
| Keys | Action |
|------|--------|
| `Super + Shift + S` | Screenshot |
| `Super + G` | LazyGit (in cool-retro-term) |

### Window Management
| Keys | Action |
|------|--------|
| `Super + Q` | Close focused window |
| `Super + J` | Focus previous view |
| `Super + K` | Focus next view |
| `Super + Shift + J` | Rotate layout stack (counter-clockwise) |
| `Super + Shift + K` | Rotate layout stack (clockwise) |
| `Super + E` | Zoom (bump focused view to top) |
| `Super + F` | Toggle fullscreen |
| `Super + H` | Decrease main factor (make master smaller) |
| `Super + L` | Increase main factor (make master larger) |

### Mouse Actions
| Keys | Action |
|------|--------|
| `Super + Left Click` | Move window |
| `Super + Right Click` | Resize window |

---

## Neovim

### Leader Key
The leader key is set to `,` (comma).

### Leader Keymaps
| Keys | Action |
|------|--------|
| `<leader> r` | Open terminal with scooter |
| `<leader> e` | Open Oil file manager |
| `<leader> w` | Open terminal |
| `<leader> q` | Delete buffer |
| `<leader> d` | Toggle diagnostics |
| `<leader> c` | Show cursor position |
| `<leader> y` | Open terminal with clipse |
| `<leader> i` | LSP hover |
| `<leader> o` | Open terminal with opencode |
| `<leader> h` | LazyGit filter current file |
| `<leader> j` | Decrease Neovide scale |
| `<leader> k` | Increase Neovide scale |
| `<leader> n` | Open terminal with wiremix |
| `<leader> /` | Clear search highlight |

### Function Keys
| Keys | Action |
|------|--------|
| `<F1>` | Open LazyGit |
| `<F2>` | Aqua save (format and write) |
| `<F3>` | Split with current directory |
| `<F4>` | Vertical split with current directory |
| `<F5>` | Previous quickfix item |
| `<F6>` | Next quickfix item |
| `<F7>` | Open buffer menu (Snipe) |
| `<F8>` | Aqua run (run based on filetype) |

### Smart Splits (Window Navigation)
| Keys | Action |
|------|--------|
| `<A-Left>` | Resize window left |
| `<A-Down>` | Resize window down |
| `<A-Up>` | Resize window up |
| `<A-Right>` | Resize window right |
| `<Left>` | Move cursor to left window |
| `<Down>` | Move cursor to down window |
| `<Up>` | Move cursor to up window |
| `<Right>` | Move cursor to right window |
| `<C-\>` | Move cursor to previous window |

### Buffer Swapping
| Keys | Action |
|------|--------|
| `<leader><Left>` | Swap buffer left |
| `<leader><Down>` | Swap buffer down |
| `<leader><Up>` | Swap buffer up |
| `<leader><Right>` | Swap buffer right |

### Core Keymaps
| Keys | Action |
|------|--------|
| `<CR>` (in normal/visual/operator) | Leap motion |
| `U` | Redo |
| `<Esc>` (in terminal) | Exit terminal mode |

### Plugin Keymaps
| Keys | Action |
|------|--------|
| `<leader> f` | TV files channel |
| `<leader> g` | TV text channel |

---

## Oil File Manager

### Navigation
| Keys | Action |
|------|--------|
| `H` | Go to parent directory |
| `L` | Enter/select entry |
| `e` | Open in vertical split |
| `E` | Open in horizontal split |
| `<Tab>` | Preview file |
| `<C-q>` | Send files to quickfix list |

### Oil "Leader" (z-prefixed)
| Keys | Action |
|------|--------|
| `zo` | Open with external application |
| `zy` | Yank entry |
| `zz` | Open terminal |
| `zh` | Toggle hidden files |

---

## Television (TV)

### Shell Integration Keybindings
| Keys | Action |
|------|--------|
| `Ctrl+S` | Smart autocomplete |
| `Ctrl+H` | Command history |

---

## Fish Shell Aliases

### Navigation & File Operations
| Alias | Command |
|-------|---------|
| `l` | `clear && ls` |
| `ls` | `eza` |
| `cat` | `bat` |
| `put` | `wl-paste` |
| `yank` | `wl-copy` |

### Git & Development
| Alias | Command |
|-------|---------|
| `lg` | `lazygit` |
| `g` | `tv text` |
| `r` | `pushd (tv git-repos)` |
| `b` | `pushd (tv git-branches)` |
| `issues` | `tv gh-issues` |

### System Utilities
| Alias | Command |
|-------|---------|
| `df` | `duf` |
| `du` | `dust` |
| `top` | `htop` |
| `hist` | `history` |
| `q` | `exit` |
| `s` | `sudo` |
| `chmodx` | `sudo chmod u+x` |
| `lo` | `libreoffice` |
| `rs` | `rsync -Pr` |
| `serve` | `abduco -c http_server /bin/simple-http-server --nocache` |

### Help
| Keys | Action |
|------|--------|
| `--help` or `-h` | Show help with bat formatting |

---

## Custom Scripts

### Aquamoon Save (`<F2>`)
- Trims whitespace (MiniTrailspace)
- Formats with LSP
- Shows LSP status
- Saves file silently

### Aquamoon Run (`<F8>`)
- For GDScript: Runs file with Godot executable

### Filetype-Specific Behavior
- GDScript files can be run with `<F8>`
- Oil and ministarter filetypes skip formatting on save

---

## Notes
- **Leader Key**: `,` (comma)
- **Modal Key**: Super key (Windows/Command key)
- **Terminal Exit**: `<Esc>` in terminal mode returns to normal mode
- **Leap**: Motion plugin activated with `<Enter>` key
- **TV**: Fuzzy finder for files and text search
- **Smart Splits**: Comprehensive window navigation and resizing
