# Ft-Nixos — Priority Flake Ideas (Develop First)

These are the most impactful flakes to build first. Each one unlocks the next —
start with the foundation (`ft-nixui`) and work up.

---

## Tier 1 — Foundation (Build These First)

### ft-nixui — Shared UI Component Library

| | |
|:---|:---|
| **Purpose** | The glue that makes every other flake feel like one cohesive desktop |
| **What it provides** | Base16 → CSS variable generator, Rasi theme templates (for rofi-based tools), Blur/layer rule generators for Hyprland, Font resolution (role → font family), Spacing/sizing tokens, Animation presets |
| **Used by** | ft-nixprism, ft-nixvault, ft-nixbar, ft-nixnotify, ft-nixlock, etc. |
| **Why first?** | Without this, every flake reinvents theming. With it, everything matches automatically. |
| **Effort** | Medium — mostly generators and template functions |

---

### ft-nixbar — Unified Status Bar

| | |
|:---|:---|
| **Purpose** | Replace waybar with something deeply integrated into the ft-nix ecosystem |
| **Backends** | EWW (default), custom GTK4 layer-shell, or Quickshell |
| **Modules** | Workspaces, window title, system tray, clock, battery, network, bluetooth, volume, brightness, music (MPRIS + album art), notifications, CPU/RAM/thermal |
| **Features** | ft-nixui auto-theming, click actions (battery → power menu), hover tooltips, animated transitions, popup panels (calendar, volume mixer, network list) |
| **Why first?** | The bar is the most visible part of the desktop. A polished bar makes everything else feel premium. |
| **Effort** | High — lots of modules, but EWW gives us a head start |
| **Status** | 🚧 Temporary eww config exists in `home/features/desktop/shared/bar.nix` |

---

### ft-nixlock — Advanced Lock Screen

| | |
|:---|:---|
| **Purpose** | Replace hyprlock with a customizable, theme-aware lock screen |
| **Features** | Blurred desktop background or custom wallpaper, Clock + date + weather, Media player widget (current song), Notification summary (missed while away), Custom widgets (todo list, calendar events), Multiple user support, Fingerprint + password, Grace period (quick unlock after lock) |
| **UI** | Fully ft-nixui-themed, widget positioning via config, animation on unlock |
| **Integration** | ft-nixui colors, Hyprland lock protocol, MPRIS, UPower |
| **Why first?** | Lock screen is the first thing you see when returning to your computer. It's high visibility, low complexity. |
| **Effort** | Medium — hyprlock is already close; we extend it |
| **Status** | 🚧 Planned — currently using shared `hyprlock` in `home/features/desktop/shared/hyprlock.nix` as a temporary solution |

---

## Tier 2 — Core Desktop Experience

### ft-nixnotify — Notification Daemon Framework

| | |
|:---|:---|
| **Purpose** | Replace mako with a feature-rich, theme-aware notification system |
| **Features** | Grouped notifications (by app), searchable history, Inline actions (reply, dismiss all), Do-not-disturb profiles, Urgency-based timeouts, Image support (album art, icons), Progress notifications (file transfers, builds) |
| **UI** | Rounded, blurred, animated, ft-nixui-colored, Multiple layouts (compact, expanded, minimal) |
| **Integration** | ft-nixui colors, Hyprland blur, MPRIS for media notifications, UPower for battery |
| **Why?** | Notifications are a core desktop experience; they should be as polished as everything else |
| **Effort** | Medium-High |

---

### ft-nixvault — Password Manager Launcher

| | |
|:---|:---|
| **Purpose** | Unified password manager launcher with ft-nixui theming |
| **Trigger** | `SUPER+V` |
| **Backends** | `rbw` (Bitwarden), `gopass`, `keepassxc-cli` |
| **Features** | Search passwords → Enter copies to clipboard → Auto-clear after 45s, TOTP code generation, Username/password/type selection |
| **UI** | Same style as ft-nixprism (centered, blurred, rounded, icon support) |
| **Integration** | ft-nixui colors, Hyprland blur layer rules, optional `pinentry` replacement |
| **Security** | Clipboard auto-clear, memory-only display, lock on screen lock |
| **Why?** | Natural extension of the ft-nixprism ecosystem; every desktop needs secure password access |
| **Effort** | Medium |

---

### ft-nixcast — Screen Capture Tool

| | |
|:---|:---|
| **Purpose** | Unified screenshot and screen recording workflow |
| **Bindings** | `SUPER+Shift+S` → area screenshot → swappy edit, `SUPER+Alt+R` → toggle recording, `SUPER+Shift+R` → GIF recording |
| **Features** | Screenshot → edit → copy/save/upload, Recording → notification with file path + action buttons, Auto-upload to 0x0.st/imgur, History browser |
| **UI** | Notifications with action buttons (copy path, open folder, delete, upload), Post-capture edit with swappy |
| **Dependencies** | `grim`, `slurp`, `swappy`, `wf-recorder`, `wl-clipboard`, `libnotify`, `tesseract` (OCR) |
| **Extras** | OCR: screenshot → extract text to clipboard, Screen annotation: draw on frozen screen before capture |
| **Why?** | Screenshot workflow on Linux is always awkward; this unifies it into one polished tool |
| **Effort** | Medium |

