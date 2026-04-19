# Ft-Nixos — Completed Flakes

Flakes that are already built, published, and integrated into the config.

All flakes live under [`github:FT-nixforge`](https://github.com/FT-nixforge).

---

## Design Principle

No flake depends on a "sub-flake" that is specific to a single DE/compositor.
For example:
- ✅ `ft-nixprism` depends directly on `ft-nixpalette` (generic theming)
- ❌ `ft-nixprism` would **never** depend on `ft-nixpalette-hyprland` (Hyprland-specific)

Only purpose-built flakes (e.g. a Hyprland-specific tool) may depend on Hyprland-specific inputs. General-purpose flakes stay generic.

---

## Done

### ft-nixpalette — Base16 Color Theming Engine

| | |
|:---|:---|
| **Purpose** | Generates colors from themes — the root of all theming |
| **Pattern** | Base16 color scheme generator |
| **Provides** | `config.lib.stylix.colors` with `base00`–`base0F`, wallpaper path, font config |
| **Used by** | Everything else in the ecosystem |
| **Repo** | [`github:FT-nixforge/nixpalette`](https://github.com/FT-nixforge/nixpalette) |
| **Status** | ✅ Done — integrated at system + home level |

---

### ft-nixpalette-hyprland — Hyprland-Specific Theming Bundle

| | |
|:---|:---|
| **Purpose** | Bundles ft-nixpalette + stylix + swww **specifically** for Hyprland desktops |
| **Pattern** | NixOS module + Home Manager module |
| **Provides** | `nixpalette` system module, `stylix` HM integration, `swww` wallpaper daemon, `nixpalette-switch` script, themed configs for waybar, hyprlock, rofi/wofi |
| **Used by** | This NixOS config (`hosts/laptop`) only — it's a **config-specific bundle**, not a library |
| **Repo** | [`github:FT-nixforge/nixpalette-hyprland`](https://github.com/FT-nixforge/nixpalette-hyprland) |
| **Status** | ✅ Done — loaded as `nixosModules.default` and `homeModules.default` |
| **Note** | This is a **bundle flake**, not a dependency. Other flakes consume `ft-nixpalette` directly, never this. |

---

### ft-nixprism — Modern App Launcher

| | |
|:---|:---|
| **Purpose** | Replaces rofi with a Stylix-themed, centered, blurred launcher |
| **Pattern** | Package + Home Manager module |
| **Provides** | `programs.nixprism` HM options (`enable`, `stylixIntegration`, `hyprlandIntegration`, `keybind`) |
| **Depends on** | `ft-nixpalette` (for Stylix colors) — **not** `ft-nixpalette-hyprland` |
| **Trigger** | `SUPER+Space` |
| **Used by** | Hyprland keybindings (`$menu = nixprism`) |
| **Repo** | [`github:FT-nixforge/nixprism`](https://github.com/FT-nixforge/nixprism) |
| **Status** | ✅ Done — loaded via `home-manager.sharedModules` |

---

## Dependency Graph

```
ft-nixpalette (root theming engine — generic)
    └── ft-nixprism (launcher — generic, stylix integration)

ft-nixpalette-hyprland is NOT in this graph — it's a config bundle,
not a library dependency. It consumes ft-nixpalette directly.
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
