# Theme Switching & Customization Guide

## How Theming Works

This NixOS configuration uses **Stylix** for centralized, build-time theming.
All colors, fonts, cursor, and opacity flow from a single source of truth:

```
modules/theming/default.nix  →  ft.theming.scheme = "gruvbox-dark-medium"
```

Stylix uses **base16** color schemes — a standardized 16-color palette that
gets applied to every supported application (terminals, bat, fzf, yazi, GTK,
Qt, and 100+ more).

---

## Switching Themes

### 1. Change the color scheme

In `hosts/<host>/configuration.nix`:

```nix
ft.theming.scheme = "catppuccin-mocha";  # or any base16 scheme name
```

### 2. Rebuild

```bash
sudo nixos-rebuild switch --flake /etc/nixos#laptop
```

That's it — **every** Stylix-managed app updates to the new palette.

### 3. List available schemes

```bash
nix build nixpkgs#base16-schemes --no-link --print-out-paths
ls $(nix build nixpkgs#base16-schemes --no-link --print-out-paths)/share/themes/ | sed 's/.yaml//'
```

Popular choices:
| Scheme | Style |
|---|---|
| `gruvbox-dark-medium` | Warm retro dark |
| `gruvbox-dark-hard` | Higher-contrast gruvbox |
| `catppuccin-mocha` | Pastel dark |
| `catppuccin-latte` | Pastel light |
| `tokyo-night-dark` | Cool blue dark |
| `nord` | Arctic cool |
| `dracula` | Purple-accented dark |
| `rose-pine` | Muted romantic |
| `rose-pine-moon` | Slightly brighter rose-pine |
| `everforest-dark-hard` | Nature-inspired |
| `one-dark` | Atom-inspired |
| `solarized-dark` | Classic |
| `kanagawa` | Japanese painting |

---

## Custom Color Schemes

You can create your own base16 YAML scheme and place it here:

```
assets/themes/my-theme.yaml
```

Then reference it directly in your config:

```nix
# In modules/theming/default.nix, replace the base16Scheme line:
stylix.base16Scheme = ../../assets/themes/my-theme.yaml;
```

### Base16 YAML format

```yaml
scheme: "My Custom Theme"
author: "Your Name"
base00: "1a1b26"  # Default Background
base01: "16161e"  # Lighter Background
base02: "2f3549"  # Selection Background
base03: "444b6a"  # Comments
base04: "787c99"  # Dark Foreground
base05: "a9b1d6"  # Default Foreground
base06: "cbccd1"  # Light Foreground
base07: "d5d6db"  # Light Background
base08: "f7768e"  # Red (errors, deletions)
base09: "ff9e64"  # Orange (integers, warnings)
base0A: "e0af68"  # Yellow (classes, search)
base0B: "9ece6a"  # Green (strings, additions)
base0C: "7dcfff"  # Cyan (support, regex)
base0D: "7aa2f7"  # Blue (functions, headings)
base0E: "bb9af7"  # Purple (keywords, tags)
base0F: "db4b4b"  # Dark Red (deprecated)
```

---

## Wallpapers

Place wallpaper images in `assets/wallpapers/`.

Set a wallpaper in your host configuration:

```nix
ft.theming.wallpaper = ../../assets/wallpapers/my-wallpaper.png;
```

If no wallpaper is set, a solid-color fallback is generated automatically.

---

## Polarity (Dark / Light)

```nix
ft.theming.polarity = "dark";   # or "light" or "either"
```

This hints Stylix which variant to prefer when a scheme supports both.

---

## What Stylix Controls vs. What Is Manual

| Setting | Managed by | Where |
|---|---|---|
| Colors (all apps) | **Stylix** (base16 scheme) | `ft.theming.scheme` |
| Terminal font + size | **Stylix** | `ft.theming` → `stylix.fonts` |
| Terminal opacity | **Stylix** | `ft.theming` → `stylix.opacity` |
| Cursor theme + size | **Stylix** | `ft.theming` → `stylix.cursor` |
| Terminal padding | **Manual** (shared) | `ft.terminal.defaults.padding` |
| Scrollback lines | **Manual** (shared) | `ft.terminal.defaults.scrollbackLines` |
| Cursor shape + blink | **Manual** (shared) | `ft.terminal.defaults.cursorStyle/Blink` |
| Neovim theme | **NVF** (manual) | `home/features/nvim/settings.nix` |
| Starship format | **Manual** | `home/features/shell/zsh/starship.nix` |

---

## Runtime Theme Switching — Limitations

Stylix is a **build-time** theming system. Changing themes requires a
`nixos-rebuild`. This is by design — it guarantees consistency across all apps.

**If you want runtime switching**, the options are:

1. **Multiple NixOS generations**: Build several theme variants, switch with
   `nixos-rebuild switch --flake .#laptop-dark` / `#laptop-light`.

2. **Per-app runtime switching**: Some apps (kitty, wezterm, neovim) support
   runtime theme changes via their own mechanisms. But this bypasses Stylix
   and won't be consistent across apps.

3. **Specialisations** (advanced): NixOS `specialisation` allows multiple
   system configs that share a single generation. You could create
   `specialisation.light` and `specialisation.dark` with different
   `ft.theming.scheme` values.

   ```nix
   # In hosts/laptop/configuration.nix:
   specialisation.light.configuration = {
     ft.theming.scheme = "catppuccin-latte";
     ft.theming.polarity = "light";
   };
   ```

   Then switch at runtime:
   ```bash
   sudo /run/current-system/specialisation/light/bin/switch-to-configuration switch
   ```

For a future "theme switcher" script, option 3 (specialisations) is the
recommended approach. It's native NixOS, fully declarative, and instant.

---

## Adding a New Application to Theming

If you add a new app that Stylix supports, it's themed automatically
(`autoEnable = true`). Just enable it via home-manager.

If Stylix does NOT support the app, you can still use the base16 colors
in your config:

```nix
{ config, ... }:
let
  colors = config.lib.stylix.colors;
in
{
  # Access individual base16 colors:
  # colors.base00  → background
  # colors.base05  → foreground
  # colors.base08  → red
  # colors.base0D  → blue
  # etc.
}
```