---

## Tier 3 — Productivity & Workflow

### ft-nixswitch — Desktop Profile Switcher

| | |
|:---|:---|
| **Purpose** | Switch between complete desktop profiles instantly |
| **Profiles** | `work` (minimal, focused), `gaming` (performance mode, RGB sync), `minimal` (clean desktop, no bar, zen mode), `presentation` (big fonts, no notifications), `social` (chat apps, notifications on) |
| **Per-profile** | Hyprland layout/gaps/border, ft-nixbar config (or no bar), wallpaper, startup apps, notification settings, keybindings, monitor layout, performance governor |
| **Trigger** | `SUPER+Shift+P` → ft-nixprism-style picker |
| **Implementation** | Nix specialisations OR runtime config switching via Hyprland socket |
| **Why?** | One config, multiple contexts — no compromises between work and play |
| **Effort** | High |

---

### ft-nixterm — Unified Terminal Experience

| | |
|:---|:---|
| **Purpose** | A terminal configuration framework that unifies kitty, wezterm, alacritty, foot, etc. |
| **Features** | One config → generates configs for all supported terminals, ft-nixui color auto-application, Font synchronization, Keybinding consistency, Session restoration (tmux/zellij integration) |
| **Integration** | ft-nixui colors, font packages, shell integration |
| **Why?** | Switch terminals without losing your setup; consistent experience everywhere |
| **Effort** | Medium |

---

### ft-nixfont — Font Management System

| | |
|:---|:---|
| **Purpose** | Declarative font management with automatic fallback chains |
| **Features** | Define font roles (sans, serif, mono, emoji, icon), Auto-download and install, Fallback chain generation, Nerd Font patching on-the-fly, Font preview tool, Per-app font overrides |
| **Integration** | Stylix font settings, Home Manager fontconfig |
| **Why?** | Font configuration on Linux is a mess; this makes it declarative and reliable |
| **Effort** | Medium |

---

## Tier 4 — Ecosystem & Infrastructure

### ft-nixsync — Config Synchronization

| | |
|:---|:---|
| **Purpose** | Sync dotfiles between machines effortlessly |
| **Features** | Git-based with auto-commit on change, Machine-specific overlays (laptop vs desktop), Secret management (sops), Remote rebuild over SSH, Conflict resolution |
| **Commands** | `ft-nixsync push`, `ft-nixsync pull`, `ft-nixsync deploy <host>`, `ft-nixsync diff`, `ft-nixsync status` |
| **Why?** | Keep laptop and desktop in sync without manual copying |
| **Effort** | Medium |

---

### ft-nixdev — Project Environment Bootstrapper

| | |
|:---|:---|
| **Purpose** | Quick project environment setup with zero boilerplate |
| **Commands** | `ft-nixdev init`, `ft-nixdev shell`, `ft-nixdev list`, `ft-nixdev update` |
| **Templates** | `node`, `rust`, `python`, `go`, `haskell`, `elixir`, `java`, `php`, `nix`, `lua` |
| **Per-template** | Language server, formatter, linter, debugger, test runner, pre-commit hooks, direnv integration |
| **Why?** | Stop writing the same `flake.nix` boilerplate for every project |
| **Effort** | High — many templates to maintain |

---

## Dependency Graph

```
ft-nixui (foundation)
    ├── ft-nixbar
    ├── ft-nixlock
    ├── ft-nixnotify
    ├── ft-nixvault
    ├── ft-nixcast
    └── ft-nixterm

ft-nixbar + ft-nixlock + ft-nixnotify
    └── ft-nixswitch (needs all three to switch profiles)

ft-nixfont
    └── ft-nixterm (needs consistent fonts)
    └── ft-nixui (font resolution)
```

---

## Recommended Build Order

1. **ft-nixui** — Everything else depends on it
2. **ft-nixlock** — High impact, builds on hyprlock knowledge we already have
3. **ft-nixbar** — Replaces the temporary eww config; most visible component
4. **ft-nixnotify** — Replaces mako; pairs well with ft-nixbar
5. **ft-nixvault** — Natural extension of ft-nixprism
6. **ft-nixcast** — Screenshot workflow is daily-use
7. **ft-nixfont** — Unlocks ft-nixterm
8. **ft-nixterm** — Terminal unification
9. **ft-nixswitch** — Needs bar, lock, notify to be complete
10. **ft-nixsync** + **ft-nixdev** — Infrastructure / developer tools

---

*Last updated: 2026-04-19*
