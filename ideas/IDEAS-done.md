# Ft-Nixos — Completed Flakes

Flakes that are already built, published, and integrated into the config.

---

## Done

### ft-nixpalette — Base16 Color Theming Engine

| | |
|:---|:---|
| **Purpose** | Generates colors from themes — the root of all theming |
| **Pattern** | Base16 color scheme generator |
| **Provides** | `config.lib.stylix.colors` with `base00`–`base0F`, wallpaper path, font config |
| **Used by** | Everything else in the ecosystem |
| **Repo** | `github:FT-nixforge/nixpalette` |
| **Status** | ✅ Done — integrated at system + home level |

---

### ft-nixpalette-hyprland — Hyprland-Specific Theming

| | |
|:---|:---|
| **Purpose** | Bundles ft-nixpalette + stylix + swww for Hyprland desktops |
| **Pattern** | NixOS module + Home Manager module |
| **Provides** | `nixpalette` system module, `stylix` HM integration, `swww` wallpaper daemon, `nixpalette-switch` script, themed configs for waybar, hyprlock, rofi/wofi |
| **Used by** | This NixOS config (`hosts/laptop`) |
| **Repo** | `github:FT-nixforge/nixpalette-hyprland` |
| **Status** | ✅ Done — loaded as `nixosModules.default` and `homeModules.default` |

---

### ft-nixprism — Modern App Launcher

| | |
|:---|:---|
| **Purpose** | Replaces rofi with a Stylix-themed, centered, blurred launcher |
| **Pattern** | Package + Home Manager module |
| **Provides** | `programs.nixprism` HM options (`enable`, `stylixIntegration`, `hyprlandIntegration`, `keybind`) |
| **Trigger** | `SUPER+Space` |
| **Used by** | Hyprland keybindings (`$menu = nixprism`) |
| **Repo** | `github:FT-nixforge/nixprism` |
| **Status** | ✅ Done — loaded via `home-manager.sharedModules` |

---

## Dependency Graph

```
ft-nixpalette (root theming engine)
    └── ft-nixpalette-hyprland (Hyprland integration bundle)
            └── ft-nixprism (launcher with stylix integration)
```

---

## Integration Points in This Config

| Flake | Where It's Used |
|-------|-----------------|
| `ft-nixpalette` | System: `modules/theming/default.nix` → `nixpalette.enable = true` |
| `ft-nixpalette-hyprland` | System: `flake.nix` → `inputs.nixpalette-hyprland.nixosModules.default` |
| `ft-nixpalette-hyprland` | Home: `flake.nix` → `home-manager.sharedModules` |
| `ft-nixprism` | Home: `flake.nix` → `home-manager.sharedModules` |
| `ft-nixprism` | Home: `home/features/daily-tools.nix` → `programs.nixprism.enable = true` |
| `ft-nixprism` | Home: `home/features/desktop/hyprland/hyprland.nix` → `$menu = nixprism` |

---

*Last updated: 2026-04-19*
